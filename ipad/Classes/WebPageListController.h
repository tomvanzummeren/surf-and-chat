@class ContentContainerController;

@interface WebPageListController : UITableViewController {

	IBOutlet ContentContainerController *contentContainerController;

@private
	NSMutableArray *webBrowsers;
}

- (IBAction) addWebBrowser;

@end
