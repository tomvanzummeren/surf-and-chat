#import "MsnGroup.h"

@implementation MsnGroup

@synthesize identifier, name, contacts;

- (id) initWithJson:(NSDictionary *) groupJson {
	if (self = [super init]) {
		
		identifier = [groupJson objectForKey:@"id"];
		name = [groupJson objectForKey:@"name"];
		
		NSMutableArray *mutableContacts = [NSMutableArray array];
		for (NSDictionary *contactJson in [groupJson objectForKey:@"contacts"]) {
			MsnContact *contact = [[[MsnContact alloc] initWithJson:contactJson] autorelease];
			[mutableContacts addObject:contact];
		}
		
		contacts = mutableContacts;
		[contacts retain];
	}
	return self;
}

- (id) initWithIdentifier:(NSString *) identifierToSet name:(NSString *) nameToSet andContacts:(NSArray *) contactsToSet {
	if (self = [super init]) {
		identifier = identifierToSet;
		name = nameToSet;
		contacts = contactsToSet;
		
		[identifier retain];
		[name retain];
		[contacts retain];
	}
	return self;
}

- (void) replaceContact:(MsnContact *) contact with:(MsnContact *) replaceContact {
	NSMutableArray *mutableContacts = (NSMutableArray *) contacts;
	int existingContactIndex = [mutableContacts indexOfObject:contact];
	[mutableContacts replaceObjectAtIndex:existingContactIndex withObject:replaceContact];
}

- (void) dealloc {
	[identifier release];
	[name release];
	[contacts release];
	[super dealloc];
}

@end
