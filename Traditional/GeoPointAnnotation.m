
#import "GeoPointAnnotation.h"
#import "AppDelegate.h"

@interface GeoPointAnnotation()

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) PFObject *object;
@property (nonatomic, strong) PFGeoPoint *geopoint;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, assign) MKPinAnnotationColor pinColor;
@end

@implementation GeoPointAnnotation
NSString *nameEvent;

#pragma mark - Initialization

- (id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate andTitle:(NSString *)aTitle andSubtitle:(NSString *)aSubtitle {
    self = [super init];
    if (self) {
        self.coordinate = aCoordinate;
        self.title = aTitle;
        self.subtitle = aSubtitle;
        
    }
    return self;
}

- (id)initWithPFObject:(PFObject *)anObject {
    
    self.object = anObject;
    self.geopoint = [anObject objectForKey:ParseCoordinatesKey];
//    self.user = [anObject objectForKey:ParseTitleKey];
    //  [anObject fetchIfNeeded];
    CLLocationCoordinate2D aCoordinate = CLLocationCoordinate2DMake(self.geopoint.latitude, self.geopoint.longitude);
    NSString *aTitle = [anObject objectForKey:ParseNameKey];
    NSString *aSubtitle = [anObject objectForKey:ParseMunicipalityKey];
    return [self initWithCoordinate:aCoordinate andTitle:aTitle andSubtitle:aSubtitle];
}

- (BOOL)equalToPost:(GeoPointAnnotation *)aPost {
    if (aPost == nil) {
        return NO;
    }
    
    if (aPost.object && self.object) {
        // We have a PFObject inside the PAWPost, use that instead.
        if ([aPost.object.objectId compare:self.object.objectId] != NSOrderedSame) {
            return NO;
        }
        return YES;
    } else {
        // Fallback code:
        
        if ([aPost.title compare:self.title] != NSOrderedSame ||
            [aPost.subtitle compare:self.subtitle] != NSOrderedSame ||
            aPost.coordinate.latitude != self.coordinate.latitude ||
            aPost.coordinate.longitude != self.coordinate.longitude ) {
            return NO;
        }
        
        return YES;
    }
}

- (void)setTitleAndSubtitleOutsideDistance:(BOOL)outside {
    if (outside) {
        self.subtitle = nil;
        self.title = @"WTF?";
        self.pinColor = MKPinAnnotationColorRed;
    } else {
        self.title = [self.object objectForKey:ParseNameKey];
        self.subtitle = [self.object objectForKey:ParseMunicipalityKey];
        self.pinColor = MKPinAnnotationColorRed;
    }
}

@end
