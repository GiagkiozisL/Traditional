
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <CoreData/CoreData.h>

@interface TGFavoritesViewController : UITableViewController <UITableViewDataSource,UITableViewDataSource,NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
