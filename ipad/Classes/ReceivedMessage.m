#import "ReceivedMessage.h"

@implementation ReceivedMessage

@synthesize contact, text;

- (id) initWithJson:(NSDictionary *) json {
	if (self = [super init]) {
		text = [json objectForKey:@"message"];
		
		NSDictionary *contactJson = [json objectForKey:@"contact"];
		contact = [[MsnContact alloc] initWithJson:contactJson];
	}
	return self;
}

- (void) dealloc {
	[contact release];
	[text release];
	[super dealloc];
}

@end
