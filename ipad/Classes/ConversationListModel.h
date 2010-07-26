@class ChatDialogController;

@interface ConversationListModel : NSObject {
	
  @private
	NSMutableArray *conversations;

	NSMutableArray *newMessagesCounts;
}

- (ChatDialogController *) conversationByContactEmail:(NSString *) contactEmail;

- (ChatDialogController *) conversationAtIndex:(int) index;

- (NSIndexPath *) addConversation:(ChatDialogController *) conversation;

- (NSIndexPath *) indexPathForConversation:(ChatDialogController *) conversation;

- (NSIndexPath *) removeConversation:(ChatDialogController *) conversation;

- (void) raiseNewMessagesCount:(ChatDialogController *) conversation;

- (void) resetNewMessagesCount:(ChatDialogController *) conversation;

- (int) newMessagesCount:(ChatDialogController *) conversation;

- (BOOL) isEmpty;

- (int) conversationsCount;

@end
