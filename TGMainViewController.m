
#import "TGMainViewController.h"
#import "TGSideMenuViewController.h"
#import "TGMapViewController.h"
#import "ControlVariables.h"
#import "MainTableViewCell.h"

@interface TGMainViewController ()

@end

@implementation TGMainViewController

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
}

-(void)openMap {
    TGMapViewController *mapController = [[TGMapViewController alloc]init];
    [self.navigationController pushViewController:mapController animated:YES];
}

- (void)openButtonPressed {
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
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
    MainTableViewCell *cell = (MainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MainTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
   
   cell.houseNameLabel.text = object [@"name"];
    cell.areaLabel.text = object [@"area"];
   cell.priceLabel.text = object [@"price"];
    cell.streetLabel.text = object [@"municipality"];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 299.0;
}

@end
