#import "ConversationCell.h"
#import "MsnContact.h"

// Our conversion definition
#define DEGREES_TO_RADIANS(angle) ((angle / 180.0) * M_PI)

@implementation ConversationCell

- (id) initWithCoder:(NSCoder *)coder {
	if (self = [super initWithCoder:coder]) {
		
		UIView *transparentView = [[[UIView alloc] init] autorelease];
		[transparentView setBackgroundColor:[UIColor clearColor]];
		[self setBackgroundView:transparentView];
		
		selectedBorderColor = [UIColor colorWithRed:31/255.0 green:61/255.0 blue:72/255.0 alpha:1.0];
		[selectedBorderColor retain];
		topBorderColor = [UIColor colorWithRed:123/255.0 green:155/255.0 blue:166/255.0 alpha:1.0];
		[topBorderColor retain];
		bottomBorderColor = [UIColor colorWithRed:93/255.0 green:93/255.0 blue:93/255.0 alpha:1.0];
		[bottomBorderColor retain];
	}
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[selectedConversationBgView setHidden:!selected];
	[leftBorderImage setHidden:!selected];
	[displayNameLabel setHighlighted:selected];
	[personalMessageLabel setHighlighted:selected];

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

- (void) setContact:(MsnContact *) contact first:(BOOL)isFirst last:(BOOL)isLast newMessagesCount:(int)newMessagesCount {
	BOOL selected = [self isSelected];
	first = isFirst;
	last = isLast;
	[topBorderView setHidden:first && !selected];
	[bottomBorderView setHidden:last && !selected];
	
	[displayNameLabel setText:[contact name]];

	[personalMessageLabel setText:[contact personalMessage]];
	CGRect dnFrame = [displayNameLabel frame];
	CGRect siFrame = [statusIconView frame];
	if ([@"" isEqualToString:[contact personalMessage]]) {
		dnFrame.origin.y = 23;
		siFrame.origin.y = 26;
	} else {
		dnFrame.origin.y = 12;
		siFrame.origin.y = 15;
	}
	[displayNameLabel setFrame:dnFrame];
	[statusIconView setFrame:siFrame];
	
	if ([[contact status] isEqualToString:@"OFFLINE"]) {
		[displayNameLabel setAlpha:0.4];
		[personalMessageLabel setAlpha:0.4];
	} else {
		[displayNameLabel setAlpha:1.0];
		[personalMessageLabel setAlpha:1.0];
	}

	if ([[contact status] isEqualToString:@"ONLINE"] || [[contact status] isEqualToString:@"OFFLINE"]) {
		[statusIconView setImage:nil];
	} else if ([[contact status] isEqualToString:@"AWAY"] || [[contact status] isEqualToString:@"IDLE"] || [[contact status] isEqualToString:@"BE RIGHT BACK"] || [[contact status] isEqualToString:@"OUT TO LUNCH"]) {
		[statusIconView setImage:[UIImage imageNamed:@"icon-away.png"]];
	} else if ([[contact status] isEqualToString:@"BUSY"] || [[contact status] isEqualToString:@"ON THE PHONE"]) {
		[statusIconView setImage:[UIImage imageNamed:@"icon-busy.png"]];
	}

	if (newMessagesCount > 99) {
		[newMessagesLabel setText:@"99+"];
	} else {
		[newMessagesLabel setText:[NSString stringWithFormat:@"%i", newMessagesCount]];
	}
	[newMessagesContainer setHidden:newMessagesCount == 0];
	
	[newMessagesContainer setTransform:CGAffineTransformRotate(CGAffineTransformMakeTranslation(0, 0), DEGREES_TO_RADIANS(0))];
	
	// Little whobble animation
    [UIView beginAnimations:@"whobble" context:newMessagesContainer];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:3];
    [UIView setAnimationDuration:0.08];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(whobbleAnimationEnded:finished:context:)];
	
	[newMessagesContainer setTransform:CGAffineTransformRotate(CGAffineTransformMakeTranslation(-3, -2), DEGREES_TO_RADIANS(-10))];
	
    [UIView commitAnimations];	
}

- (void) whobbleAnimationEnded:(NSString *) animationID finished:(NSNumber *) finished context:(void *) context {
	if (![finished boolValue] ){
		return;
	}
	[newMessagesContainer setTransform:CGAffineTransformRotate(CGAffineTransformMakeTranslation(0, 0), DEGREES_TO_RADIANS(0))];
}

- (void)dealloc {
	[displayNameLabel release];
	[personalMessageLabel release];
	[leftBorderImage release];
	[selectedConversationBgView release];
	[topBorderView release];
	[bottomBorderView release];
	[statusIconView release];
	[selectedBorderColor release];
	[topBorderColor release];
	[bottomBorderColor release];
	[newMessagesLabel release];
	[newMessagesContainer release];
	[super dealloc];
}

@end
