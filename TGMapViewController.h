
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <mapKit/MKAnnotation.h>

@interface TGMapViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentAccurancy;

@property (nonatomic, retain) CLLocationManager *locationManager;

- (IBAction)AccurancyChanged:(id)sender;
@end
