#import "MessengerService.h"

@interface ProfileController : UIViewController {

	IBOutlet MessengerService *messengerService;
	
	IBOutlet UITextField *displayNameField;

	IBOutlet UITextField *personalMessageField;
}

- (IBAction) saveProfileAndClose;

@end
