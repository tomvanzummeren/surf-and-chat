@class ProfileStore;
@class MessengerService;

@interface ProfileController : UIViewController {

	IBOutlet MessengerService *messengerService;
	
	IBOutlet UITextField *displayNameField;

	IBOutlet UITextField *personalMessageField;
	
	@private
	ProfileStore *profileStore;
}

- (IBAction) saveProfileAndClose;

@end
