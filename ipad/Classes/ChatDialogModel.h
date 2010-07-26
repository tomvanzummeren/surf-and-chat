@class Message;

@interface ChatDialogModel : NSObject {
	
  @private
	NSMutableArray *messages;

	CGFloat totalCellHeightInPortraitOrientation;
	
	CGFloat totalCellHeightInLandscapeOrientation;
}

@property (readonly, nonatomic) CGFloat totalCellHeightInPortraitOrientation;

@property (readonly, nonatomic) CGFloat totalCellHeightInLandscapeOrientation;

- (NSIndexPath *) indexPathLastMessage;

- (Message *) lastMessage;

- (NSIndexPath *) indexPathOfMessage:(Message *) message;

/*!
 * Adds a message to the chat dialog.
 *
 * @return the index path at which the new message cell should be inserted into. This is NOT the index path of the message cell itself.
 */
- (NSIndexPath *) addMessage:(Message *) message;

- (NSIndexPath *) addMessageBeforeLast:(Message *) message;

- (Message *) findMessageByIndexPath:(NSIndexPath *) indexPath;

- (int) messagesCount;

- (NSIndexPath *) removeMessage:(Message *) message;

- (void) changeTextTo:(NSString *) text forMessage:(Message *) message;

- (void) appendText:(NSString *) text toMessage:(Message *) message;

@end
