#import "Profile.h"

@implementation Profile

@synthesize displayName, personalMessage;

- (id) initWithDisplayName:(NSString *) displayNameToSet personalMessage:(NSString *) personalMessageToSet {
	if (self = [super init]) {
		[self setDisplayName:displayNameToSet];
		[self setPersonalMessage:personalMessageToSet];
	}
	return self;
}

- (void) dealloc {
	[displayName release];
	[personalMessage release];
	[super dealloc];
}

@end
