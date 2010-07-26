@class MsnContact;

@interface MessengerService : NSObject {
	
}

- (void) loginWithEmail:(NSString *) email andPassword:(NSString *) password error:(NSError **) error;

- (void) sendMessage:(NSString *) message to:(NSString *) recepientEmail error:(NSError **) error;

- (void) changeProfileDisplayName:(NSString *) displayName andPersonalMessage:(NSString *) personalMessage;

- (void) requestAvatarForContact:(MsnContact *) contact error:(NSError **) error;

- (BOOL) isLoggedIn:(NSError **) error;

- (void) requestContactList:(NSError **) error;

- (UIImage *) downloadAvatar:(MsnContact *) contact;

- (NSArray *) receiveEvents;

@end
