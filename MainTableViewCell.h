
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

@end
