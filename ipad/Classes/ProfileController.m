#import "ProfileController.h"

#import "MessengerService.h"
#import "ProfileStore.h"
#import "Profile.h"

@implementation ProfileController

- (id) init {
	if (self = [super initWithNibName:@"ProfileController" bundle:nil]) {
		profileStore = [[ProfileStore alloc] init];
	}
	return self;
}

- (void) viewDidLoad {
	[super viewDidLoad];
	
	Profile *savedProfile = [profileStore loadProfile];
	[displayNameField setText:[savedProfile displayName]];
	[personalMessageField setText:[savedProfile personalMessage]];
}

- (IBAction) saveProfileAndClose {
	NSString *displayName = [displayNameField text];
	NSString *personalMessage = [personalMessageField text];
	
	Profile *profile = [[Profile alloc] initWithDisplayName:displayName 
											personalMessage:personalMessage];
	[profileStore storeProfile:profile];
	
	[messengerService changeProfileDisplayName:displayName andPersonalMessage:personalMessage];
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)dealloc {
	[displayNameField release];
	[personalMessageField release];
	[profileStore release];
    [super dealloc];
}

@end
