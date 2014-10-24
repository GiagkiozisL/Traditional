
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#import "Reachability.h"
#import "TGMapViewController.h"
#import "TGSideMenuViewController.h"
#import "GeoPointAnnotation.h"
#import "AppDelegate.h"
#import "ILTranslucentView.h"
#import "TGEventDetailViewController.h"

@interface TGMapViewController ()

@property (nonatomic, strong) CLLocation *location;
//@property (nonatomic, strong) CLLocationDistance radius;
//@property (nonatomic, strong) NSString *className;
@end

@implementation TGMapViewController
@synthesize location;
@synthesize mapView;
@synthesize locationManager;
@synthesize segmentAccurancy;

double selectedSegmentValue = 200.00;
GeoPointAnnotation *geoPointAnnotation;
ILTranslucentView *ilTransLucentView;

#pragma mark - UIViewController

-(void)viewWillAppear:(BOOL)animated {
    //customize segmentControl background
    ilTransLucentView = [[ILTranslucentView alloc]initWithFrame:CGRectMake(0, 0, segmentAccurancy.layer.frame.size.width, segmentAccurancy.layer.frame.size.height)];
    ilTransLucentView.layer.cornerRadius = 10.0;
    ilTransLucentView.clipsToBounds = YES;
    ilTransLucentView.alpha = 0.6;
    [self.mapView addSubview:ilTransLucentView];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    [self updateLocations];
    mapView.showsUserLocation = YES;
    mapView.mapType = MKMapTypeHybrid;
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    navBar.backgroundColor = [UIColor whiteColor];
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    navItem.title = @"MapView";
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"burgerIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(openButtonPressed)];
    navItem.leftBarButtonItem = menuItem;
    navBar.items = @[ navItem ];
    [self.view addSubview:navBar];
    [self getCurrentLocation];
    
}

-(void)updateLocations {
// remove all pins first
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        if (![annotation isKindOfClass:[MKUserLocation class]]) {
            [self.mapView removeAnnotation:annotation];
        }
    }
    PFQuery *query = [PFQuery queryWithClassName:ParsePostsClassKey];
    PFGeoPoint *userPoint = [PFGeoPoint geoPointWithLatitude:self.mapView.userLocation.coordinate.latitude
                                                   longitude:self.mapView.userLocation.coordinate.longitude];
    [query whereKey:ParseCoordinatesKey nearGeoPoint:userPoint withinKilometers:selectedSegmentValue];
    query.limit = 1000;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error in geo query!"); // todo why is this ever happening?
        } else {
            for (PFObject *object in objects) {
                geoPointAnnotation = [[GeoPointAnnotation alloc]
                                      initWithPFObject:object];
                
                [self.mapView addAnnotation:geoPointAnnotation];
            }
        }
        NSLog(@"count objects:%ld",(long)objects.count);
    }];
}

-(void)getCurrentLocation {
    [self checkForWIFIConnection];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if(IS_OS_8_OR_LATER) {
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
    }
    [locationManager startUpdatingLocation];
}

-(void)openButtonPressed {
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}

-(void)checkForWIFIConnection {
    Reachability* wifiReach = [Reachability reachabilityForLocalWiFi];
    Reachability* cellular = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
    NetworkStatus netStatus1 = [cellular currentReachabilityStatus];
    
    if (netStatus!=ReachableViaWiFi && netStatus1!=ReachableViaWWAN)
    {
        
        NSString *cancelTitle = @"OK";
        UIAlertView *alertView1 = [[UIAlertView alloc]
                                   initWithTitle:@"Connection Failed"
                                   message:@"Please,check your internet connection(WiFi or Cellular)"
                                   delegate:self
                                   cancelButtonTitle:cancelTitle
                                   otherButtonTitles:  nil ];
        [alertView1 show];
    }
}

#pragma mark - MKMapViewDelegate

-(void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 2.925;
    span.longitudeDelta = 2.925;
    CLLocationCoordinate2D locationCoordinate;
    locationCoordinate.latitude = aUserLocation.coordinate.latitude;
    locationCoordinate.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = locationCoordinate;
    [aMapView setRegion:region animated:YES];
}

#pragma mark -MKAnnotation

-(MKAnnotationView *) mapView:(MKMapView *)aMapView viewForAnnotation:(id<MKAnnotation>)annotation {
   
    //  fill 2 lines above when implement the detail view for each pin
    TGEventDetailViewController *detailView = [[TGEventDetailViewController alloc]init];
    detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"TGEventDetailViewController"];
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *pinIdentifier = @"CustomPinAnnotation";
    
    if ([annotation isKindOfClass:[GeoPointAnnotation class]]) {
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[aMapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];
        
        if(!pinView) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinIdentifier];
        }
        else {
            pinView.annotation = annotation;
        }
        pinView.pinColor = [(GeoPointAnnotation *)annotation pinColor];
        pinView.canShowCallout = YES;
        pinView.image = [UIImage imageNamed:@"facebook.png"];
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoDark];
        
        return pinView;
    }
    return nil;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    TGEventDetailViewController *eventDetail = (TGEventDetailViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"TGEventDetailViewController"];
    
    geoPointAnnotation = (GeoPointAnnotation*)view.annotation;
    
    //retrieve object and image
    PFObject *object = geoPointAnnotation.object;
    PFQuery *query = [PFQuery queryWithClassName:@"Venues"];
    [query getObjectInBackgroundWithId:object.objectId
                                 block:^(PFObject *textdu, NSError *error) {
                                     {
                                         // do your thing with text
                                         if (!error) {
                                             PFFile *imageFile = [textdu objectForKey:@"image"];
                                             [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                                                 if (!error) {
                                             //        eventDetail.eventImg.image = [UIImage imageWithData:data];
                                             //        dataTemp = data;
                                                 }
                                             }];
                                         }                                         }
                                 }];
    
//    eventDetail.tempImage = [UIImage imageWithData:dataTemp];
//    eventDetail.dateTxt = [NSString stringWithFormat:@"%@",geoPointAnnotation.subtitle];
//    eventDetail.titleTxt = [NSString stringWithFormat:@"%@",geoPointAnnotation.title];
//    eventDetail.descriptTxt = [object objectForKey:@"desciption"];
    NSLog(@"%@ %@ %@",geoPointAnnotation.subtitle,geoPointAnnotation.title,[object objectForKey:@"desciption"]);
   [[self navigationController] pushViewController:eventDetail animated:YES];
      }

#pragma mark - UIActions

- (IBAction)AccurancyChanged:(id)sender {

    switch (self.segmentAccurancy.selectedSegmentIndex) {
        case 0:
            selectedSegmentValue = 100.00;
            break;
        case 1:
            selectedSegmentValue = 200.00;
            break;
        case 2:
            selectedSegmentValue = 300.00;
            break;
        case 3:
            selectedSegmentValue = 500.00;
            break;
        case 4:
            selectedSegmentValue = 2000.00;
            break;
        default:
            break;
    }
    
    
    [self getCurrentLocation];
    [self updateLocations];
}

@end
