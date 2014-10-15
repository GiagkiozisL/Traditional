
#import <Parse/Parse.h>

@class Venues;

@protocol MainViewControllerDelegate;

@interface TGMainViewController : PFQueryTableViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) id <MainViewControllerDelegate> delegate;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Venues *venue;

@end

@protocol MainViewControllerDelegate

- (void)addViewController:(TGMainViewController *)controller didFinishWithSave:(BOOL)save;

@end
