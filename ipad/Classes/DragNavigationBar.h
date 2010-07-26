#import "DragNavigationBarDelegate.h"

@interface DragNavigationBar : UIView {
	
	IBOutlet id<DragNavigationBarDelegate> dragDelegate;
	
@private
	CGPoint previousTouchPoint;
}

@end
