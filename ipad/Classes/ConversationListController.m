#import "ConversationListController.h"

#import "LoginFormController.h"
#import "ChatDialogController.h"
#import "InitialViewController.h"
#import "ContentContainerController.h"
#import "ConversationCell.h"
#import "ConversationListModel.h"
#import "ReceivedMessage.h"
#import "NibUtils.h"

@interface ConversationListController()
- (void) activateChatDialog:(UIViewController *) chatDialogController;
- (ChatDialogController *) newChatDialog:(MsnContact *) contact setSelected:(BOOL)selected;
- (void) reloadAllCellsExceptAtIndexPath:(NSIndexPath *) indexPath;
@end

@implementation ConversationListController

- (id) initWithCoder:(NSCoder *)coder {
	if (self = [super initWithCoder:coder]) {
		eventDispatcher = [EventDispatcher sharedInstance];
		messengerService = [[MessengerService alloc] init];
		model = [[ConversationListModel alloc] init];
	}
	return self;
}

- (void) viewDidLoad {
	// Register for events
	[eventDispatcher registerTarget:self action:@selector(handleReceivedMessage:) forEvent:[ReceivedMessage class]];
	[eventDispatcher registerTarget:self action:@selector(contactUpdated:) forEvent:[ContactUpdatedEvent class]];
	
	// Set background
	UIImageView *background = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"conversations-bg.jpg"]] autorelease];
	[background setContentMode:UIViewContentModeTop];
	[[self tableView] setBackgroundView:background];

	// Pre-instantiate login form
	loginFormController = [[LoginFormController alloc] init];
	[loginFormController setLoginDelegate:self];
	[loginFormController setContactListDelegate:self];
	
	popoverController = [[UIPopoverController alloc] initWithContentViewController:loginFormController];
	[popoverController setPopoverContentSize:CGSizeMake(445, 171)];
	[popoverController setDelegate:loginFormController];
	[loginFormController setPopoverController:popoverController];

	// Check if we are already logged in
	NSError *error;
	// TODO - Do this asynchronously
	BOOL loggedIn = [messengerService isLoggedIn:&error];
	if (loggedIn) {
		[eventDispatcher startDispatching];
		//[messengerService requestContactList:&error];
	}
}

- (void) viewDidUnload {
	[eventDispatcher unregisterAllEventsForTarget:self];
}

- (void) handleReceivedMessage:(ReceivedMessage *) message {
	MsnContact *contact = [message contact];
	ChatDialogController *chatDialogController = [model conversationByContactEmail:[contact email]];
	if (!chatDialogController) {
		ChatDialogController *controller = [self newChatDialog:contact setSelected:NO];
		[controller messageReceived:message];
	}
}

