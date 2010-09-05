#import "BaseTableViewController.h"
#import "ContactListControllerDelegate.h"

@class EventDispatcher;
@class MessengerService;

@interface ContactListController : BaseTableViewController {
	
	IBOutlet MessengerService *messengerService;

	id<ContactListControllerDelegate> contactListDelegate;
	
@private
	NSArray *contactGroups;

	NSArray *filteredContactGroups;

	EventDispatcher *eventDispatcher;
	
}

@property (readwrite, nonatomic, retain) id<ContactListControllerDelegate> contactListDelegate;

- (id) initWithContactList:(NSArray *) contactGroups;

- (IBAction) toggleHideOfflineContacts:(UISwitch *) sender;

- (IBAction) logOut;

@end
