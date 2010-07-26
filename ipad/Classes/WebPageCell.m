#import "WebPageCell.h"

@implementation WebPageCell

- (id) initWithCoder:(NSCoder *)coder {
	if (self = [super initWithCoder:coder]) {
		
		UIView *transparentView = [[[UIView alloc] init] autorelease];
		[transparentView setBackgroundColor:[UIColor clearColor]];
		[self setBackgroundView:transparentView];

		selectedBorderColor = [UIColor colorWithRed:43/255.0 green:70/255.0 blue:51/255.0 alpha:1.0];
		[selectedBorderColor retain];
		topBorderColor = [UIColor colorWithRed:132/255.0 green:164/255.0 blue:140/255.0 alpha:1.0];
		[topBorderColor retain];
		bottomBorderColor = [UIColor colorWithRed:50/255.0 green:83/255.0 blue:59/255.0 alpha:1.0];
		[bottomBorderColor retain];
	}
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[selectedWebpageBgView setHidden:!selected];
	[leftBorderImage setHidden:!selected];

	[titleLabel setHighlighted:selected];
	[urlLabel setHighlighted:selected];

	if (selected) {
		[topBorderView setBackgroundColor:selectedBorderColor];
		[bottomBorderView setBackgroundColor:selectedBorderColor];
	} else {
		[topBorderView setBackgroundColor:topBorderColor];
		[bottomBorderView setBackgroundColor:bottomBorderColor];
	}
	[topBorderView setHidden:first && !selected];
	[bottomBorderView setHidden:last && !selected];
}

- (void) setWebPageTitle:(NSString *) title andUrl:(NSString *) url first:(BOOL) isFirst last:(BOOL) isLast {
	BOOL selected = [self isSelected];
	first = isFirst;
	last = isLast;
	[topBorderView setHidden:first && !selected];
	[bottomBorderView setHidden:last && !selected];

	[titleLabel setText:title];
	[urlLabel setText:url];
}

- (void)dealloc {
	[titleLabel release];
	[urlLabel release];
	[leftBorderImage release];
	[selectedWebpageBgView release];
	[topBorderView release];
	[bottomBorderView release];
	[selectedBorderColor release];
	[topBorderColor release];
	[bottomBorderColor release];
   [super dealloc];
}

@end
