@interface WebPageCell : UITableViewCell {

	IBOutlet UILabel *titleLabel;
	
	IBOutlet UILabel *urlLabel;

	IBOutlet UIView *leftBorderImage;
	
	IBOutlet UIView *selectedWebpageBgView;
	
	IBOutlet UIView *topBorderView;
	
	IBOutlet UIView *bottomBorderView;

@private
	UIColor *selectedBorderColor;
	
	UIColor *topBorderColor;
	
	UIColor *bottomBorderColor;
	
	BOOL first;
	
	BOOL last;
}

- (void) setWebPageTitle:(NSString *) title andUrl:(NSString *) url first:(BOOL) first last:(BOOL) last;

@end
