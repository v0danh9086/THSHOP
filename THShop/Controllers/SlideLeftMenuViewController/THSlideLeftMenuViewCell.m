//
//  THSlideLeftMenuViewCell.m
//  THShop
//
//  Created by JackyChain on 12/31/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THSlideLeftMenuViewCell.h"

@interface THSlideLeftMenuViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView            * sidebarMenuImage;
@property (weak, nonatomic) IBOutlet UILabel                * sidebarMenuTitle;

@end

@implementation THSlideLeftMenuViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)customCategoryCellWithCategory:(THCategory *)category
{
    if (category) {
        self.sidebarMenuTitle.text = [category name];
        
        if ([category parent_id]) {
            self.sidebarMenuTitle.text = [NSString stringWithFormat:@"    %@",[category name]];
        }
    }
}

- (void)configWithData:(id)data
{
    self.sidebarMenuTitle.text = [data objectForKey:MENU_TITLE];
}

#pragma mark - Helpers

+ (CGFloat)getHeight
{
    return 43;
}

@end
