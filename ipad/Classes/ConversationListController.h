#import "LoginFormControllerDelegate.h"
#import "ContactListControllerDelegate.h"
#import "ChatDialogControllerDelegate.h"

@class MessengerService;
@class LoginFormController;
@class EventDispatcher;
@class ConversationListModel;

@interface ConversationListController : UITableViewController<LoginFormControllerDelegate, ContactListControllerDelegate, ChatDialogControllerDelegate> {

	IBOutlet UISplitViewController *splitViewController;
	
@private 
	MessengerService *messengerService;
	
	UIPopoverController *popoverController;
	
	LoginFormController *loginFormController;
	
	EventDispatcher *eventDispatcher;
	
	ConversationListModel *model;
}


- (IBAction) showLoginPopover:(UIButton *) barButton;

@end
