
/*!
 * Provides NIB related functionality as static methods.
 *
 * @author Tom van Zummeren
 */
// TODO: Change this class into a category for UITableViewCell
@interface NibUtils : NSObject {
}

/*!
 * Loads a view of the given type from a NIB.
 *
 * @param viewClass the type of view to load (NIB can contain multiple views)
 * @param nibName   name of the NIB to load from
 * @return the first found view instance that matches the given type
 */
+ (id)loadView:(Class)viewClass fromNib:(NSString *)nibName;

@end
