
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
NSString *tempMunicipality;
NSString *tempHouseName;
UIImage *tempProfileImage;
UIButton *favoriteBtn;
NSString *path;
NSMutableDictionary *data;

bool isFav = false;

#pragma - UIViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
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
        // If the file doesn’t exist, create an empty dictionary
        data = [[NSMutableDictionary alloc] init];
    }
    
//    int value = 5;
//    [data setObject:[NSNumber numberWithInt:value] forKey:@"value"];
//    [data writeToFile: path atomically:YES];
    
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
    NSLog(@"log before retrieving data::%@",[NSNumber numberWithBool:isFav]);
         //   [favoriteBtn setBackgroundImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
            if (isFav) {
                [favoriteBtn setBackgroundImage:[UIImage imageNamed:@"star-g.png"] forState:UIControlStateNormal];
                isFav = false;
            } else {
                [favoriteBtn setBackgroundImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
                [data setObject:@"1" forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
                [data writeToFile:path atomically:YES];
                isFav = true;
            }
    
    //retrieve data from plist
    
    NSMutableDictionary *savedData = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    BOOL boolVal;
    NSLog(@"read th plist %@",savedData);
    boolVal = [[savedData objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]]boolValue];
    NSLog(@"boolVal:::: %d  and also indexpath: %ld",boolVal,(long)indexPath.row);
   
    [self updateAccessibilityForCell:[self.tableView cellForRowAtIndexPath:indexPath]];
        [self addDataToCore];
}

- (void)updateAccessibilityForCell:(UITableViewCell*)cell
{
    // The cell's accessibilityValue is the Checkbox's accessibilityValue.
    cell.accessibilityValue = cell.accessoryView.accessibilityValue;
}

-(void)addDataToCore {
    
    Venues *newVenue = (Venues *)[NSEntityDescription insertNewObjectForEntityForName:@"Venues" inManagedObjectContext:self.managedObjectContext];
    newVenue.objectId = tempMunicipality;
    newVenue.name = tempHouseName;
    newVenue.isMyFavorite = [NSNumber numberWithBool:isFav];
    NSData *imageData = UIImageJPEGRepresentation(tempProfileImage,0.0);
    [newVenue setValue:imageData forKey:@"profileImage"];
    TGFavoritesViewController *favoritesController = [[TGFavoritesViewController alloc]init];
    [favoritesController addViewController:self didFinishWithSave:YES];
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    NSLog(@"record added succesfully %@",newVenue);
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

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
            object:(PFObject *)object{
    
#warning check here if there are values equal to true (1) into plist
    
    static NSString *simpleTableIdentifier = @"MainTableViewCell";
    cell = (MainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSLog(@"pfobject????:%@",object);
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
    
    //create favorite button programmatically
    favoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    favoriteBtn.frame = CGRectMake(20.0f, 20.0f, 30.0f, 30.0f);
    [favoriteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [favoriteBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [favoriteBtn setTag:indexPath.row];

    tempMunicipality = object [@"municipality"];
    tempHouseName = object [@"name"];
    tempProfileImage = profileImage.image;
    
    [favoriteBtn setBackgroundImage:[UIImage imageNamed:@"star-g.png"] forState:UIControlStateNormal];
    [favoriteBtn addTarget:self action:@selector(menuPressed:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:favoriteBtn];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSLog(@"database so far: %@ with tag %ld",tempHouseName,(long)favoriteBtn.tag);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected index path : %ld",(long)indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 299.0;
}

@end
