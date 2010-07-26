#import "ProfileController.h"

@implementation ProfileController

- (id) init {
	if (self = [super initWithNibName:@"ProfileController" bundle:nil]) {
		
	}
	return self;
}

- (IBAction) saveProfileAndClose {
	NSString *displayName = [displayNameField text];
	NSString *personalMessage = [personalMessageField text];
	[messengerService changeProfileDisplayName:displayName andPersonalMessage:personalMessage];
	[self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)dealloc {
	[displayNameField release];
	[personalMessageField release];
    [super dealloc];
}

@end
