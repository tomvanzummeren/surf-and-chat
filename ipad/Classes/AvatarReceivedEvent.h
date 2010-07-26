
@interface AvatarReceivedEvent : NSObject {

@private
	NSString *contactId;
}

@property (readonly, retain, nonatomic) NSString *contactId;

- (id) initWithJson:(NSDictionary *) json;

@end
