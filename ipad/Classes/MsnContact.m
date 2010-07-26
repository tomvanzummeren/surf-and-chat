#import "MsnContact.h"

@implementation MsnContact

@synthesize email, name, personalMessage, status, identifier;

- (id) initWithJson:(NSDictionary *) contactJson {
	if (self = [super init]) {
		identifier = [contactJson objectForKey:@"id"];
		email = [contactJson objectForKey:@"email"];
		name = [contactJson objectForKey:@"name"];
		personalMessage = [contactJson objectForKey:@"personalMessage"];
		status = [contactJson objectForKey:@"status"];
	}
	return self;
}

- (BOOL) sameIdentifier:(MsnContact *) other {
	NSString *otherId = [other identifier];
	if (otherId == nil && [self identifier] == nil) {
		return YES;
	}
	return [otherId isEqual:[self identifier]];
}

- (void) dealloc {
	[identifier release];
	[email release];
	[name release];
	[personalMessage release];
	[status release];
	[super dealloc];
}

@end
