@class MsnContact;

@interface ConversationCell : UITableViewCell {

	IBOutlet UILabel *displayNameLabel;
	
	IBOutlet UILabel *personalMessageLabel;
	
	IBOutlet UIView *leftBorderImage;
	
	IBOutlet UIView *selectedConversationBgView;
	
	IBOutlet UIView *topBorderView;

	IBOutlet UIView *bottomBorderView;
	
	IBOutlet UIImageView *statusIconView;
	
	IBOutlet UILabel *newMessagesLabel;
	
	IBOutlet UIView *newMessagesContainer;

@private
	UIColor *selectedBorderColor;

	UIColor *topBorderColor;

	UIColor *bottomBorderColor;
	
	BOOL first;
	
	BOOL last;
}

- (void) setContact:(MsnContact *) contact first:(BOOL)first last:(BOOL)last newMessagesCount:(int) newMessagesCount;

@end
