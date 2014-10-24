
#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>

@interface GeoPointAnnotation : NSObject <MKAnnotation>

- (id)initWithPFObject:(PFObject *)object;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

@property (nonatomic, readonly, strong) PFObject *object;
@property (nonatomic, readonly, strong) PFGeoPoint *geopoint;

@property (nonatomic, readonly) MKPinAnnotationColor pinColor;


@end