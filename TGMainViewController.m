
#import "TGMainViewController.h"
#import "TGMapViewController.h"
#import "TGSideMenuViewController.h"
#import "MainTableViewCell.h"

@interface TGMainViewController ()

@end

@implementation TGMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationItem.title = @"Main View";
    self.view.backgroundColor = [UIColor grayColor];
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"burgerIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(openSideMenu)];
    UIBarButtonItem *mapItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(openMap)];
    self.navigationItem.leftBarButtonItem = menuItem;
    self.navigationItem.rightBarButtonItem = mapItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.objects count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
                       object:(PFObject *)object {
    
    static NSString *mainTableIdentifier = @"MainTableViewCell";
    
    MainTableViewCell *cell = (MainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:mainTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.houseNameLabel.text = object[@"name"];
    cell.areaLabel.text = object [@"area"];
    cell.streetLabel.text = object [@"municipality"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 299.0;
}

#pragma mark - PFQueryTableViewController

-(PFQuery *)queryForTable {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Venues"];
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    [query whereKey:@"name" notEqualTo:@"Something"];
    return query;
}

#pragma mark - IBActions

-(void)openSideMenu {
    
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}

-(void)openMap {
    
    //go to map controller
}
@end
