@protocol LoginFormControllerDelegate <NSObject>

@required

	- (void) loginToMsnWithEmail:(NSString *) email andPassword:(NSString *) password;

@end
