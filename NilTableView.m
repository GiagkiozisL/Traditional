
#import "NilTableView.h"

@implementation NilTableView
@synthesize imageView;

#pragma mark - Initalization

- (void)drawRect:(CGRect)rect {
    
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 50)];
    imageView.image = [UIImage imageNamed:@"likedLabel.png"];
    imageView.contentMode = UIViewContentModeCenter;
    
    [self addSubview:imageView];
}


@end
