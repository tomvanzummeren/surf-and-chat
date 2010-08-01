@class ContentContainerController;

#import "WebBrowserDelegate.h"

@interface WebPageListController : UITableViewController<WebBrowserDelegate> {

	IBOutlet ContentContainerController *contentContainerController;

@private
	NSMutableArray *webBrowsers;
}

- (IBAction) addWebBrowser;

@end
