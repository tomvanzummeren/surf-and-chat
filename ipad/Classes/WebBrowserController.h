#import "WebBrowserDelegate.h"

@interface WebBrowserController : UIViewController<UITextFieldDelegate, UIWebViewDelegate> {

	IBOutlet UIWebView *webView;
	
	IBOutlet UITextField *urlField;
	
	IBOutlet UIButton *backButton;

	IBOutlet UIButton *forwardButton;
	
	IBOutlet UIButton *stopButton;
	
	IBOutlet UIButton *refreshButton;
	
	@private
	int loadingCount;
	
	id<WebBrowserDelegate> delegate;
}

@property (retain, nonatomic) id<WebBrowserDelegate> delegate;

- (NSString *) pageTitle;

- (NSString *) pageUrl;

@end
