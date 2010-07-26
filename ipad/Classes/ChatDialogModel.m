#import "ChatDialogModel.h"
#import "Message.h"
#import "CellHeight.h"

@interface ChatDialogModel()

- (void) addMessage:(Message *) message atIndex:(int) index;
- (void) addCellHeightForMessage:(Message *) message;
- (void) subtractCellHeightForMessage:(Message *) message;

@end


@implementation ChatDialogModel

@synthesize totalCellHeightInPortraitOrientation, totalCellHeightInLandscapeOrientation;

- (id) init {
	if (self = [super init]) {
		messages = [[NSMutableArray alloc] init];
	}
	return self;
}

- (NSIndexPath *) indexPathLastMessage {
	return [NSIndexPath indexPathForRow:[messages count] inSection:0];
}

- (Message *) lastMessage {
	if ([messages count] == 0) {
		return nil;
	}
	Message *message = [messages lastObject];
	if (![[message text] isEqualToString:@""]) {
		return message;
	}
	if ([messages count] < 2) {
		return nil;
	}
	return [messages objectAtIndex:[messages count] - 2];
}

- (NSIndexPath *) indexPathOfMessage:(Message *) message {
	int rowIndex = [messages indexOfObject:message];
	return [NSIndexPath indexPathForRow:rowIndex + 1 inSection:0];
}

- (NSIndexPath *) addMessage:(Message *) message {
	[self addMessage:message atIndex:[messages count]];

	return [NSIndexPath indexPathForRow:[messages count] inSection:0];
}

- (NSIndexPath *) addMessageBeforeLast:(Message *) message {
	int beforeLastIndex = [messages count] - 1;
	[self addMessage:message atIndex:beforeLastIndex];

	return [NSIndexPath indexPathForRow:beforeLastIndex + 1 inSection:0];
}

- (void) addMessage:(Message *) message atIndex:(int) index {
	[messages insertObject:message atIndex:index];

	[self addCellHeightForMessage:message];
}

- (Message *) findMessageByIndexPath:(NSIndexPath *) indexPath {
	return [messages objectAtIndex:[indexPath row] - 1];
}

- (int) messagesCount {
	return [messages count] + 1;
}

- (NSIndexPath *) removeMessage:(Message *) message {
	int messageIndex = [messages indexOfObject:message];

	[messages removeObject:message];
	[self subtractCellHeightForMessage:message];
	
	return [NSIndexPath indexPathForRow:messageIndex + 1 inSection:0];
}

- (void) changeTextTo:(NSString *) text forMessage:(Message *) message {
	[self subtractCellHeightForMessage:message];
	[message setText:text];
	[self addCellHeightForMessage:message];
}

- (void) appendText:(NSString *) appendText toMessage:(Message *) message {
	NSString *messageText = [message text];
	NSMutableString *combinedText = [NSMutableString string];
	[combinedText appendString:messageText];
	[combinedText appendString:@"\n"];
	[combinedText appendString:appendText];

	[self changeTextTo:combinedText forMessage:message];
}

#pragma mark -
#pragma mark Private methods

- (void) addCellHeightForMessage:(Message *) message {
	totalCellHeightInPortraitOrientation += [[message cellHeight] portraitOrientation];
	totalCellHeightInLandscapeOrientation += [[message cellHeight] landscapeOrientation];
}

- (void) subtractCellHeightForMessage:(Message *) message {
	totalCellHeightInPortraitOrientation -= [[message cellHeight] portraitOrientation];
	totalCellHeightInLandscapeOrientation -= [[message cellHeight] landscapeOrientation];
}

- (void) dealloc {
	[messages release];
	[super dealloc];
}

@end
