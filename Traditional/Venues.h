
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Venues : NSManagedObject

@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSNumber * isMyFavorite;

@end
