
#import "TGMainViewController.h"
#import "AppDelegate.h"
#import "Venues.h"
#import "PListHelper.h"
#import "TGSideMenuViewController.h"
#import "TGFavoritesViewController.h"
#import "TGMapViewController.h"
#import "ControlVariables.h"
#import "MainTableViewCell.h"

@interface TGMainViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation TGMainViewController
@synthesize dataArray;

NSMutableDictionary *inputDict;
PListHelper *objPlistHelper;
MainTableViewCell *cell;
NSString *favrtBtnId;
NSString *tempObjectId;
NSString *tempMunicipality;
NSString *tempHouseName;
UIImage *tempProfileImage;
UIButton *favoriteBtn;
NSString *path;
NSMutableDictionary *data;
Venues *venues;
bool isFav = false;

#pragma - UIViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"Main View";
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    path = [documentsDirectory stringByAppendingPathComponent:@"FavoriteData.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath: path])
    {
        data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    }
    else
    {
        data = [[NSMutableDictionary alloc] init];
    }

    self.view.backgroundColor = [UIColor grayColor];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"burgerIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(openButtonPressed)];
    UIBarButtonItem *mapItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(openMap)];
    self.navigationItem.leftBarButtonItem = menuItem;
    self.navigationItem.rightBarButtonItem = mapItem;
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
}

-(void)openMap {
    TGMapViewController *mapController = [[TGMapViewController alloc]init];
    [self.navigationController pushViewController:mapController animated:YES];
}

- (void)openButtonPressed {
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}

-(void)menuPressed:(id)sender forEvent:(UIEvent*)event {
    
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    
    PFObject *objectArray = [self.objects objectAtIndex:indexPath.row];

        if (isFav) {
           
                [data setObject:@"0" forKey:[NSString stringWithFormat:@"%@",objectArray.objectId]];
                [data writeToFile:path atomically:YES];
                isFav = false;
            } else {
         
                [data setObject:@"1" forKey:[NSString stringWithFormat:@"%@",objectArray.objectId]];
                [data writeToFile:path atomically:YES];
                isFav = true;
            }
    
    [self addDataToCore:(id)sender forEvent:(UIEvent*)event];
}

- (void)updateAccessibilityForCell:(UITableViewCell*)cell
{
    cell.accessibilityValue = cell.accessoryView.accessibilityValue;
}

-(void)addDataToCore:(id)sender forEvent:(UIEvent*)event {

    NSError * error = nil;
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    PFObject *currentObjectAtIndexPath = [self.objects objectAtIndex:indexPath.row];
    
    NSString *likeObjectId = [NSString stringWithFormat:@"%@",currentObjectAtIndexPath.objectId];
    NSLog(@"like object id : %@",tempObjectId);
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Venues"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"(objectId like[cd] %@)",likeObjectId]];
    [request setFetchLimit:1];
    NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&error];
    if (count == NSNotFound)
        // some error occurred
        NSLog(@"some error occurred");
        else if (count == 0)
        { // no matching object - ADD newVenue to core
            
            NSLog(@"no matching object");
    Venues *newVenue = (Venues *)[NSEntityDescription insertNewObjectForEntityForName:@"Venues" inManagedObjectContext:self.managedObjectContext];
    newVenue.objectId = tempObjectId;
    newVenue.name = tempHouseName;
    newVenue.isMyFavorite = [NSNumber numberWithBool:isFav];
    NSData *imageData = UIImageJPEGRepresentation(tempProfileImage,0.0);
    [newVenue setValue:imageData forKey:@"profileImage"];
    TGFavoritesViewController *favoritesController = [[TGFavoritesViewController alloc]init];
    [favoritesController addViewController:self didFinishWithSave:YES];
    
                    NSError *error2;
                if (![self.managedObjectContext save:&error2]) {
                        NSLog(@"Whoops, couldn't save: %@", [error2 localizedDescription]);
                }
                        NSLog(@"record added succesfully %@",newVenue);
        } else
                //do nothing
                NSLog(@"at least one matching object exists");
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Venues"];
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    [query whereKey:@"name" notEqualTo:@"Something"];
    
    return query;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.objects count];
}

- (MainTableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
            object:(PFObject *)object{
    
    static NSString *simpleTableIdentifier = @"MainTableViewCell";
    cell = (MainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSMutableDictionary *savedData = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    BOOL boolVal;
    //    NSLog(@"read th plist %@",savedData);
    boolVal = [[savedData objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]boolValue];
    
    //create favorite button programmatically
    favoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    favoriteBtn.frame = CGRectMake(20.0f, 20.0f, 30.0f, 30.0f);
    [favoriteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [favoriteBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    
    for (id key in savedData) {
        
    //    NSLog(@"compare  %@  with  %@   and having %@",key,[object objectId],[savedData objectForKey:key]);
   //     NSLog(@"bundle: key=%@, value=%@", key, [savedData objectForKey:key]);
        if ([key isEqualToString:[object objectId]] && [[savedData objectForKey:key] isEqualToString:@"1"]) {
            [favoriteBtn setBackgroundImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            NSLog(@"Match!!!!!!");
        }
        else
               [favoriteBtn setBackgroundImage:[UIImage imageNamed:@"star-g.png"] forState:UIControlStateNormal];
    }
    
    [favoriteBtn addTarget:self action:@selector(menuPressed:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self updateAccessibilityForCell:[self.tableView cellForRowAtIndexPath:indexPath]];

    PFImageView *profileImage = [[PFImageView alloc]init];
    profileImage.file = (PFFile*)object[@"image"];
    [profileImage loadInBackground];
    cell.houseImage.image = profileImage.image;
   cell.houseNameLabel.text = object [@"name"];
    cell.areaLabel.text = object [@"area"];
   cell.priceLabel.text = object [@"price"];
    cell.streetLabel.text = object [@"municipality"];
    
    if ([[object objectForKey:@"winter"]boolValue]) {
    cell.winterImg.image =[UIImage imageNamed:@"winter-y.png"];
    } else  {
        cell.winterImg.image =[UIImage imageNamed:@"winter-w.png"];
        cell.winterImg.alpha = 0.35;
    }
    if ([[object objectForKey:@"spring"]boolValue]) {
        cell.springImg.image =[UIImage imageNamed:@"spring-y.png"];
    } else {
        cell.springImg.image =[UIImage imageNamed:@"spring-w.png"];
        cell.springImg.alpha = 0.35;
    }
    if ([[object objectForKey:@"fall"]boolValue]) {
        cell.fallImg.image =[UIImage imageNamed:@"fall-y.png"];
    } else  {
        cell.fallImg.image =[UIImage imageNamed:@"fall-w.png"];
        cell.fallImg.alpha = 0.35;
    }
    if ([[object objectForKey:@"summer"]boolValue]) {
        cell.summerImg.image =[UIImage imageNamed:@"summer-y.png"];
    } else  {
        cell.summerImg.image =[UIImage imageNamed:@"summer-w.png"];
        cell.summerImg.alpha = 0.35;
    }
    
    tempObjectId = [object objectId];
    tempMunicipality = object [@"municipality"];
    tempHouseName = object [@"name"];
    tempProfileImage = profileImage.image;
    
    [cell addSubview:favoriteBtn];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected index path : %ld",(long)indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 299.0;
}

@end
