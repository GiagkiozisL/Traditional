
#import "TGMainViewController.h"
#import "AppDelegate.h"
#import "Venues.h"
#import "TGSideMenuViewController.h"
#import "TGMapViewController.h"
#import "ControlVariables.h"
#import "MainTableViewCell.h"

@interface TGMainViewController ()
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@end

@implementation TGMainViewController
MainTableViewCell *cell;
NSString *favrtBtnId;
NSString *tempObjectId;
UIButton *favoriteBtn;

bool isFav = false;

#pragma - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = @"Main View";
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

-(void)menuPressed {
    
    [favoriteBtn setBackgroundImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
    
    if (isFav) {
        [favoriteBtn setBackgroundImage:[UIImage imageNamed:@"star-g.png"] forState:UIControlStateNormal];
        isFav = false;
    } else {
        [favoriteBtn setBackgroundImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
        isFav = true;
    }
    [self storeFavStatusToVenues];
    [self addDataToCore];
}

-(void)storeFavStatusToVenues {
    
    Venues *newVenue = [NSEntityDescription insertNewObjectForEntityForName:@"Venues" inManagedObjectContext:self.managedObjectContext];
    newVenue.objectId = tempObjectId;
    newVenue.isMyFavorite = [NSNumber numberWithBool:isFav];
        
}

-(void)addDataToCore {
    
    Venues *newVenue = [NSEntityDescription insertNewObjectForEntityForName:@"Venues" inManagedObjectContext:self.managedObjectContext];
    newVenue.objectId = tempObjectId;
    newVenue.isMyFavorite = [NSNumber numberWithBool:isFav];
    
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
    static NSString *simpleTableIdentifier = @"MainTableViewCell";
    cell = (MainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
   
   cell.houseNameLabel.text = object [@"name"];
    cell.areaLabel.text = object [@"area"];
   cell.priceLabel.text = object [@"price"];
    cell.streetLabel.text = object [@"municipality"];
  
    
    
    if ([[object objectForKey:@"winter"]boolValue]) {
    cell.winterImg.image =[UIImage imageNamed:@"winter-y.png"];
    }
    if ([[object objectForKey:@"spring"]boolValue]) {
        cell.springImg.image =[UIImage imageNamed:@"spring-y.png"];
    } else cell.springImg.alpha = 0.35;
    if ([[object objectForKey:@"fall"]boolValue]) {
        cell.fallImg.image =[UIImage imageNamed:@"fall-y.png"];
    }
    if ([[object objectForKey:@"summer"]boolValue]) {
        cell.summerImg.image =[UIImage imageNamed:@"summer-y.png"];
    } else cell.summerImg.alpha = 0.35;
    
    //create favorite button programmatically
    favoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    favoriteBtn.frame = CGRectMake(20.0f, 20.0f, 30.0f, 30.0f);
    [favoriteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [favoriteBtn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    tempObjectId = [object objectId];
    [favoriteBtn setBackgroundImage:[UIImage imageNamed:@"star-g.png"] forState:UIControlStateNormal];
    [favoriteBtn addTarget:self action:@selector(menuPressed) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:favoriteBtn];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 299.0;
}


@end
