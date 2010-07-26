#import "UINavigationBar+SolidBackground.h"

@implementation UINavigationBar(CustomBackground)

- (void) drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColor(context, CGColorGetComponents( [[self tintColor] CGColor]));
	CGContextFillRect(context, rect);
}

@end
