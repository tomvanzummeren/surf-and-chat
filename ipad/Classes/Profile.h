@interface Profile : NSObject {

	@private
	NSString *displayName;
	
	NSString *personalMessage;
}

- (id) initWithDisplayName:(NSString *) displayName personalMessage:(NSString *) personalMessage;

@property (readwrite, retain, nonatomic) NSString *displayName;

@property (readwrite, retain, nonatomic) NSString *personalMessage;

@end
