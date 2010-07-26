#import "LeftPanelController.h"

@implementation LeftPanelController

- (void) navigationBar:(UIView *) navigationBar dragged:(CGFloat) deltaY {
	// Initialize variables
	CGFloat navigationBarY = [navigationBar frame].origin.y + deltaY;
	CGFloat navigationBarHeight = [navigationBar frame].size.height;
	CGFloat totalHeight = [[self view] frame].size.height;

	// Check boundaries
	CGFloat minimumY = navigationBarHeight;
	if (navigationBarY < minimumY) {
		navigationBarY = minimumY;
	}
	CGFloat maximumY = totalHeight - navigationBarHeight;
	if (navigationBarY > maximumY) {
		navigationBarY = maximumY;
	}
	
	// Set new navigation bar position
	CGRect navigationBarFrame = [navigationBar frame];
	navigationBarFrame.origin.y = navigationBarY;
	[navigationBar setFrame:navigationBarFrame];

	// Set new conversation list height
	CGRect conversationListFrame = [[conversationListController view] frame];
	conversationListFrame.size.height = navigationBarY - navigationBarHeight;
	[[conversationListController view] setFrame:conversationListFrame];

	// Set new conversation list shade image position
	CGRect conversationListShadeImageFrame = [conversationListShadeImage frame];
	conversationListShadeImageFrame.origin.y = navigationBarY - conversationListShadeImageFrame.size.height;
	[conversationListShadeImage setFrame:conversationListShadeImageFrame];

	// Set new webpage list height and position
	CGRect webPageListFrame = [[webPageListController view] frame];
	webPageListFrame.size.height = totalHeight - navigationBarHeight - navigationBarY;
	webPageListFrame.origin.y = navigationBarY + navigationBarHeight;
	[[webPageListController view] setFrame:webPageListFrame];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)dealloc {
	[conversationListController release];
	[webPageListController release];
	[conversationListShadeImage release];
   [super dealloc];
}

@end
