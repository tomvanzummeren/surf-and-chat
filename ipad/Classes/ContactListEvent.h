#import "MsnGroup.h"

@interface ContactListEvent : NSObject {
	
	NSArray *groups;
}

@property(retain, nonatomic, readonly) NSArray *groups;

- (id) initWithJson:(NSDictionary *) eventJson;

@end
