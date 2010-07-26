#import "MsnContact.h"

@interface MsnGroup : NSObject {

@private
	
	NSString *identifier;

	NSString *name;
	
	NSArray *contacts;
}

- (id) initWithJson:(NSDictionary *) groupJson;

- (id) initWithIdentifier:(NSString *) identifierToSet name:(NSString *) nameToSet andContacts:(NSArray *) contacts;

- (void) replaceContact:(MsnContact *) contact with:(MsnContact *) replaceContact;

@property(retain, nonatomic, readonly) NSString *identifier;

@property(retain, nonatomic, readonly) NSString *name;

@property(retain, nonatomic, readonly) NSArray *contacts;

@end
