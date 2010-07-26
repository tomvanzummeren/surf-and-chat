@class Message;

@protocol MessageCellDelegate <NSObject>

- (void) finishedAnimatingToFullSizeMessage:(Message *) message;

@end
