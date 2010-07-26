#import "TargetActionPair.h"

@implementation TargetActionPair

@synthesize target, action;

- (void) executeForEvent:(id) event {
	[target performSelectorOnMainThread:action withObject:event waitUntilDone:YES];
}

- (void) dealloc {
	[target release];
	[super dealloc];
}

@end
