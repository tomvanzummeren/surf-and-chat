#import "LoginFormControllerDelegate.h"
#import "ContactListControllerDelegate.h"
#import "ChatDialogControllerDelegate.h"
#import "DeselectionDelegate.h"

@class MessengerService;
@class LoginFormController;
@class EventDispatcher;
@class ConversationListModel;

@interface ConversationListController : UITableViewController<LoginFormControllerDelegate, ContactListControllerDelegate, ChatDialogControllerDelegate, DeselectionDelegate> {

	IBOutlet UISplitViewController *splitViewController;
	
	IBOutlet UIView *rootView;
	
	IBOutlet id<DeselectionDelegate> deselectionDelegate;

@private 
	MessengerService *messengerService;
	
	UIPopoverController *popoverController;
	
	LoginFormController *loginFormController;
	
	EventDispatcher *eventDispatcher;
	
	ConversationListModel *model;
}


- (IBAction) showLoginPopover:(UIButton *) barButton;

@end
