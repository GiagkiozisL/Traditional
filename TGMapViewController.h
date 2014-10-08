
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <mapKit/MKAnnotation.h>

@interface TGMapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@end
