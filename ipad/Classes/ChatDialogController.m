#import "ChatDialogController.h"

#import "LoginFormController.h"
#import "NibUtils.h"
#import "MessageCell.h"
#import "PlaceholderCell.h"
#import "CellHeight.h"
#import "Message.h"
#import "ChatDialogModel.h"
#import "MsnContact.h"
#import "ReceivedMessage.h"
#import "AvatarReceivedEvent.h"
#import "UserIsTypingEvent.h"

@interface ChatDialogController()
- (void) initializeContactInfo;
- (void) appendMessage:(NSString *) messageText fromSender:(MsnContact *) sender usingAvatar:(UIImage *) avatar whichIsMine:(BOOL) mine;
- (void) animateEntireViewToHeight:(CGFloat) height;
- (BOOL) isInLandscapeOrientation;
- (void) stopIndicatingUserIsTyping;
@end

@implementation ChatDialogController

@synthesize chatDialogDelegate, contact;

- (id) initWithContact:(MsnContact *) contactToSet {
	if (self = [super initWithNibName:@"ChatDialogController" bundle:nil]) {
		eventDispatcher = [EventDispatcher sharedInstance];
		[eventDispatcher registerTarget:self action:@selector(messageReceived:) forEvent:[ReceivedMessage class]];
		[eventDispatcher registerTarget:self action:@selector(avatarReceived:) forEvent:[AvatarReceivedEvent class]];
		[eventDispatcher registerTarget:self action:@selector(indicateUserIsTyping:) forEvent:[UserIsTypingEvent class]];

		contact = contactToSet;
		[contact retain];
		
		model = [[ChatDialogModel alloc] init];
		
		selfContact = [[MsnContact alloc] init];
		[selfContact setName:@"Surf & Chat"];
	}
	return self;
}

- (void) updateContact:(MsnContact *) updatedContact {
	[contact release];
	contact = updatedContact;
	[updatedContact retain];
	
	[self initializeContactInfo];
}

- (void) initializeContactInfo {
	UINavigationItem *item = [navigationBar topItem];
	[item setTitle:[contact name]];

	NSError *error;
	// TODO: Server could send avatar request automatically instead. In that case this call isn't necessary
	[messengerService requestAvatarForContact:contact error:&error];
}

#pragma mark -
#pragma mark Actions

- (IBAction) sendMessage:(UITextField *) textField {
	NSString *messageText = [textField text];
	[textField setText:@""];

	// TODO: Get name from NSDefault
	[self appendMessage:messageText fromSender:selfContact usingAvatar:myAvatar whichIsMine:YES];
	
	NSError *error;
	[messengerService sendMessage:messageText to:[contact email] error:&error];
	if (error) {
		// TODO: Don't show alerts for failed to send messages, queue them up instead and send them later
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:[error localizedDescription]
														 message:[error localizedFailureReason]
														delegate:nil 
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil] autorelease];		
		[alert show];
		return;
	}
	
	didJustSendMessage = YES;
}

