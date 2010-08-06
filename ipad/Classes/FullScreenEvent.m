#import "FullScreenEvent.h"

@implementation FullScreenEvent

@synthesize viewController;

- (void)dealloc {
	[viewController release];
    [super dealloc];
}

@end
