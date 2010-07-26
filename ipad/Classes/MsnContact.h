@interface MsnContact : NSObject {

@private

	NSString *identifier;
	
	NSString *email;

	NSString *name;

	NSString *personalMessage;

	NSString *status;
}

- (id) initWithJson:(NSDictionary *) contactJson;

- (BOOL) sameIdentifier:(MsnContact *) other;

@property(retain, nonatomic) NSString *identifier;

@property(retain, nonatomic) NSString *email;

@property(retain, nonatomic) NSString *name;

@property(retain, nonatomic) NSString *personalMessage;

@property(retain, nonatomic) NSString *status;

@end
