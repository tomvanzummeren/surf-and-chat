
@class EventDispatcher;

#import "WebBrowserDelegate.h"

@interface WebBrowserController : UIViewController<UITextFieldDelegate, UIWebViewDelegate, UIActionSheetDelegate> {

	IBOutlet UIWebView *webView;
	
	IBOutlet UITextField *urlField;
	
	IBOutlet UIButton *backButton;

	IBOutlet UIButton *forwardButton;
	
	IBOutlet UIButton *stopButton;
	
	IBOutlet UIButton *refreshButton;
	
	IBOutlet UIButton *actionButton;
	
	@private
	int loadingCount;
	
	id<WebBrowserDelegate> delegate;
	
	EventDispatcher *eventDispatcher;
}

@property (retain, nonatomic) id<WebBrowserDelegate> delegate;

- (NSString *) pageTitle;

- (NSString *) pageUrl;

- (IBAction) showActions;

- (IBAction) closeWindow;

@end
