#import "MsnContact.h"

@interface ContactCell : UITableViewCell {

@private
	
	NSDictionary *statusIcons;
}

- (void) setContact:(MsnContact *) contact;

@end
