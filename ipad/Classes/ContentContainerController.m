#import "ContentContainerController.h"

@implementation ContentContainerController

- (void) setContentController:(UIViewController *) contentControllerToSet {
	[contentView removeFromSuperview];
	contentView = [contentControllerToSet view];

	contentController = contentControllerToSet;
	[contentController retain];
	
	CGSize viewSize = [[self view] frame].size;
	[contentView setFrame:CGRectMake(0, 44, viewSize.width, viewSize.height - 44)];
	[[self view] addSubview:contentView];
}

- (void) viewDidLoad {
//	[self setContentController:[[[ChatDialogController alloc] initWithContact:[[[MsnContact alloc] init] autorelease]] autorelease]];
	
	[navigationBar setTintColor:[UIColor colorWithRed:48/255.0 green:48/255.0 blue:48/255.0 alpha:1.0]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[contentController willRotateToInterfaceOrientation:duration duration:duration];
}

- (IBAction) showProfileSettings:(UIButton *) barButton {
	ProfileController *profileController = [[[ProfileController alloc] init] autorelease];
	[profileController setModalPresentationStyle:UIModalPresentationFormSheet];
	[profileController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	
	[self presentModalViewController:profileController animated:YES];
}

#pragma mark -
#pragma mark Splitview controller delegate

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)popoverController {
//	[[navigationBar topItem] setLeftBarButtonItem:conversationsButton animated:YES];
}

- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
//	[[navigationBar topItem] setLeftBarButtonItem:nil animated:YES];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationBar release];
	[contentController release];
    [super dealloc];
}

@end
