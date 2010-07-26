#import <UIKit/UIKit.h>
/**
 * A controller for UITableView in which the default view and tableView can be two seperate views. This way multiple views can be controlled by this class. 
 * This class is a drop-in replacement for UITableViewController.
 *
 * @author Tom van Zummeren
 */
@interface BaseTableViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource> {
	
	UITableView *_tableView;
	
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
