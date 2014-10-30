
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#import "Reachability.h"
#import "TGMapViewController.h"
#import "TGSideMenuViewController.h"
#import "GeoPointAnnotation.h"
#import "AppDelegate.h"
#import "ILTranslucentView.h"
#import "TGDetailTableViewController.h"

@interface TGMapViewController ()

@property (nonatomic, strong) CLLocation *location;

@end

@implementation TGMapViewController
@synthesize location;
@synthesize mapView;
@synthesize locationManager;
@synthesize segmentAccurancy;

NSString *tempTitle;
NSString *tempRegion;
NSData *tempData;
NSData *tempData2;
UIImage *tempImage;
NSString *tempOwnersObjId;
NSString *tempOwner;
NSString *tempLodgingType;
NSString *tempRoomsNumber;

double selectedSegmentValue = 200.00;
GeoPointAnnotation *geoPointAnnotation;
ILTranslucentView *ilTransLucentView;
TGDetailTableViewController *controller;

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
    tempData = nil;
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
    span.latitudeDelta = 5.925;
    span.longitudeDelta = 5.925;
    CLLocationCoordinate2D locationCoordinate;
    locationCoordinate.latitude = aUserLocation.coordinate.latitude;
    locationCoordinate.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = locationCoordinate;
    [aMapView setRegion:region animated:YES];
}

#pragma mark -MKAnnotation

-(MKAnnotationView *) mapView:(MKMapView *)aMapView viewForAnnotation:(id<MKAnnotation>)annotation {
   
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
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoDark];
        
        return pinView;
    }
    return nil;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    NSLog(@"annotationVIEW");
    geoPointAnnotation = (GeoPointAnnotation*)view.annotation;
    //retrieve object and image
    PFObject *object = geoPointAnnotation.object;
    PFQuery *query = [PFQuery queryWithClassName:@"Venues"];
    [query getObjectInBackgroundWithId:object.objectId
                                 block:^(PFObject *objectVenue, NSError *error) {
                                     {
                                         // do your thing with text
                                         if (!error) {
                                             NSLog(@"objId2:%@",[objectVenue objectForKey:@"lodging_type"]);
                                             tempOwnersObjId = [objectVenue [@"objectIdentifier"]objectId];
                                             controller.tempOwnersObjId = [NSString stringWithFormat:@"%@",tempOwnersObjId];
                                             tempLodgingType = [NSString stringWithFormat:@"%@",[objectVenue objectForKey:@"lodging_type"]];
                                             tempRoomsNumber = [NSString stringWithFormat:@"%@",[objectVenue objectForKey:@"rooms"]];
                                             controller.tempLodgingType = [NSString stringWithFormat:@"%@",tempLodgingType];
                                             PFFile *imageFile = [objectVenue objectForKey:@"image"];
                                             [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                                                 if (!error) {
                                                     controller.backgroundImg.image = [UIImage imageWithData:data];
                                                     tempData = data;
                                                 }
                                             }];
                                         }                                         }
                                     
                                     //second query
                                     PFQuery *query2 = [PFQuery queryWithClassName:@"Owners"];
                                     
                                     [query2 whereKey:@"objectId" equalTo:tempOwnersObjId];
                                     
                                     [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                         if (!error) {
                                             for (PFObject *object in objects) {
                                                 tempOwner = [NSString stringWithFormat:@"%@",[object objectForKey:@"full_username"]];
                                                 
                                                 PFFile *profilePic = [object objectForKey:@"profilPic"];
                                                 [profilePic getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                                                     if (!error) {
                                                         
                                                         controller.ownerPic.image = [UIImage imageWithData:data];
                                                         tempData2 = data;
                                                     }
                                                 }];
                                             }
                                         } else {
                                             // Log details of the failure
                                             NSLog(@"Error: %@ %@", error, [error userInfo]);
                                         }
                                     }];
                                     [self performSegueWithIdentifier:@"Details" sender:self];

                                 }];
    
    controller.tempImage = [UIImage imageWithData:tempData];
    tempTitle = geoPointAnnotation.title;
    tempRegion = geoPointAnnotation.subtitle;
}


- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
    
    for (aV in views) {
        // Don't pin drop if annotation is user location
        if ([aV.annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        // Check if current annotation is inside visible map rect, else go to next one
        MKMapPoint point =  MKMapPointForCoordinate(aV.annotation.coordinate);
        if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
            continue;
        }
        CGRect endFrame = aV.frame;
        // Move annotation out of view
        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - self.view.frame.size.height, aV.frame.size.width, aV.frame.size.height);
        
        // Animate drop
        [UIView animateWithDuration:0.5 delay:0.04*[views indexOfObject:aV] options: UIViewAnimationOptionCurveLinear animations:^{
            aV.frame = endFrame;
            // Animate squash
        }completion:^(BOOL finished){
            if (finished) {
                [UIView animateWithDuration:0.05 animations:^{
                    aV.transform = CGAffineTransformMakeScale(1.0, 0.8);
                    
                }completion:^(BOOL finished){
                    if (finished) {
                        [UIView animateWithDuration:0.1 animations:^{
                            aV.transform = CGAffineTransformIdentity;
                        }];
                    }
                }];
            }
        }];
    }
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

#pragma mark - UISegue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepareForSegue");
    if ([segue.identifier isEqualToString:@"Details"]) {
        
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        controller = (TGDetailTableViewController *)navController.topViewController;
        controller.tempRoomsNumber = [NSString stringWithFormat:@"%@",tempRoomsNumber];
        controller.tempLodgingType = [NSString stringWithFormat:@"%@",tempLodgingType];
        controller.tempName = [NSString stringWithFormat:@"%@",tempTitle];
        controller.tempRegion = [NSString stringWithFormat:@"%@",tempRegion];
        controller.tempImage = [UIImage imageWithData:tempData];
    }
}

@end