- (void) contactUpdated:(ContactUpdatedEvent *) event {
	MsnContact *updatedContact = [event updatedContact];
	
	ChatDialogController *chatDialogController = [model conversationByContactEmail:[updatedContact email]];
	[chatDialogController updateContact:updatedContact];

	NSIndexPath *indexPath = [model indexPathForConversation:chatDialogController];
	[[self tableView] reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (IBAction) showLoginPopover:(UIButton *) barButton {
	[popoverController presentPopoverFromRect:[barButton frame] inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}


- (void) loginToMsnWithEmail:(NSString *) email andPassword:(NSString *) password {
	NSError *error = nil;
	[messengerService loginWithEmail:email andPassword:password error:&error];
	if (error) {
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:[error localizedDescription]
														 message:[error localizedFailureReason]
														delegate:nil 
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil] autorelease];		
		[alert show];
		return;
	}
	[eventDispatcher startDispatching];
}

- (void) closeWindow:(MsnContact *) contact {
	ChatDialogController *chatDialogController = [model conversationByContactEmail:[contact email]];
	[eventDispatcher unregisterAllEventsForTarget:chatDialogController];
	
	// Remove ChatDialogController from the list
	NSIndexPath *removedControllerIndexPath = [model removeConversation:chatDialogController];
	[[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:removedControllerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
	[self reloadAllCellsExceptAtIndexPath:removedControllerIndexPath];

	// Decide on which ChatDialogController to activate next
	UIViewController *nextController;
	if ([model isEmpty]) {
		nextController = [[[InitialViewController alloc] initWithNibName:@"InitialViewController" bundle:nil] autorelease];
	} else if ([removedControllerIndexPath row] > 0) {
		[[self tableView] selectRowAtIndexPath:[NSIndexPath indexPathForRow:[removedControllerIndexPath row] - 1 inSection:0] 
												animated:NO 
										scrollPosition:UITableViewScrollPositionNone];
		nextController = [model conversationAtIndex:[removedControllerIndexPath row] - 1];
	} else {
		[[self tableView] selectRowAtIndexPath:[NSIndexPath indexPathForRow:[removedControllerIndexPath row] inSection:0] 
												animated:NO 
										scrollPosition:UITableViewScrollPositionNone];
		nextController = [model conversationAtIndex:[removedControllerIndexPath row]];
	}
	if ([nextController isKindOfClass:[ChatDialogController class]]) {
		ChatDialogController *conversation = (ChatDialogController *) nextController;
		[model resetNewMessagesCount:conversation];
		[[self tableView] reloadRowsAtIndexPaths:[NSArray arrayWithObject:[model indexPathForConversation:conversation]] withRowAnimation:UITableViewRowAnimationNone];
	}

	[self activateChatDialog:nextController];
}

- (void) newMessageReceived:(ChatDialogController *) controller {
	NSIndexPath *selectedIndexPath = [[self tableView] indexPathForSelectedRow];
	BOOL selected = [[model indexPathForConversation:controller] isEqual:selectedIndexPath];
	if (!selected) {
		[model raiseNewMessagesCount:controller];
	}
	[[self tableView] reloadRowsAtIndexPaths:[NSArray arrayWithObject:[model indexPathForConversation:controller]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void) contactSelected:(MsnContact *) contact {
	[popoverController dismissPopoverAnimated:YES];
	
	ChatDialogController *chatDialogController = [model conversationByContactEmail:[contact email]];
	
	if (!chatDialogController) {
		chatDialogController = [self newChatDialog:contact setSelected:YES];
	}

	[self activateChatDialog:chatDialogController];

	NSIndexPath *indexPath = [model indexPathForConversation:chatDialogController];
	[[self tableView] selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (ChatDialogController *) newChatDialog:(MsnContact *) contact setSelected:(BOOL)selected {
	ChatDialogController *chatDialogController = [[[ChatDialogController alloc] initWithContact:contact] autorelease];
	[chatDialogController setChatDialogDelegate:self];
	
	NSIndexPath *indexPath = [model addConversation:chatDialogController];

	[[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
	if (selected) {
		[[self tableView] selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
	} else {
		[[self tableView] deselectRowAtIndexPath:indexPath animated:NO];
	}
	[self reloadAllCellsExceptAtIndexPath:indexPath];

	return chatDialogController;
}

- (void) reloadAllCellsExceptAtIndexPath:(NSIndexPath *) indexPath {
	NSMutableArray *reloadIndexPaths = [NSMutableArray array];
	for (int i = 0; i < [model conversationsCount]; i++) {
		if (i != [indexPath row]) {
			[reloadIndexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
		}
	}
	
	[[self tableView] reloadRowsAtIndexPaths:reloadIndexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void) activateChatDialog:(UIViewController *) chatDialogController {
	NSArray *viewControllers = [splitViewController viewControllers];
	// TODO - Tom: Set ContentContainerController directly from XIB?
	ContentContainerController *contentContainerController = [viewControllers objectAtIndex:1];
	[contentContainerController setContentController:chatDialogController];
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [model conversationsCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConversationCell *cell = (ConversationCell *)[tableView dequeueReusableCellWithIdentifier:@"ConversationCell"];
    if (cell == nil) {
        cell = [NibUtils loadView:[ConversationCell class] fromNib:@"ConversationCell"];
    }
	ChatDialogController *conversation = [model conversationAtIndex:[indexPath row]];
	
    int newMessagesCount = [model newMessagesCount:conversation];
	BOOL first = [indexPath row] == 0;
	BOOL last = [indexPath row] == [model conversationsCount] - 1;
	[cell setContact:[conversation contact] first:first last:last newMessagesCount:newMessagesCount];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	ChatDialogController *chatDialogController = [model conversationAtIndex:[indexPath row]];
	[self activateChatDialog:chatDialogController];
	
	[model resetNewMessagesCount:chatDialogController];
	[[self tableView] reloadRowsAtIndexPaths:[NSArray arrayWithObject:[model indexPathForConversation:chatDialogController]] withRowAnimation:UITableViewRowAnimationNone];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 70;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[messengerService release];
	[popoverController release];
	[loginFormController release];
	[model release];
    [super dealloc];
}

@end

