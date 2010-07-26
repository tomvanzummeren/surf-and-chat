#import "InitialViewController.h"

@implementation InitialViewController

#pragma mark -
#pragma mark Splitview controller delegate

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)popoverController {
    [barButtonItem setTitle:@"Open windows"];
    [[navigationBar topItem] setLeftBarButtonItem:barButtonItem animated:YES];
}

- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    [[navigationBar topItem] setLeftBarButtonItem:nil animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)dealloc {
    [super dealloc];
}

@end
