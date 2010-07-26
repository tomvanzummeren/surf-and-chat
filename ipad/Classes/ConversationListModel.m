
#import "ConversationListModel.h"
#import "ChatDialogController.h"
#import "MsnContact.h"

@implementation ConversationListModel

- (id) init {
	if (self = [super init]) {
		conversations = [[NSMutableArray alloc] init];
		newMessagesCounts = [[NSMutableArray alloc] init];
	}
	return self;
}

- (ChatDialogController *) conversationByContactEmail:(NSString *) contactEmail {
	for (ChatDialogController *conversation in conversations) {
		if ([[[conversation contact] email] isEqual:contactEmail]) {
			return conversation;
		}
	}
	return nil;
}

- (ChatDialogController *) conversationAtIndex:(int) index {
	return [conversations objectAtIndex:index];
}

- (NSIndexPath *) indexPathForConversation:(ChatDialogController *) conversation {
	int index = [conversations indexOfObject:conversation];
	return [NSIndexPath indexPathForRow:index inSection:0];
}

- (NSIndexPath *) removeConversation:(ChatDialogController *) conversation {
	int index = [conversations indexOfObject:conversation];
	[conversations removeObjectAtIndex:index];
	[newMessagesCounts removeObjectAtIndex:index];
	return [NSIndexPath indexPathForRow:index inSection:0];
}

- (NSIndexPath *) addConversation:(ChatDialogController *) conversation {
	[conversations addObject:conversation];
	[newMessagesCounts addObject:[NSNumber numberWithInt:0]];
	
	int index = [conversations indexOfObject:conversation];
	return [NSIndexPath indexPathForRow:index inSection:0];
}

- (BOOL) isEmpty {
	return [self conversationsCount] == 0;
}

- (int) conversationsCount {
	return [conversations count];
}

- (void) raiseNewMessagesCount:(ChatDialogController *) conversation {
	int index = [conversations indexOfObject:conversation];
	NSNumber *count = [newMessagesCounts objectAtIndex:index];
	[newMessagesCounts replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:[count intValue] + 1]];
}

- (void) resetNewMessagesCount:(ChatDialogController *) conversation {
	int index = [conversations indexOfObject:conversation];
	[newMessagesCounts replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:0]];
}

- (int) newMessagesCount:(ChatDialogController *) conversation {
	int index = [conversations indexOfObject:conversation];
	return [[newMessagesCounts objectAtIndex:index] intValue];
}

- (void) dealloc {
	[conversations release];
	[newMessagesCounts release];
	[super dealloc];
}

@end
