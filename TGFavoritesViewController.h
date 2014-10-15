
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TGMainViewController.h"
#import <CoreData/CoreData.h>

@interface TGFavoritesViewController : UITableViewController <MainViewControllerDelegate, NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
