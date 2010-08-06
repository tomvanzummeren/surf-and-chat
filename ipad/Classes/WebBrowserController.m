#import "WebBrowserController.h"

#import "EventDispatcher.h"
#import "FullScreenEvent.h"

@interface WebBrowserController()

- (void) onRequestFinished;
- (NSURL *) toUrl:(NSString *) text;

@end


@implementation WebBrowserController

@synthesize delegate;

- (id)init {
    if ((self = [super initWithNibName:@"WebBrowserController" bundle:nil])) {
		eventDispatcher = [EventDispatcher sharedInstance];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[backButton setEnabled:NO];
	[forwardButton setEnabled:NO];
	[actionButton setEnabled:NO];
	[refreshButton setEnabled:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (NSString *) pageTitle {
	return [self title] == nil ? @"New Page" : [self title];
}

- (NSString *) pageUrl {
	return [[[webView request] URL] absoluteString];
}

// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	[webView loadRequest:[NSURLRequest requestWithURL:[self toUrl:[textField text]]]];
	[webView setHidden:NO];
	return YES;
}

- (NSURL *) toUrl:(NSString *) text {
	NSString *url = text;
	int protocolSeparatorLocation = [url rangeOfString:@"://"].location;
	if (protocolSeparatorLocation == -1 || protocolSeparatorLocation > 5) {
		url = [NSString stringWithFormat:@"http://%@", url];
	}
	return [NSURL URLWithString:url];
}

- (void)webViewDidStartLoad:(UIWebView *) sender {
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	loadingCount ++;
	[stopButton setHidden:NO];
	[refreshButton setHidden:YES];
	[actionButton setEnabled:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *) sender {
	[self onRequestFinished];
	[urlField setText:[self pageUrl]];
	[delegate pageUrlChanged:self];
}

- (void)webView:(UIWebView *) sender didFailLoadWithError:(NSError *) error {
	[self onRequestFinished];
	if ([error code] == -1003) {
		[[[[UIAlertView alloc] initWithTitle:@"Cannot Open Page" 
									 message:@"Safari cannot open the page because the server cannot be found." 
									delegate:nil 
						   cancelButtonTitle:nil 
						   otherButtonTitles:@"OK", nil] autorelease] show];
	}
}

- (void) onRequestFinished {
	loadingCount --;
	if (loadingCount == 0) {
		NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"]; 
		[self setTitle:title];
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		[stopButton setHidden:YES];
		[refreshButton setHidden:NO];
		[refreshButton setEnabled:YES];
	}
	[backButton setEnabled:[webView canGoBack]];
	[forwardButton setEnabled:[webView canGoForward]];
}

- (IBAction) showActions {
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:nil
								  delegate:self
								  cancelButtonTitle:nil
								  destructiveButtonTitle:nil
								  otherButtonTitles:@"Open in Safari", nil];
	[actionSheet showFromRect:[actionButton frame] inView:[self view] animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		NSURL *url = [[webView request] URL];
		[[UIApplication sharedApplication] openURL:url];
	}
}

- (void)dealloc {
	[webView release];
	[urlField release];
    [super dealloc];
}

@end
