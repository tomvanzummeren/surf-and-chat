@class Profile;

@interface ProfileStore : NSObject {

}

- (void) storeProfile:(Profile *) profile;

- (Profile *) loadProfile;

@end
