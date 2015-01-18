//
//  THBookmarkHeaderViewCell.m
//  THShop
//
//  Created by JackyChain on 12/27/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THBookmarkHeaderViewCell.h"

#import "THProductManager.h"
#import "SVProgressHUD.h"
#import "UILabel+Additions.h"

@interface THBookmarkHeaderViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *numberOfProductLabel;
@property (weak, nonatomic) IBOutlet UILabel *inCartLabel;



@end

@implementation THBookmarkHeaderViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] objectAtIndex:0];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)changeNumberOfBookmarkProduct:(NSInteger)numberProducts
{
    self.numberOfProductLabel.text = [NSString stringWithFormat:@"%ld product(s)", (long)numberProducts];
    [self.numberOfProductLabel sizeToFitKeepHeight];
    
    CGRect frame = self.inCartLabel.frame;
    frame.origin.x = CGRectGetMaxX(self.numberOfProductLabel.frame) + 5;
    self.inCartLabel.frame = frame;
    
}

+ (CGFloat)getHeight
{
    return 88;
}
- (IBAction)checkOutButtonPressed:(UIButton *)sender {
    if (![THProductManager getAllBookmarkedProductCount]) {
        [SVProgressHUD showErrorWithStatus:@"Cart is empty!"];
    }
    
    
}



@end
