
#import "BaseTableViewController.h"

@implementation BaseTableViewController

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// Deselect selected row
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:indexPath animated:animated];
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	// Flash scroll indicators
	[self.tableView flashScrollIndicators];
}

- (void) setTableView:(UITableView *) tableView {
	_tableView = tableView;
}

- (UITableView *) tableView {
	return _tableView;
}

// Subclasses should implement the following two methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}
	
@end
