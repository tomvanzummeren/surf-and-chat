#import "DragNavigationBarDelegate.h"

@class ConversationListController;
@class WebPageListController;

@interface LeftPanelController : UIViewController<DragNavigationBarDelegate> {
	
	IBOutlet UIImageView *conversationListShadeImage;
	
	IBOutlet WebPageListController *webPageListController;
	
	IBOutlet ConversationListController *conversationListController;
}
@end
