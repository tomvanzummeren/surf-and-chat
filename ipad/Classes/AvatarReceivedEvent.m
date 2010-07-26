#import "AvatarReceivedEvent.h"

@implementation AvatarReceivedEvent

@synthesize contactId;

- (id) initWithJson:(NSDictionary *) json {
	if (self = [super init]) {
		contactId = [json objectForKey:@"contactId"];
	}
	return self;
}

- (void) dealloc {
	[contactId release];
	[super dealloc];
}

@end
