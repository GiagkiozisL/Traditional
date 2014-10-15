
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Venues : NSManagedObject

@property (nonatomic, retain) NSString * objectId;
@property (nonatomic, retain) NSNumber * isMyFavorite;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * profileImage;

@end
