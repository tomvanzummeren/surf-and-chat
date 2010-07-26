#import "ContactListEvent.h"

@implementation ContactListEvent

@synthesize groups;

- (id) initWithJson:(NSDictionary *) eventJson {
	if (self = [super init]) {
		
		NSMutableArray *mutableGroups = [NSMutableArray array];
		for (NSDictionary *groupJson in [eventJson objectForKey:@"groups"]) {
			MsnGroup *group = [[[MsnGroup alloc] initWithJson:groupJson] autorelease];
			[mutableGroups addObject:group];
		}
		
		groups = mutableGroups;
		[groups retain];
	}
	return self;
}

- (void) dealloc {
	[groups release];
	[super dealloc];
}

@end
