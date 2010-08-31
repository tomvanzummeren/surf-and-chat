#import "WebBrowserDelegate.h"
#import "DeselectionDelegate.h"

@class ContentContainerController;

@interface WebPageListController : UITableViewController<WebBrowserDelegate, DeselectionDelegate> {

	IBOutlet ContentContainerController *contentContainerController;
	
	IBOutlet id<DeselectionDelegate> deselectionDelegate;
	
@private
	NSMutableArray *webBrowsers;
}

- (IBAction) addWebBrowser;

@end
