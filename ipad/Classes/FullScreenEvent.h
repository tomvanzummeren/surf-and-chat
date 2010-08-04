
@interface FullScreenEvent : NSObject {

  @private
	UIViewController *viewController;
}

@property (retain, nonatomic) UIViewController *viewController;

@end
