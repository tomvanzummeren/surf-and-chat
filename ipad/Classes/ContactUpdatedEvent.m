#import "ContactUpdatedEvent.h"

@implementation ContactUpdatedEvent

@synthesize updatedContact;

- (id) initWithJson:(NSDictionary *) eventJson {
	if (self = [super init]) {
		updatedContact = [[MsnContact alloc] initWithJson:[eventJson objectForKey:@"contact"]];
	}
	return self;
}

- (void) dealloc {
	[updatedContact release];
	[super dealloc];
}

@end
