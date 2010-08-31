@class WebBrowserController;

@protocol WebBrowserDelegate

@required
- (void) pageUrlChanged:(WebBrowserController *) webBrowser;

- (void) closeWindow:(WebBrowserController *) webBrowser;

@end
