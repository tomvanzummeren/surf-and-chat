@class ContentContainerController;

@interface SurfAndChatAppDelegate : NSObject <UIApplicationDelegate> {
    
    IBOutlet UIWindow *window;
	
	IBOutlet UISplitViewController *splitViewController;
	
	IBOutlet ContentContainerController *contentContainerController;
}

@end
