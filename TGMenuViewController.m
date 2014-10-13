
#import "TGWishListViewController.h"
#import "TGMenuViewController.h"
#import "TGMainViewController.h"
#import "TGLoginViewController.h"
#import "TGSideMenuViewController.h"
#import "TGMapViewController.h"
#import "TGFavoritesViewController.h"
#import "ILTranslucentView.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "Comms.h"

@interface TGMenuViewController () <CommsDelegate>
@property (nonatomic,strong) UIImageView *backgroundImageView;
@end

@implementation TGMenuViewController
ILTranslucentView *translucentView;
NSString *tempUser;
NSString *name;

UIButton *logIn;
UIButton *signUp;
UIButton *logout;
UILabel *usernameLabel;
UIImageView *imageView;

-(void)viewDidAppear:(BOOL)animated{
    [self checkIfUserConnected];
    NSLog(@"viewDidAppear");
}

- (void)viewDidLoad {
    NSLog(@"viewDIDLOAD");
    [super viewDidLoad];
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"body.png"]];
    self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    CGRect imageViewRect = [[UIScreen mainScreen] bounds];
    imageViewRect.size.width += 589;
    self.backgroundImageView.frame = imageViewRect;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.backgroundImageView];
    
    NSDictionary *viewDictionary = @{ @"imageView" : self.backgroundImageView };
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]" options:0 metrics:nil views:viewDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView]" options:0 metrics:nil views:viewDictionary]];
    
    //draw username label and image
    usernameLabel = [[UILabel alloc] init];
    usernameLabel.textColor = [UIColor blackColor];
    [usernameLabel setFrame:CGRectMake(100.0f, 40.0f, 200.0f, 50.0f)];
    usernameLabel.textColor=[UIColor whiteColor];
    usernameLabel.userInteractionEnabled=NO;
    [self.view addSubview:usernameLabel];
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(30.0f, 40.0f, 44.0f, 44.0f)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.layer.cornerRadius = 20;
    imageView.clipsToBounds = YES;
    [self.view addSubview:imageView];
    
            translucentView = [[ILTranslucentView alloc] initWithFrame:(CGRectMake(10, 465, 300, 51))];
            translucentView.layer.cornerRadius = 5;
            translucentView.clipsToBounds = YES;
            translucentView.translucentAlpha = 0.6;
            [self.view addSubview:translucentView];
    
            //logIN button
            logIn = [UIButton buttonWithType:UIButtonTypeSystem];
            logIn.frame = CGRectMake(150.0f, 465.0f, 200.0f, 44.0f);
            [logIn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [logIn setTitle:@"Log in" forState:UIControlStateNormal];
            [logIn addTarget:self action:@selector(logInPressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:logIn];
    
            //signUp button
            signUp = [UIButton buttonWithType:UIButtonTypeSystem];
            signUp.frame = CGRectMake(20.0f, 465.0f, 200.0f, 44.0f);
            [signUp setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [signUp setTitle:@"Create an account" forState:UIControlStateNormal];
            [signUp addTarget:self action:@selector(menuItem1Pressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:signUp];

    //logOUT button
    logout = [UIButton buttonWithType:UIButtonTypeSystem];
    logout.frame = CGRectMake(120.0f, 465.0f, 80.0f, 44.0f);
    [logout setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [logout setTitle:@"Log out" forState:UIControlStateNormal];
    [logout addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logout];
    
    
    [self checkIfUserConnected];
    
    UIFont *fontLabel = [UIFont fontWithName:@"Euphemia UCAS" size:19];
    
    //draw menu item #1
    UIButton *menuItem1 = [UIButton buttonWithType:UIButtonTypeCustom];
    menuItem1.frame = CGRectMake(-60.0f, 110.0f, 200.0f, 44.0f);
    [menuItem1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [menuItem1 setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    menuItem1.titleLabel.font = fontLabel;
    [menuItem1 setTitle:@"Home" forState:UIControlStateNormal];
    [menuItem1 addTarget:self action:@selector(menuItem1Pressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuItem1];
    
    //draw menu item #2
    UIButton *menuItem2 = [UIButton buttonWithType:UIButtonTypeCustom];
    menuItem2.frame = CGRectMake(-45.0f, 200.0f, 200.0f, 44.0f);
    menuItem2.titleLabel.font = fontLabel;
    [menuItem2 setTitle:@"Favorites" forState:UIControlStateNormal];
    [menuItem2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [menuItem2 setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [menuItem2 addTarget:self action:@selector(menuItem2Pressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuItem2];
    
    //draw menu item #3
    UIButton *menuItem3 = [UIButton buttonWithType:UIButtonTypeCustom];
    menuItem3.frame = CGRectMake(-65.0f, 290.0f, 200.0f, 44.0f);
    menuItem3.titleLabel.font = fontLabel;
    [menuItem3 setTitle:@"Map" forState:UIControlStateNormal];
    [menuItem3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [menuItem3 setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [menuItem3 addTarget:self action:@selector(menuItem3Pressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuItem3];
    
    //draw menu item #4
    UIButton *menuItem4 = [UIButton buttonWithType:UIButtonTypeCustom];
    menuItem4.frame = CGRectMake(-47.0f, 380.0f, 200.0f, 44.0f);
    menuItem4.titleLabel.font = fontLabel;
    [menuItem4 setTitle:@"WishList" forState:UIControlStateNormal];
    [menuItem4 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [menuItem4 setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [menuItem4 addTarget:self action:@selector(menuItem4Pressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:menuItem4];
    
}

-(void)menuItem1Pressed {
    UINavigationController *mainController = [[UINavigationController alloc] initWithRootViewController:[TGMainViewController new]];
    [self.sideMenuViewController setMainViewController:mainController animated:YES closeMenu:YES];
}

-(void)menuItem2Pressed {

    UINavigationController *favController = [[UINavigationController alloc]initWithRootViewController:[TGFavoritesViewController new]];
    [self.sideMenuViewController setMainViewController:favController animated:YES closeMenu:YES];
}

-(void)menuItem3Pressed {
    NSString * storyboardName = @"Main";
    NSString * viewControllerID = @"mapView";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    TGMapViewController *mapController = (TGMapViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    [self.sideMenuViewController setMainViewController:mapController animated:YES closeMenu:YES];
}

-(void)menuItem4Pressed {
    NSString * storyboardName = @"Main";
    NSString * viewControllerID = @"wishList";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    TGWishListViewController * controller = (TGWishListViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
}

-(void)logInPressed {
    NSString * storyboardName = @"Main";
    NSString * viewControllerID = @"logIn";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    TGLoginViewController * controller = (TGLoginViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    logIn.hidden = YES;
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
}

-(void)logOut{
    [PFUser logOut];
    
    [self checkIfUserConnected];
}

-(void)checkIfUserConnected{

    if ([PFUser currentUser] && // Check if user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        // Check if user is linked to Facebook
        FBRequest *request = [FBRequest requestForMe];
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // result is a dictionary with the user's Facebook data
                                // result is a dictionary with the user's Facebook data
                                NSDictionary *userData = (NSDictionary *)result;
                                NSString *facebookID = userData[@"id"];
                                NSString *imageUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", facebookID];
                                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                                name = userData[@"name"];
                                tempUser = name;
                                usernameLabel.text= [NSString stringWithFormat:@"%@",tempUser];
                                imageView.image = [UIImage imageWithData:imageData];
                
                    } else {
                
                    }
            }];
        
        NSLog(@"user logged in");
        
        logout.hidden = NO;
        logIn.hidden = YES;
        signUp.hidden = YES;
        translucentView.hidden = YES;
        
    } else {
        
        NSLog(@"user hasnt logged in");
               usernameLabel.text = @"user hasn't logged in";
        imageView.image = nil;
                logout.hidden = YES;
        translucentView.hidden = NO;
        logIn.hidden = NO;
        signUp.hidden = NO;
    }

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
