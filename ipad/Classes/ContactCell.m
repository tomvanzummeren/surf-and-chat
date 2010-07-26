#import "ContactCell.h"

@implementation ContactCell

- (id)init {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ContactCell"]) {
		NSMutableDictionary *mutableStatusIcons = [NSMutableDictionary dictionary];
		[mutableStatusIcons setObject:@"status-online.png" forKey:@"ONLINE"];
		[mutableStatusIcons setObject:@"status-offline.png" forKey:@"OFFLINE"];
		[mutableStatusIcons setObject:@"status-away.png" forKey:@"AWAY"];
		[mutableStatusIcons setObject:@"status-away.png" forKey:@"IDLE"];
		[mutableStatusIcons setObject:@"status-away.png" forKey:@"BE RIGHT BACK"];
		[mutableStatusIcons setObject:@"status-busy.png" forKey:@"BUSY"];
		[mutableStatusIcons setObject:@"status-busy.png" forKey:@"ON THE PHONE"];
		[mutableStatusIcons setObject:@"status-away.png" forKey:@"OUT TO LUNCH"];
		statusIcons = mutableStatusIcons;
		[statusIcons retain];
    }
    return self;
}

- (void) setContact:(MsnContact *) contact {
	[[self textLabel] setText:[contact name]];
	[[self detailTextLabel] setText:[contact personalMessage]];
	
	UIImage *statusIcon = [UIImage imageNamed:[statusIcons objectForKey:[contact status]]];
	if (statusIcon) {
		[[self imageView] setImage:statusIcon];
	}
}

- (void)dealloc {
	[statusIcons release];
    [super dealloc];
}


@end
