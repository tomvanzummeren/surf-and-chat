#import "LoginFormControllerDelegate.h"
#import "ContactListController.h"
#import "ContactListEvent.h"
#import "LoginSuccessEvent.h"
#import "LoginFailedEvent.h"
#import "EventDispatcher.h"
#import "ContactListControllerDelegate.h"

@interface LoginFormController : UIViewController<UIPopoverControllerDelegate> {

	IBOutlet UITextField *emailField;
	
	IBOutlet UITextField *passwordField;

	IBOutlet UIButton *loginButton;
	
	IBOutlet UILabel *loginFailedLabel;
	
	IBOutlet UIActivityIndicatorView *activityIndicator;

@private
	
	id<LoginFormControllerDelegate> loginDelegate;
	
	id<ContactListControllerDelegate> contactListDelegate;

	UIPopoverController *popoverController;
	
	EventDispatcher *eventDispatcher;
	
}

@property(retain, nonatomic) id<LoginFormControllerDelegate> loginDelegate;

@property(retain, nonatomic) id<ContactListControllerDelegate> contactListDelegate;

@property(retain, nonatomic) UIPopoverController *popoverController;

- (IBAction) submitCredentials;

@end
