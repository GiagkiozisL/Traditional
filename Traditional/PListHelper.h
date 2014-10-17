
#import <Foundation/Foundation.h>

@interface PListHelper : NSObject

-(NSString*)docDirectoryPath;
-(BOOL)copyResourceToDir:(NSString*)resourceName andResourceType:(NSString*)resourceType;
-(NSDictionary*)getDatafromPlist:(NSString*)thePlist;
-(BOOL)addDataToPlist:(NSMutableDictionary*)therecordDict toPlist:(NSString*)plistName;

@end
