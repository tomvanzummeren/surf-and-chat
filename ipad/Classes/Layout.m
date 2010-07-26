#import "Layout.h"

@implementation Layout

+ (void) setX:(CGFloat) x y:(CGFloat) y width:(CGFloat) width height:(CGFloat) height onView:(UIView *) view {
	CGRect viewFrame = view.frame;
	viewFrame.origin.x = x;
	viewFrame.origin.y = y;
	viewFrame.size.width = width;
	viewFrame.size.height = height;
    [view setFrame:viewFrame];
}

+ (void) setHeight:(CGFloat) height onView:(UIView *) view {
	CGRect viewFrame = view.frame;
	viewFrame.size.height = height;
    [view setFrame:viewFrame];
}

- (void) dealloc {
	[super dealloc];
}
@end
