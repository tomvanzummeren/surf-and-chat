#import "LeftPanelController.h"
#import "ConversationListController.h"
#import "WebPageListController.h"
#import "ProfileController.h"
#import "UINavigationBar+SolidBackground.h"

@interface ContentContainerController : UIViewController<UISplitViewControllerDelegate> {

	IBOutlet UINavigationBar *navigationBar;
	
	UIView *contentView;
	
	UIViewController *contentController;
}

- (IBAction) showProfileSettings:(UIButton *) barButton;

- (void) setContentController:(UIViewController *) contentController;

@end
