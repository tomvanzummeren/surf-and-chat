#import "WebPageCell.h"
#import "NibUtils.h"
#import "WebPageListController.h"
#import "WebBrowserController.h"
#import "ContentContainerController.h"

@implementation WebPageListController

- (id) initWithCoder:(NSCoder *)coder {
	if (self = [super initWithCoder:coder]) {
		webBrowsers = [NSMutableArray array];
		[webBrowsers retain];
	}
	return self;
}

#pragma mark -
#pragma mark View life cycle

- (void) viewDidLoad {
	UIImageView *background = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"webpages-bg.jpg"]] autorelease];
	[background setContentMode:UIViewContentModeTop];
	[[self tableView] setBackgroundView:background];
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [webBrowsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	WebPageCell *cell = (WebPageCell *)[tableView dequeueReusableCellWithIdentifier:@"WebPageCell"];
	if (cell == nil) {
       cell = [NibUtils loadView:[WebPageCell class] fromNib:@"WebPageCell"];
    }
	
	BOOL first = [indexPath row] == 0;
	BOOL last = [indexPath row] == [webBrowsers count] - 1;
	
	WebBrowserController *webBrowser = [webBrowsers objectAtIndex:[indexPath row]];
	
	[cell setWebPageTitle:[webBrowser pageTitle] 
				   andUrl:[webBrowser pageUrl] 
					first:first 
					 last:last];
    
   return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	WebBrowserController *webBrowser = [webBrowsers objectAtIndex:[indexPath row]];
	[contentContainerController setContentController:webBrowser];
}

#pragma mark -
#pragma mark Actions

- (IBAction) addWebBrowser {
	WebBrowserController *webBrowser = [[[WebBrowserController alloc] init] autorelease];
	[webBrowsers addObject:webBrowser];
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[webBrowsers count] - 1 inSection:0];
	[[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
	[[self tableView] selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[webBrowsers release];
    [super dealloc];
}

@end

