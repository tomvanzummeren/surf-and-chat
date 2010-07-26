#import "WebPageListController.h"

@implementation WebPageListController

- (void) viewDidLoad {
	UIImageView *background = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"webpages-bg.jpg"]] autorelease];
	[background setContentMode:UIViewContentModeTop];
	[[self tableView] setBackgroundView:background];
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	WebPageCell *cell = (WebPageCell *)[tableView dequeueReusableCellWithIdentifier:@"WebPageCell"];
	if (cell == nil) {
       cell = [NibUtils loadView:[WebPageCell class] fromNib:@"WebPageCell"];
   }
	
	BOOL first = [indexPath row] == 0;
	BOOL last = [indexPath row] == 3 - 1;
	[cell setWebPageTitle:[NSString stringWithFormat:@"Page %i", [indexPath row]] andUrl:@"Detail" first:first last:last];
    
   return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [super dealloc];
}

@end

