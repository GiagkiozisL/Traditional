
#import "TGMapViewController.h"
#import "TGSideMenuViewController.h"

@interface TGMapViewController ()

@end

@implementation TGMapViewController 
@synthesize mapView;

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mapView.delegate = self;
    mapView.mapType = MKMapTypeSatellite;
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    navBar.backgroundColor = [UIColor whiteColor];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = @"MapView";
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"burgerIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(openButtonPressed)];
    navItem.leftBarButtonItem = menuItem;
    navBar.items = @[ navItem ];
    [self.view addSubview:navBar];

}

-(void)openButtonPressed {
    
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}

@end
