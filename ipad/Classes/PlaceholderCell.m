#import "PlaceholderCell.h"

@implementation PlaceholderCell

- (id)init {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PlaceholderCell"])) {
		UIView *transparentView = [[[UIView alloc] init] autorelease];
		[transparentView setBackgroundColor:[UIColor clearColor]];
		[self setBackgroundView:transparentView];
		[self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
