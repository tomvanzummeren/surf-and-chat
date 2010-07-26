#import "MsnContact.h"

@interface ContactUpdatedEvent : NSObject {

@private
	MsnContact *updatedContact;
	
}

@property(retain, nonatomic, readonly) MsnContact *updatedContact;

- (id) initWithJson:(NSDictionary *) eventJson;

@end
