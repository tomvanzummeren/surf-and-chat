#import "Message.h"
#import "CellHeight.h"

@interface Message()
- (void) calculateHeights;
@end

@implementation Message

@synthesize text, sender, cellHeight, avatar, mine;

- (void) calculateHeights {
	// Calculate and add cell heights
	CGSize landscapeTextSize = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(430, 99999)];
	CGSize portraitTextSize = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(495, 99999)];
	
	CGFloat landscapeHeight = landscapeTextSize.height + 50;
	CGFloat portraitHeight = portraitTextSize.height + 50;

	cellHeight = [[CellHeight alloc] init];
	[cellHeight setLandscapeOrientation:landscapeHeight > 69 ? landscapeHeight : 69];
	[cellHeight setPortraitOrientation:portraitHeight > 69 ? portraitHeight : 69];
}

- (void) setText:(NSString *)textToSet {
	if (text == textToSet) {
		return;
	}
	[text release];
	text = textToSet;
	[text retain];
	
	[self calculateHeights];
}

- (void) dealloc {
	[text release];
	[sender release];
	[cellHeight release];
	[avatar release];
	[super dealloc];
}

@end
