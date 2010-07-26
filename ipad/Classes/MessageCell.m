#import "MessageCell.h"
#import "Message.h"
#import "Layout.h"
#import "CellHeight.h"

@interface MessageCell()

- (NSString *) getCurrentTimeAsString;

@end


@implementation MessageCell

@synthesize delegate, message;

- (id) initWithCoder:(NSCoder *) coder {
	if (self = [super initWithCoder:coder]) {
		UIView *transparentView = [[[UIView alloc] init] autorelease];
		[transparentView setBackgroundColor:[UIColor clearColor]];
		[self setBackgroundView:transparentView];
		
		timeFormatter = [[NSDateFormatter alloc] init];
		[timeFormatter setDateFormat:@"H:mm"];
	}
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void) setToStillTyping {
	// Resize message container to a small size
	[messageContainerView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
	[Layout setX:533 y:14 width:45 height:39 onView:messageContainerView];
	
	// Hide other elements
	[timeLabel setHidden:YES];
	[messageTextView setHidden:YES];
	[senderNameLabel setHidden:YES];
	// Show dots, indicating that other user is typing
	[dotsLabel setHidden:NO];
}

- (void) animateToFullSizedMessage {
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(toFullSizeAnimationFinished:finished:context:)];

	if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
		int animateToHeight = [[message cellHeight] landscapeOrientation];
		[Layout setX:125 y:4 width:453 height:animateToHeight - 9 onView:messageContainerView];
	} else {
		int animateToHeight = [[message cellHeight] portraitOrientation];
		[Layout setX:125 y:4 width:518 height:animateToHeight - 9 onView:messageContainerView];
	}
	[dotsLabel setAlpha:0.0];

	[UIView commitAnimations];

}

- (void) toFullSizeAnimationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	[messageContainerView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
	[timeLabel setHidden:NO];
	[messageTextView setHidden:NO];
	[senderNameLabel setHidden:NO];

	[dotsLabel setAlpha:1.0];
	[dotsLabel setHidden:YES];
	
	[delegate finishedAnimatingToFullSizeMessage:message];
}

- (void) setMessage:(Message *) messageToSet {
	if (messageToSet != message) {
		[message release];
		message = messageToSet;
		[message retain];
	}
	
	// Initialize the textview
	[messageTextView setContentInset:UIEdgeInsetsMake(-4, 0, 0, 0)];
	
	[senderNameLabel setText:[[message sender] name]];
	[messageTextView setText:[message text]];
	
	if ([message avatar]) {
		[avatarView setImage:[message avatar]];
	} else {
		[avatarView setImage:[UIImage imageNamed:@"default-avatar.png"]];
	}
	
	NSString *timeString = [self getCurrentTimeAsString];
	[timeLabel setText:timeString];
}

- (void) updateText {
	[messageTextView setText:[message text]];
}

- (NSString *) getCurrentTimeAsString {
	return [timeFormatter stringFromDate:[NSDate date]];
}

- (void)dealloc {
	[senderNameLabel release];
	[messageTextView release];
	[avatarView release];
	[timeFormatter release];
	[message release];
	[super dealloc];
}

@end
