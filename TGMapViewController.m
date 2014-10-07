
#import "TGMapViewController.h"

@interface TGMapViewController ()
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) CLLocation *location;
@end

MKMapView *mapView;
@implementation TGMapViewController 

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mapView setShowsUserLocation:YES];
    self.navigationItem.title = @"Map View";
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

@end
