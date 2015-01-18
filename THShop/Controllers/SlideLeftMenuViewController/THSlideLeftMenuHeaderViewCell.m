//
//  THSlideLeftMenuHeaderCell.m
//  THShop
//
//  Created by JackyChain on 12/31/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THSlideLeftMenuHeaderViewCell.h"

@interface THSlideLeftMenuHeaderViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *sectionTitle;
@property (weak, nonatomic) IBOutlet UIImageView *sectionIcon;

@end


@implementation THSlideLeftMenuHeaderViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

- (void)configIconWithImageURL:(NSString *)iconURL
{
    self.sectionIcon.image = [UIImage imageNamed:iconURL];
}

- (void)configTitleNameWithString:(NSString *)title
{
    self.sectionTitle.text = title;
}

+ (CGFloat)getHeight
{
    return 20;
}

@end
