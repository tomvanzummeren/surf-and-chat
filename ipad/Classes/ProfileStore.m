#import "ProfileStore.h"

#import "Profile.h"

@implementation ProfileStore

- (void) storeProfile:(Profile *) profile {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setValue:[profile displayName] forKey:@"displayName"];
	[defaults setValue:[profile personalMessage] forKey:@"personalMessage"];
}

- (Profile *) loadProfile {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *displayName = [defaults valueForKey:@"displayName"];
	NSString *personalMessage = [defaults valueForKey:@"personalMessage"];
	
	return [[Profile alloc] initWithDisplayName:displayName 
								personalMessage:personalMessage];
}

@end
