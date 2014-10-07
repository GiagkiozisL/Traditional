
#import "TGMenuViewController.h"
#import "TGMapViewController.h"

@interface TGMenuViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation TGMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"6portrait.png"]];
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    CGRect imageViewRect = [[UIScreen mainScreen] bounds];
    imageViewRect.size.width += 589;
    self.backgroundImageView.frame = imageViewRect;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.backgroundImageView];
    
    NSDictionary *viewDictionary = @{ @"imageView" : self.backgroundImageView };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]" options:0 metrics:nil views:viewDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView]" options:0 metrics:nil views:viewDictionary]];
    
    //draw menu item #1
    UIButton *menuItem1 = [UIButton buttonWithType:UIButtonTypeSystem];
    menuItem1.frame = CGRectMake(-40.0f, 100.0f, 200.0f, 44.0f);
    [menuItem1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [menuItem1 setTitle:@"Home" forState:UIControlStateNormal];
    [menuItem1 addTarget:self action:@selector(menuItem1Pressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuItem1];
    
    //draw menu item #2
    UIButton *menuItem2 = [UIButton buttonWithType:UIButtonTypeSystem];
    menuItem2.frame = CGRectMake(-40.0f, 200.0f, 200.0f, 44.0f);
    [menuItem2 setTitle:@"Map" forState:UIControlStateNormal];
    [menuItem2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [menuItem2 addTarget:self action:@selector(menuItem2Pressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuItem2];
    
    //draw menu item #3
    UIButton *menuItem3 = [UIButton buttonWithType:UIButtonTypeSystem];
    menuItem3.frame = CGRectMake(-40.0f, 300.0f, 200.0f, 44.0f);
    [menuItem3 setTitle:@"Favorites" forState:UIControlStateNormal];
    [menuItem3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [menuItem3 addTarget:self action:@selector(menuItem3Pressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuItem3];
    
    //draw menu item #4
    UIButton *menuItem4 = [UIButton buttonWithType:UIButtonTypeSystem];
    menuItem4.frame = CGRectMake(-40.0f, 400.0f, 200.0f, 44.0f);
    [menuItem4 setTitle:@"WishList" forState:UIControlStateNormal];
    [menuItem4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [menuItem4 addTarget:self action:@selector(menuItem4Pressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuItem4];
    
}

-(void)menuItem4Pressed {
    NSString * storyboardName = @"Main_iPhone";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"DTLoginViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)menuItem3Pressed {
//    TGMapViewController *mapController = [[TGMapViewController alloc]init];
//    [self.sideViewController setMainViewController:mapController animated:YES closeMenu:YES];
}
//
-(void)menuItem2Pressed {
//    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:[DTLoginViewController new]];
//    [self.sideViewController setMainViewController:controller animated:YES closeMenu:YES];
}
//
-(void)menuItem1Pressed {
//    DTLoginViewController *secondViewController =
//    [self.storyboard instantiateViewControllerWithIdentifier:@"secondViewController"];
//    [self.navigationController pushViewController:secondViewController animated:YES];
}
//
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
//
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([segue.identifier isEqualToString:@"mapView"]) {
//        TGMapViewController *mapController = (TGMapViewController*)segue.destinationViewController;
//        
//        
//    }
}

@end
