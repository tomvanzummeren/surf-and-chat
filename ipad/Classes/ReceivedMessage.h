#import "MsnContact.h"

@interface ReceivedMessage : NSObject {

	MsnContact *contact;
	
	NSString *text;
}

@property (readonly, nonatomic) MsnContact *contact;

@property (readonly, nonatomic) NSString *text;

- (id) initWithJson:(NSDictionary *) json;

@end
