#import "MessengerService.h"

#import "HttpRequest.h"
#import "SBJSON.h"
#import "ReceivedMessage.h"
#import "LoginSuccessEvent.h"
#import "LoginFailedEvent.h"
#import "ContactListEvent.h"
#import "ContactUpdatedEvent.h"
#import "MsnContact.h"
#import "AvatarReceivedEvent.h"
#import "UserIsTypingEvent.h"
#import "LogoutEvent.h"
#import "ProfileStore.h"
#import "Profile.h"

#ifndef DEBUG
// Live configuration
#define SERVER_URL @"http://tomvanzummeren.flexvps.nl:8080/msn"
#else
// Local development configuration
#define SERVER_URL @"http://localhost:8080/msn"
#endif

@interface MessengerService()
- (NSDictionary *) parseJson:(HttpRequest *) request error:(NSError **) error;
- (NSArray *) performReceiveEventsRequest:(NSError **) error;
- (UIImage *) loadImageFromUrl:(NSString *) urlString;
@end

@implementation MessengerService

#pragma mark -
#pragma mark Initializers

- (id) init {
	if (self = [super init]) {
		profileStore = [[ProfileStore alloc] init];
	}
	return self;
}

#pragma mark -
#pragma mark Public service methods

- (void) loginWithEmail:(NSString *) email andPassword:(NSString *) password error:(NSError **) error {
	Profile *profile = [profileStore loadProfile];
	
	NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:email, @"email", password, @"password", [profile displayName], @"displayName", [profile personalMessage], @"personalMessage", nil];
	HttpRequest *request = [[[HttpRequest alloc] initForPost:[NSString stringWithFormat:@"%@/api/login", SERVER_URL] withParameters:parameters] autorelease];
	NSError *httpError;
	[request perform:&httpError];
	if (httpError) {
		*error = httpError;
		return;
	}
	// Save session id to NSUserDefaults
	NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray *cookies = [cookieStorage cookiesForURL:[NSURL URLWithString:SERVER_URL]];
	for (NSHTTPCookie *cookie in cookies) {
		if ([[cookie name] isEqualToString:@"JSESSIONID"]) {
			if ([cookie isSessionOnly]) {
				NSLog(@"Cookie is session only and version %i", [cookie version]);
			}
			[[NSUserDefaults standardUserDefaults] setValue:[cookie value] forKey:@"lastSessionId"];
		}
	}
}

- (void) sendMessage:(NSString *) message to:(NSString *) recepientEmail error:(NSError **) error {
	NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:recepientEmail, @"email", message, @"text", nil];
	HttpRequest *request = [[[HttpRequest alloc] initForPost:[NSString stringWithFormat:@"%@/api/send", SERVER_URL] withParameters:parameters] autorelease];
	[request perform:error];
}

- (NSArray *) receiveEvents {
	while (YES) {
		NSError *error = nil;
		NSArray *receivedEvents = [self performReceiveEventsRequest:&error];
		
		if (!error) {
			return receivedEvents;
		}
		// Error code -1001 is request time-out
		if ([error code] != -1001) {
			UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Connection problem"
															 message:@"Failed to receive messages. The internet connection might not be available."
															delegate:nil 
												   cancelButtonTitle:@"OK" 
												   otherButtonTitles:nil] autorelease];		
			[alert show];
			return nil;
		}
		NSLog(@"Timed out, re-establishing request");
	}
}

- (NSArray *) performReceiveEventsRequest:(NSError **) error {
	NSLog(@"Performing receive events request ...");
	HttpRequest *request = [[[HttpRequest alloc] initForGet:[NSString stringWithFormat:@"%@/api/receive", SERVER_URL]] autorelease];
	NSError *jsonError;
	NSDictionary *rootJson = [self parseJson:request error:&jsonError];
	*error = nil;
	if (jsonError) {
		*error = jsonError;
		return nil;
	}
	
	NSArray *eventsJsonArray = [rootJson objectForKey:@"events"];
	NSLog(@"%i events received", [eventsJsonArray count]);
	
	NSMutableArray *receivedEvents = [[NSMutableArray alloc] initWithCapacity:[eventsJsonArray count]];
	for (NSDictionary *eventJson in eventsJsonArray) {
		id event;
		NSString *type = [eventJson objectForKey:@"type"];
		if ([@"instant-message" isEqual:type]) {
			event = [[[ReceivedMessage alloc] initWithJson:eventJson] autorelease];
		} else if ([@"login-success" isEqual:type]) {
			event = [[[LoginSuccessEvent alloc] init] autorelease];
		} else if ([@"login-failed" isEqual:type]) {
			event = [[[LoginFailedEvent alloc] init] autorelease];
		} else if ([@"contact-list" isEqual:type]) {
			event = [[[ContactListEvent alloc] initWithJson:eventJson] autorelease];
		} else if ([@"contact-updated" isEqual:type]) {
			event = [[[ContactUpdatedEvent alloc] initWithJson:eventJson] autorelease];
		} else if ([@"avatar-received" isEqual:type]) {
			event = [[[AvatarReceivedEvent alloc] initWithJson:eventJson] autorelease];
		} else if ([@"user-typing" isEqual:type]) {
			event = [[[UserIsTypingEvent alloc] initWithJson:eventJson] autorelease];
		} else if ([@"logout" isEqual:type]) {
			event = [[[LogoutEvent alloc] init] autorelease];
		} else {
			NSLog(@"Unknown event received: %@", type);
			continue;
		}
		NSLog(@"Event received of type '%@'", type);
		if (event) {
			[receivedEvents addObject:event];
		}
	}
	return receivedEvents;
}

