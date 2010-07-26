#import "BaseTableViewController.h"
#import "LoginFormControllerDelegate.h"
#import "ChatDialogControllerDelegate.h"
#import "MessageCellDelegate.h"

@class MessengerService;
@class EventDispatcher;
@class MessageCell;
@class Message;
@class ReceivedMessage;
@class ChatDialogModel;

@interface ChatDialogController : BaseTableViewController <UIPopoverControllerDelegate, UITextFieldDelegate, MessageCellDelegate> {

	IBOutlet UINavigationBar *navigationBar;
	
	IBOutlet MessengerService *messengerService;
	
	IBOutlet UITextField *messageTextField;
	
@private
	ChatDialogModel *model;
	
	EventDispatcher *eventDispatcher;
	
	MsnContact *contact;
	
	id<ChatDialogControllerDelegate> chatDialogDelegate;
	
	BOOL didJustSendMessage;
	
	UIImage *myAvatar;

	UIImage *otherAvatar;
	
	NSTimer *stillTypingCellRemovalTimer;
	
	MsnContact *selfContact;
	
	// Still typing message
	
	MessageCell *stillTypingMessageCell;
}

@property(retain, nonatomic) id<ChatDialogControllerDelegate> chatDialogDelegate;

@property(readonly, nonatomic) MsnContact *contact;

- (id) initWithContact:(MsnContact *) contact;

- (void) updateContact:(MsnContact *) updatedContact;

- (IBAction) sendMessage:(UITextField *) textField;

- (IBAction) closeWindow;

- (void) messageReceived:(ReceivedMessage *) message;

@end
