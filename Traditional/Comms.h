
#import <Foundation/Foundation.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@protocol CommsDelegate <NSObject>
@optional
- (void) commsDidLogin:(BOOL)loggedIn;
@end

@interface Comms : NSObject
+ (void) login:(id<CommsDelegate>)delegate;
@end