- (void) requestAvatarForContact: (MsnContact *) contact error:(NSError **) error {
	NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[contact identifier], @"contactId", nil];
	HttpRequest *request = [[[HttpRequest alloc] initForPost:[NSString stringWithFormat:@"%@/api/requestavatar", SERVER_URL] withParameters:parameters] autorelease];
	[request perform:error];
}

- (UIImage *) downloadAvatar:(MsnContact *) contact {
	NSString *avatarUrl = [NSString stringWithFormat:@"%@/api/downloadavatar?contactId=%@", SERVER_URL, [contact identifier]];
	return [self loadImageFromUrl:avatarUrl];
}

- (void) changeProfileDisplayName:(NSString *) displayName andPersonalMessage:(NSString *) personalMessage {
	NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:displayName, @"displayName", personalMessage, @"personalMessage", nil];
	HttpRequest *request = [[[HttpRequest alloc] initForPost:[NSString stringWithFormat:@"%@/api/changeprofile", SERVER_URL] withParameters:parameters] autorelease];
	NSError *error;
	[request perform:&error];
}

- (UIImage *) loadImageFromUrl:(NSString *) urlString {
	NSLog(@"Loading avatar image: %@", urlString);
	
	HttpRequest *imageRequest = [[HttpRequest alloc] initForGet:urlString];
	NSError *error = nil;
	NSData *data = [imageRequest performForData:&error];
	if (error) {
		NSLog(@"Error loading avatar image: %@, %@", [error localizedDescription], [error localizedFailureReason]);
	}
	return [[[UIImage alloc] initWithData:data] autorelease];
}

- (BOOL) isLoggedIn:(NSError **) error {
	NSString *lastSessionId = [[NSUserDefaults standardUserDefaults] valueForKey:@"lastSessionId"];
	if (lastSessionId) {
		// Restore last used session id to reuse previous session
		NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
		
		NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
									[NSString stringWithFormat:@"%@/api/getloginstatus", SERVER_URL], NSHTTPCookieOriginURL,
									@"JSESSIONID", NSHTTPCookieName,
									lastSessionId, NSHTTPCookieValue,
									nil];
		[cookieStorage setCookie:[NSHTTPCookie cookieWithProperties:properties]];
	}

	HttpRequest *request = [[[HttpRequest alloc] initForPost:[NSString stringWithFormat:@"%@/api/getloginstatus", SERVER_URL] withParameters:[NSDictionary dictionary]] autorelease];
	NSError *jsonError;
	NSDictionary *rootJson = [self parseJson:request error:&jsonError];
	*error = nil;
	if (jsonError) {
		*error = jsonError;
		return NO;
	}
	return [[rootJson objectForKey:@"loggedIn"] boolValue];
}

- (void) requestContactList:(NSError **) error {
	HttpRequest *request = [[[HttpRequest alloc] initForPost:[NSString stringWithFormat:@"%@/api/requestcontactlist", SERVER_URL] withParameters:[NSDictionary dictionary]] autorelease];
	[request perform:error];	
}

- (void) logOut:(NSError **) error {
	HttpRequest *request = [[[HttpRequest alloc] initForPost:[NSString stringWithFormat:@"%@/api/logout", SERVER_URL] withParameters:[NSDictionary dictionary]] autorelease];
	[request perform:error];	
}

#pragma mark -
#pragma mark Json parsing

/*!
 * Performs the given request and parses the response body as JSON.
 *
 * @param request to perform
 * @return parsed JSON object
 */
- (NSDictionary *) parseJson:(HttpRequest *) request error:(NSError **) error {
	NSError *requestError;
	NSString *jsonResponse = [request perform:&requestError];
	NSLog(@"Performed request");
	*error = nil;
	if (requestError) {
		*error = requestError;
		return nil;
	}
	NSLog(@"%@", jsonResponse);
	
	SBJSON *jsonParser = [[SBJSON new] autorelease];
	NSError *jsonError;
	NSDictionary *rootJsonObject = (NSDictionary *)[jsonParser objectWithString:jsonResponse error:&jsonError];
	return rootJsonObject;
}

- (void) dealloc {
	[profileStore release];
	[super dealloc];
}

@end
