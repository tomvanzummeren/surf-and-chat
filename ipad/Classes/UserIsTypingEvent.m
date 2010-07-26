#import "UserIsTypingEvent.h"

@implementation UserIsTypingEvent

@synthesize contact;

- (id) initWithJson:(NSDictionary *) eventJson {
	if (self = [super init]) {
		contact = [[MsnContact alloc] initWithJson:[eventJson objectForKey:@"contact"]];
	}
	return self;
}

- (void) dealloc {
	[contact release];
	[super dealloc];
}

@end