- (IBAction) closeWindow {
	[chatDialogDelegate closeWindow:contact];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	if ([self isInLandscapeOrientation]) {
		[self animateEntireViewToHeight:352];
	} else {
		[self animateEntireViewToHeight:696];
	}

	[[self tableView] scrollToRowAtIndexPath:[model indexPathLastMessage] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	if (didJustSendMessage) {
		didJustSendMessage = NO;
		return NO;
	}
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if ([self isInLandscapeOrientation]) {
		[self animateEntireViewToHeight:704];
	} else {
		[self animateEntireViewToHeight:960];
	}
}

- (void) animateEntireViewToHeight:(CGFloat) height {
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
	// 0.3 seconds is the exact same time the keyboard popup animation needs, so both animations are in sync
    [UIView setAnimationDuration:0.3];
    
	CGRect viewFrame = [self view].frame;
	viewFrame.size.height = height;
    [[self view] setFrame:viewFrame];
    
    [UIView commitAnimations];

	[[self tableView] reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void) appendMessage:(NSString *) messageText fromSender:(MsnContact *) sender usingAvatar:(UIImage *) avatar whichIsMine:(BOOL) mine {
	if (![messageText isEqualToString:@""] && !mine) {
		[chatDialogDelegate newMessageReceived:self];
	}
	if (![messageText isEqualToString:@""]) {
		Message *lastMessage = [model lastMessage];
		if ([[lastMessage sender] sameIdentifier:sender]) {
			[model appendText:messageText toMessage:lastMessage];
			
			[[self tableView] beginUpdates];
			if (!mine) {
				[self stopIndicatingUserIsTyping];
			}
			[[self tableView] reloadRowsAtIndexPaths:[NSArray arrayWithObject:[model indexPathOfMessage:lastMessage]] withRowAnimation:UITableViewRowAnimationNone];
			[[self tableView] endUpdates];

			[[self tableView] scrollToRowAtIndexPath:[model indexPathLastMessage] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
			return;
		}
	}
	if (!mine && stillTypingMessageCell) {
		[model changeTextTo:messageText forMessage:[stillTypingMessageCell message]];
		[stillTypingMessageCell updateText];

		[stillTypingMessageCell animateToFullSizedMessage];
		
		[stillTypingMessageCell release];
		stillTypingMessageCell = nil;
		
		return;
	}

	// Create and add message
	Message *message = [[[Message alloc] init] autorelease];
	[message setText:messageText];
	[message setSender:sender];
	[message setAvatar:avatar];
	[message setMine:mine];

	if (!stillTypingMessageCell) {
		NSIndexPath *indexPath = [model addMessage:message];
		[[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];

		// Animate scrolling to bottom cell
		[[self tableView] scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	} else {
		NSIndexPath *indexPath = [model addMessageBeforeLast:message];
		[[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
	}
	[[self tableView] reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -
#pragma mark MessageCell delegate

- (void) finishedAnimatingToFullSizeMessage:(Message *) message {
	NSIndexPath *indexPath = [model indexPathOfMessage:message];
	// Reload to update the cell's height
	[[self tableView] reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -
#pragma mark Processing incoming events

- (void) messageReceived:(ReceivedMessage *) receivedMessage {
	MsnContact *messageContact = [receivedMessage contact];
	if (![[messageContact email] isEqualToString:[contact email]]) {
		return;
	}
	[self appendMessage:[receivedMessage text] fromSender:messageContact usingAvatar:otherAvatar whichIsMine:NO];
}

- (void) indicateUserIsTyping:(UserIsTypingEvent *) event {
	MsnContact *messageContact = [event contact];
	if (![[messageContact email] isEqualToString:[contact email]]) {
		return;
	}
	if (!stillTypingMessageCell) {
		[self appendMessage:@"" fromSender:[event contact] usingAvatar:otherAvatar whichIsMine:NO];
	}
	
	[stillTypingCellRemovalTimer invalidate];
	[stillTypingCellRemovalTimer release];
	stillTypingCellRemovalTimer = nil;
	stillTypingCellRemovalTimer = [NSTimer timerWithTimeInterval:6.0 target:self selector:@selector(stopIndicatingUserIsTyping) userInfo:nil repeats:NO];
	[stillTypingCellRemovalTimer retain];
	[[NSRunLoop mainRunLoop] addTimer:stillTypingCellRemovalTimer forMode:NSDefaultRunLoopMode];
}

- (void) stopIndicatingUserIsTyping {
	if (!stillTypingMessageCell) {
		return;
	}
	NSIndexPath *removedCellIndexPath = [model removeMessage:[stillTypingMessageCell message]];

	[stillTypingMessageCell release];
	stillTypingMessageCell = nil;
	
	[[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:removedCellIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void) avatarReceived:(AvatarReceivedEvent *) avatarReceivedEvent {
	if (![[contact identifier] isEqualToString:[avatarReceivedEvent contactId]]) {
		return;
	}
	otherAvatar = [messengerService downloadAvatar:contact];
	[otherAvatar retain];
}

#pragma mark -
#pragma mark Controller life cycle

- (void) viewDidLoad {
	[self initializeContactInfo];

	UIView *background = [[[UIView alloc] init] autorelease];
	[background setBackgroundColor:[UIColor clearColor]];
	[[self tableView] setBackgroundView:background];
	[[self tableView] setBackgroundColor:[UIColor clearColor]];
	
	NSError *error;
	[messengerService requestAvatarForContact:contact error:&error];
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	// TODO: Correct table view height if keyboard is popped up
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [model messagesCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([indexPath row] == 0) {
		return [[[PlaceholderCell alloc] init] autorelease];
	}
		
	Message *message = [model findMessageByIndexPath:indexPath];
	
	MessageCell *messageCell;
	if ([message mine]) {
		messageCell = [NibUtils loadView:[MessageCell class] fromNib:@"MessageCellWithAvatarOnLeft"];
	} else {
		messageCell = [NibUtils loadView:[MessageCell class] fromNib:@"MessageCellWithAvatarOnRight"];
		if ([[message text] isEqualToString:@""]) {
			[messageCell setToStillTyping];
			
			if (stillTypingMessageCell != messageCell) {
				[stillTypingMessageCell release];
				stillTypingMessageCell = messageCell;
				[stillTypingMessageCell retain];
			}
		}
	}
	[messageCell setDelegate:self];
	[messageCell setMessage:message];
	
	return messageCell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	// Configure the height of the placeholder cell which always exists as the first cell in the table
	if ([indexPath row] == 0) {
		CGFloat tableViewHeight = [self tableView].frame.size.height;
		if ([self interfaceOrientation] == UIInterfaceOrientationLandscapeLeft || [self interfaceOrientation] == UIInterfaceOrientationLandscapeRight) {
			return tableViewHeight > [model totalCellHeightInLandscapeOrientation] ? tableViewHeight - [model totalCellHeightInLandscapeOrientation] : 0;
		}
		return tableViewHeight > [model totalCellHeightInPortraitOrientation] ? tableViewHeight - [model totalCellHeightInPortraitOrientation] : 0;
	}	
	// Configure the height of a message cell
	Message *message = [model findMessageByIndexPath:indexPath];
	CellHeight *cellHeight = [message cellHeight];
	return [self isInLandscapeOrientation] ? [cellHeight landscapeOrientation] : [cellHeight portraitOrientation];
}

- (BOOL) isInLandscapeOrientation {
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	return orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[eventDispatcher unregisterAllEventsForTarget:self];
	[contact release];
	[navigationBar release];
	[messengerService release];
	[messageTextField release];
	[myAvatar release];
	[otherAvatar release];
	[stillTypingMessageCell release];
	[model release];
	[stillTypingCellRemovalTimer release];
    [super dealloc];
}


@end
