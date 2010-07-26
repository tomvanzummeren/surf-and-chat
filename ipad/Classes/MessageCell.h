#import "MessageCellDelegate.h";

@class Message;
@class CellHeight;

@interface MessageCell : UITableViewCell {
	
	IBOutlet UILabel *senderNameLabel;
	
	IBOutlet UITextView *messageTextView;
	
	IBOutlet UILabel *timeLabel;
	
	IBOutlet UIImageView *avatarView;
	
	IBOutlet UIView *messageContainerView;
	
	IBOutlet UILabel *dotsLabel;
	
	Message *message;
	
	id<MessageCellDelegate> delegate;
	
@private
	NSDateFormatter *timeFormatter;
}

@property (retain, nonatomic) id<MessageCellDelegate> delegate;

@property (retain, nonatomic) Message *message;

- (void) setToStillTyping;

- (void) animateToFullSizedMessage;

- (void) setMessage:(Message *) message;

- (void) updateText;

@end
