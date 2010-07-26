#import "Profile.h"

@implementation Profile

@synthesize displayName, personalMessage;

- (void) dealloc {
	[displayName release];
	[personalMessage release];
	[super dealloc];
}

@end
