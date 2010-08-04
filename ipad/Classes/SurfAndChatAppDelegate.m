#import "SurfAndChatAppDelegate.h"

#import "ContentContainerController.h"
#import "EventDispatcher.h"
#import "FullScreenEvent.h"

@implementation SurfAndChatAppDelegate

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	[splitViewController setDelegate:contentContainerController];
	
	[window addSubview:[splitViewController view]];
	[window makeKeyAndVisible];
	
	[[EventDispatcher sharedInstance] registerTarget:self action:@selector(showInFullScreen:) forEvent:[FullScreenEvent class]];
	
    return YES;
}

- (void) showInFullScreen:(FullScreenEvent *) event {
	// TOOD - Make below work :)
	
//	UIViewController *viewController = [event viewController];
//	[[splitViewController view] removeFromSuperview];
//	[window addSubview:[viewController view]];
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

