#import "DragNavigationBar.h"

@implementation DragNavigationBar

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *firstTouch = [touches anyObject];
	previousTouchPoint = [firstTouch locationInView:[self superview]];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesMoved:touches withEvent:event];

	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPoint = [touch locationInView:[self superview]];
	CGFloat movementDelta = currentTouchPoint.y - previousTouchPoint.y;
	previousTouchPoint = currentTouchPoint;
	
	[dragDelegate navigationBar:self dragged:movementDelta];
}

- (void) dealloc {
	[dragDelegate release];
	[super dealloc];
}

@end
