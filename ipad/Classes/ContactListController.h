#import "MsnGroup.h"
#import "MsnContact.h"
#import "ContactCell.h"
#import "ContactUpdatedEvent.h"
#import "EventDispatcher.h"
#import "ContactListControllerDelegate.h"

@interface ContactListController : UITableViewController {

	id<ContactListControllerDelegate> contactListDelegate;
	
@private
	NSArray *contactGroups;

	NSArray *filteredContactGroups;

	EventDispatcher *eventDispatcher;
	
}

@property (readwrite, nonatomic, retain) id<ContactListControllerDelegate> contactListDelegate;

- (id) initWithContactList:(NSArray *) contactGroups;

- (IBAction) toggleHideOfflineContacts:(UISwitch *) sender;

@end
