#import "ContactListController.h"

@interface ContactListController()
- (void) filterContactsAndGroupsOffline:(BOOL)filterOffline;
@end


@implementation ContactListController

@synthesize contactListDelegate;

- (id) initWithContactList:(NSArray *) contactGroupsToSet {
	if (self = [super initWithStyle:UITableViewStylePlain]) {
		[self setTitle:@"Contact List"];
		contactGroups = contactGroupsToSet;
		[contactGroups retain];
		
		eventDispatcher = [EventDispatcher sharedInstance];

		[self filterContactsAndGroupsOffline:NO];
	}
	return self;
}

#pragma mark -
#pragma mark View life cycle

- (void) viewDidLoad {
	[eventDispatcher registerTarget:self action:@selector(contactUpdated:) forEvent:[ContactUpdatedEvent class]];
}

- (void) viewDidUnload {
	[eventDispatcher unregisterAllEventsForTarget:self];
}

#pragma mark -
#pragma mark Filtering contacts

- (void) filterContactsAndGroupsOffline:(BOOL)filterOffline {
	NSMutableArray *mutableContactGroups = [NSMutableArray array];
	for (MsnGroup *group in contactGroups) {
		NSMutableArray *filteredContacts = [NSMutableArray array];
		for (MsnContact *contact in [group contacts]) {
			// Optionally filter offline contacts
			if (filterOffline && [[contact status] isEqual:@"OFFLINE"]) {
				continue;
			}
			[filteredContacts addObject:contact];
		}
		
		MsnGroup *filteredGroup = [[[MsnGroup alloc] initWithIdentifier:[group identifier] 
																					  name:[group name] 
																			 andContacts:filteredContacts] autorelease];
		[mutableContactGroups addObject:filteredGroup];
	}
	[filteredContactGroups release];
	[mutableContactGroups retain];
	filteredContactGroups = mutableContactGroups;
}

#pragma mark -
#pragma mark Processing incoming events

- (void) contactUpdated:(ContactUpdatedEvent *) event {
	MsnContact *updatedContact = [event updatedContact];
	for (int groupIndex = 0; groupIndex < [filteredContactGroups count]; groupIndex ++) {
		MsnGroup *group = [filteredContactGroups objectAtIndex:groupIndex];
		
		NSArray *contacts = [group contacts];
		for (int contactIndex = 0; contactIndex < [contacts count]; contactIndex ++) {
			MsnContact *contact = [contacts objectAtIndex:contactIndex];
			
			if ([[contact identifier] isEqual:[updatedContact identifier]]) {
				[group replaceContact:contact with:updatedContact];
				
				NSArray *updatedIndexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:contactIndex inSection:groupIndex]];

				[[self tableView] reloadRowsAtIndexPaths:updatedIndexPaths withRowAnimation:UITableViewRowAnimationNone];
			}
		}
	}
}

#pragma mark -
#pragma mark Actions

- (IBAction) toggleHideOfflineContacts:(UISwitch *) sender {
	[self filterContactsAndGroupsOffline:NO];
	[[self tableView] reloadData];
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [filteredContactGroups count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	MsnGroup *group = [filteredContactGroups objectAtIndex:section];
    return [[group contacts] count];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	MsnGroup *group = [filteredContactGroups objectAtIndex:section];
	return [group name];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactCell *cell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
    if (cell == nil) {
        cell = [[[ContactCell alloc] init] autorelease];
    }
	MsnGroup *group = [filteredContactGroups objectAtIndex:[indexPath section]];
	MsnContact *contact = [[group contacts] objectAtIndex:[indexPath row]];
	[cell setContact:contact];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MsnGroup *group = [filteredContactGroups objectAtIndex:[indexPath section]];
	MsnContact *contact = [[group contacts] objectAtIndex:[indexPath row]];

	[contactListDelegate contactSelected:contact];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[contactGroups release];
	[filteredContactGroups release];
	[contactListDelegate release];
    [super dealloc];
}

@end

