
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface TGDetailTableViewController : UITableViewController <UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (strong, nonatomic) IBOutlet UIImageView *starImg;
@property (strong, nonatomic) IBOutlet UIImageView *season1Img;
@property (strong, nonatomic) IBOutlet UIImageView *season2Img;
@property (strong, nonatomic) IBOutlet UIImageView *season3Img;
@property (strong, nonatomic) IBOutlet UIImageView *season4Img;
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UILabel *guesthouseName;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *guestHouseKind;
@property (strong, nonatomic) IBOutlet UILabel *roomsNumber;
@property (strong, nonatomic) IBOutlet UILabel *owner;
@property (strong, nonatomic) IBOutlet UIImageView *star1;
@property (strong, nonatomic) IBOutlet UIImageView *star2;
@property (strong, nonatomic) IBOutlet UIImageView *star3;
@property (strong, nonatomic) IBOutlet UIImageView *star4;
@property (strong, nonatomic) IBOutlet UIImageView *star5;
@property (strong, nonatomic) IBOutlet UIImageView *seaImg;
@property (strong, nonatomic) IBOutlet UIImageView *mountainImg;
@property (strong, nonatomic) IBOutlet UIImageView *ownerPic;
@property (strong, nonatomic) IBOutlet UILabel *region;

@property(nonatomic) NSInteger myValue;
@property(nonatomic) NSString *tempName;
@property(nonatomic) NSString *tempRegion;
@property(nonatomic) UIImage *tempImage;
@property(nonatomic) NSString *tempOwnersObjId;
@property(nonatomic) NSString *tempLodgingType;
@property(nonatomic) NSString *tempRoomsNumber;
- (IBAction)backBtn:(id)sender;

@end
