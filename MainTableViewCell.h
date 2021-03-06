
#import <UIKit/UIKit.h>

@interface MainTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *houseNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *areaLabel;
@property (strong, nonatomic) IBOutlet UILabel *streetLabel;
@property (strong, nonatomic) IBOutlet UIImageView *houseImage;
@property (strong, nonatomic) IBOutlet UIView *shadowView;
@property (strong, nonatomic) IBOutlet UIImageView *shadowImage;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;

@property (strong, nonatomic) IBOutlet UIImageView *fallImg;
@property (strong, nonatomic) IBOutlet UIImageView *winterImg;
@property (strong, nonatomic) IBOutlet UIImageView *springImg;
@property (strong, nonatomic) IBOutlet UIImageView *summerImg;

@property (nonatomic, assign)  BOOL laidOut;

@end
