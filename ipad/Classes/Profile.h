@interface Profile : NSObject {

	NSString *displayName;
	
	NSString *personalMessage;
}

@property (readwrite, retain, nonatomic) NSString *displayName;

@property (readwrite, retain, nonatomic) NSString *personalMessage;

@end
