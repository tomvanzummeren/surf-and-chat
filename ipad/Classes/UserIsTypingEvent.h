#import "MsnContact.h"

@interface UserIsTypingEvent : NSObject {

@private
	MsnContact *contact;
	
}

@property(retain, nonatomic, readonly) MsnContact *contact;

- (id) initWithJson:(NSDictionary *) eventJson;

@end
