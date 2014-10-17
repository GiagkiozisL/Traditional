
#import "PListHelper.h"

@implementation PListHelper

//gets your application document path
-(NSString*)docDirectoryPath {
    NSArray *docDirArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [docDirArray objectAtIndex:0];
}

-(BOOL)copyResourceToDir:(NSString *)resourceName andResourceType:(NSString *)resourceType {
    
    if (resourceName.length!=0 && resourceType.length!=0)
    {
        NSString *itemtoCopy = [[NSBundle mainBundle]pathForResource:resourceName ofType:resourceType];
        
        return  [[NSFileManager defaultManager] copyItemAtPath:itemtoCopy toPath:[[self docDirectoryPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",resourceName,resourceType]] error:nil];
    }
    else
    {
        return NO;
    }
}

//Enter the plist file as a parameter and it will search in the doc directory and fetch the records accordingly
- (NSDictionary*)getDatafromPlist:(NSString*)theplist {
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[self docDirectoryPath] stringByAppendingPathComponent:theplist]];
    return dict;
}

- (BOOL)addDataToPlist:(NSMutableDictionary*)therecordDict toPlist:(NSString*)plistName {
    
    if (therecordDict.count !=0 && plistName.length!=0)
    {
        [therecordDict writeToFile:[[self docDirectoryPath] stringByAppendingPathComponent:plistName] atomically:YES];
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
