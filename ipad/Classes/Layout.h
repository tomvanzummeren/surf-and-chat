@interface Layout : NSObject {
}

+ (void) setX:(CGFloat) x y:(CGFloat) y width:(CGFloat) width height:(CGFloat) height onView:(UIView *) view;

+ (void) setHeight:(CGFloat) height onView:(UIView *) view;

@end
