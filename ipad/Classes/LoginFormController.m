#import "LoginFormController.h"
#import "LogoutEvent.h"

@interface LoginFormController()
- (void) shake;
@end


@implementation LoginFormController

@synthesize loginDelegate, popoverController, contactListDelegate;

- (id) init {
    if (self = [super initWithNibName:@"LoginFormView" bundle:nil]) {
		[self setTitle:@"Login to MSN Messenger"];
		eventDispatcher = [EventDispatcher sharedInstance];
		[eventDispatcher registerTarget:self action:@selector(loginFailed:) forEvent:[LoginFailedEvent class]];
		[eventDispatcher registerTarget:self action:@selector(initializeContactList:) forEvent:[ContactListEvent class]];
		[eventDispatcher registerTarget:self action:@selector(loggedOut:) forEvent:[LogoutEvent class]];
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	UIImage *blueButtonImage = [[UIImage imageNamed:@"blue-button.png"] stretchableImageWithLeftCapWidth:5.0 topCapHeight:0.0];
	[loginButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
}

- (IBAction) submitCredentials {
	[loginFailedLabel setHidden:YES];
	[activityIndicator startAnimating];
	
	NSString *email = [emailField text];
	NSString *password = [passwordField text];
	if ([email length] == 0 || [password length] == 0) {
		[self shake];
		return;
	}
	[loginDelegate loginToMsnWithEmail:email andPassword:password];
}

- (void) loggedOut:(LogoutEvent *) event {
	[eventDispatcher stopDispatching];

	[popoverController setPopoverContentSize:CGSizeMake(445, 171) animated:YES];
	[popoverController setContentViewController:self];
}

#pragma mark -
#pragma mark Shake animation

- (void) shake {
	UIView *shakeView = [self view];
    CGFloat impact = 5.0;
	
    CGAffineTransform leftShake  = CGAffineTransformTranslate(CGAffineTransformIdentity, impact, 0);
    CGAffineTransform rightShake = CGAffineTransformTranslate(CGAffineTransformIdentity, -impact, 0);
	
    [shakeView setTransform:leftShake];
	
    [UIView beginAnimations:@"shake" context:shakeView];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:5];
    [UIView setAnimationDuration:0.05];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(shakeAnimationEnded:finished:context:)];
	
    [shakeView setTransform:rightShake];
	
    [UIView commitAnimations];
}

- (void) shakeAnimationEnded:(NSString *) animationID finished:(NSNumber *) finished context:(void *) context {
    if ([finished boolValue]) {
        UIView* item = (UIView *) context;
        [item setTransform:CGAffineTransformIdentity];
    }
}

#pragma mark -
#pragma mark Processing incoming events

- (void) initializeContactList:(ContactListEvent *) event {
	[activityIndicator stopAnimating];
	NSArray *contactGroups = [event groups];
	ContactListController *controller = [[[ContactListController alloc] initWithContactList:contactGroups] autorelease];
	[controller setContactListDelegate:contactListDelegate];
	[popoverController setPopoverContentSize:CGSizeMake(320, 900) animated:YES];
	[popoverController setContentViewController:controller];
}

- (void) loginFailed:(LoginFailedEvent *) event {
	[self shake];
	[loginFailedLabel setHidden:NO];
	[activityIndicator stopAnimating];
}

#pragma mark -
#pragma mark Popover controller delegate

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
	return ![activityIndicator isAnimating];
}

#pragma mark -
#pragma mark Memory management

- (void) dealloc {
	[eventDispatcher unregisterAllEventsForTarget:self];

	[loginDelegate release];
	[loginButton release];
	[emailField release];
	[passwordField release];
	[popoverController release];
	[activityIndicator release];
	[loginFailedLabel release];
	[contactListDelegate release];
    [super dealloc];
}

@end
