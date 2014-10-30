
#import "TGDetailTableViewController.h"

@interface TGDetailTableViewController ()

@end

@implementation TGDetailTableViewController
@synthesize backgroundImg;
@synthesize starImg;
@synthesize season1Img;
@synthesize season2Img;
@synthesize season3Img;
@synthesize season4Img;
@synthesize detailView;
@synthesize guesthouseName;
@synthesize price;
@synthesize guestHouseKind;
@synthesize roomsNumber;
@synthesize owner;
@synthesize star1;
@synthesize star2;
@synthesize star3;
@synthesize star4;
@synthesize star5;
@synthesize seaImg;
@synthesize mountainImg;
@synthesize ownerPic;
@synthesize region;

@synthesize tempName;
@synthesize tempRegion;
@synthesize tempImage;
@synthesize tempOwnersObjId;
@synthesize tempLodgingType;
@synthesize tempRoomsNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"DETAILLLLLLLLL::::::viewDidLoad");
    detailView.layer.cornerRadius = 10.0;
    detailView.clipsToBounds = YES;
    
    ownerPic.layer.cornerRadius = 28.0;
    ownerPic.clipsToBounds = YES;
    
    
    self.navigationItem.title = @"Detail View";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    guesthouseName.text = [NSString stringWithFormat:@"%@",tempName];
    region.text = [NSString stringWithFormat:@"%@",tempRegion];
    guestHouseKind.text = [NSString stringWithFormat:@"- %@ -",tempLodgingType];
    roomsNumber.text = [NSString stringWithFormat:@"%@ rooms",tempRoomsNumber];

}
-(void)viewDidDisappear:(BOOL)animated {
    NSLog(@"viewDidDisappear");
    backgroundImg.image = nil;
    tempLodgingType = nil;
    tempRoomsNumber = nil;
    owner.text = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIActions

- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
