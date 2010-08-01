@class WebBrowserController;

@protocol WebBrowserDelegate

@required
- (void) pageUrlChanged:(WebBrowserController *) webBrowser;

@end
