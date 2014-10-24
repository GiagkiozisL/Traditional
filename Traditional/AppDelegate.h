
//parse API key contants

static NSString * const ParsePostsClassKey = @"Venues";
static NSString * const ParseLocationKey = @"location";
static NSString * const ParseCoordinatesKey = @"coordinates";
static NSString * const ParseNameKey = @"name";
static NSString * const ParseMunicipalityKey = @"municipality";

/////////////////////////

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Parse/Parse.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(NSArray*)getAllVenueRecords;

@end

