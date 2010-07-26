#import "NibUtils.h"

@implementation NibUtils

+ (id)loadView:(Class)viewClass fromNib:(NSString *)nibName {
	NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
	for(id currentObject in topLevelObjects) {
		if([currentObject isKindOfClass:viewClass]) {
			return currentObject;
		}
	}
	return nil;
}
@end
