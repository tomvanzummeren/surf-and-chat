#import "MsnContact.h"

@protocol ContactListControllerDelegate <NSObject>

- (void) contactSelected:(MsnContact *) contact;

@end
