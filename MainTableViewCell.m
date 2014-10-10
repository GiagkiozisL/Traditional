
#import "MainTableViewCell.h"

@implementation MainTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)layoutSubviews
{
    
    if (!self.laidOut) {
        
        CAGradientLayer *l = [CAGradientLayer layer];
        l.frame = self.shadowView.bounds;
        UIColor* startColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        UIColor* endColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        l.colors = [NSArray arrayWithObjects:(id)startColor.CGColor, (id)endColor.CGColor, nil];
        [self.shadowView.layer addSublayer:l];
        
        CAGradientLayer *topShadow = [CAGradientLayer layer];
        topShadow.frame = CGRectMake(0, -3, 320, 3);
        UIColor* startColor2 = [UIColor colorWithWhite:0.0 alpha:0.0];
        UIColor* endColor2 = [UIColor colorWithWhite:0.0 alpha:0.1];
        topShadow.colors = [NSArray arrayWithObjects:(id)startColor2.CGColor, (id)endColor2.CGColor, nil];
        [self.layer addSublayer:topShadow];
        
        self.laidOut = YES;
        
    }
}

@end
