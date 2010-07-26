#import "SurfAndChatAppDelegate.h"

@implementation SurfAndChatAppDelegate

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	[splitViewController setDelegate:contentContainerController];
	
	[window addSubview:[splitViewController view]];
	[window makeKeyAndVisible];
    return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [window release];
	[splitViewController release];
	[contentContainerController release];
    [super dealloc];
}


@end

