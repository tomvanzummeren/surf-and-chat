
@protocol DragNavigationBarDelegate <NSObject>

@required
	- (void) navigationBar:(UIView *) navigationBar dragged:(CGFloat) deltaY;

@end
