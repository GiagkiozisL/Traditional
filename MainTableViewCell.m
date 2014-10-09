
#import "MainTableViewCell.h"

@implementation MainTableViewCell
@synthesize favoriteButton;


bool isFav = false;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)makeFavorite:(id)sender {
    
//    if (isFav) {
//        [favoriteButton setImage:[UIImage imageNamed:@"star-g.png"] forState:UIControlStateNormal];
//        isFav = false;
//        NSLog(@"++++++++");
//    } else {
//        [favoriteButton setImage:[UIImage imageNamed:@"star-y.png"] forState:UIControlStateNormal];
//        isFav = true;
//        NSLog(@"---------");
//    }
//    NSLog(@"make fav");
}

@end
