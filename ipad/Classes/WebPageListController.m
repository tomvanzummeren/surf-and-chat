#import "WebPageCell.h"
#import "NibUtils.h"
#import "WebPageListController.h"
#import "WebBrowserController.h"
#import "ContentContainerController.h"
#import "InitialViewController.h"

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
	[deselectionDelegate deselect];
	WebBrowserController *webBrowser = [webBrowsers objectAtIndex:[indexPath row]];
	[contentContainerController setContentController:webBrowser];
}

#pragma mark -
#pragma mark Actions

- (IBAction) addWebBrowser {
	WebBrowserController *webBrowser = [[[WebBrowserController alloc] init] autorelease];
	[webBrowser setDelegate:self];
	[webBrowsers addObject:webBrowser];
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[webBrowsers count] - 1 inSection:0];
	[[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
	
	// Select the new row
	[[self tableView] selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
	// Also actually perform the selected row action on top of visually selecting the new row
	[self tableView:[self tableView] didSelectRowAtIndexPath:indexPath];
}

- (void) pageUrlChanged:(WebBrowserController *) webBrowser {
	int row = [webBrowsers indexOfObject:webBrowser];
	if (row == -1) {
		NSLog(@"ERROR: Changed page URL, but controller not found in list");
		return;
	}
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
	[[self tableView] reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void) deselect {
	[[self tableView] deselectRowAtIndexPath:[[self tableView] indexPathForSelectedRow] animated:YES];
}

- (void) closeWindow:(WebBrowserController *) webBrowser {
	// Remove ChatDialogController from the list
	int index = [webBrowsers indexOfObject:webBrowser];
	[webBrowsers removeObjectAtIndex:index];
	NSIndexPath *removedControllerIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
	
	[[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:removedControllerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
	
	// Decide on which WebBrowserController to activate next
	UIViewController *nextController;
	if ([webBrowsers count] == 0) {
		nextController = [[[InitialViewController alloc] initWithNibName:@"InitialViewController" bundle:nil] autorelease];
	} else if ([removedControllerIndexPath row] > 0) {
		[[self tableView] selectRowAtIndexPath:[NSIndexPath indexPathForRow:[removedControllerIndexPath row] - 1 inSection:0] 
									  animated:NO 
								scrollPosition:UITableViewScrollPositionNone];
		nextController = [webBrowsers objectAtIndex:[removedControllerIndexPath row] - 1];
	} else {
		[[self tableView] selectRowAtIndexPath:[NSIndexPath indexPathForRow:[removedControllerIndexPath row] inSection:0] 
									  animated:NO 
								scrollPosition:UITableViewScrollPositionNone];
		nextController = [webBrowsers objectAtIndex:[removedControllerIndexPath row]];
	}
	
	[contentContainerController setContentController:nextController];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[webBrowsers release];
	[deselectionDelegate release];
    [super dealloc];
}

@end

