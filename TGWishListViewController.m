
#import "TGWishListViewController.h"
#import "TGSideMenuViewController.h"

@interface TGWishListViewController ()

@end

@implementation TGWishListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    navBar.backgroundColor = [UIColor whiteColor];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = @"WishList";
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"burgerIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(openButtonPressed)];
//    UIBarButtonItem *mapItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(openMap)];
 //   navItem.rightBarButtonItem = mapItem;
    navItem.leftBarButtonItem = menuItem;
    navBar.items = @[ navItem ];
    [self.view addSubview:navBar];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)openButtonPressed {
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
