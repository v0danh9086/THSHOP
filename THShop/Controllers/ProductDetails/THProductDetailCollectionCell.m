//
//  THProductsDetailCollectionCell.m
//  THShop
//
//  Created by JackyChain on 12/25/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THProductDetailCollectionCell.h"
#import "UIImageView+AFNetworking.h"

@interface THProductDetailCollectionCell  ()
@property (weak, nonatomic) IBOutlet UIImageView *productDetailsImageView;

@end

@implementation THProductDetailCollectionCell

- (void)customProductsDetailCellWithProductImage:(THProductImages *)productImage
{
    [self.productDetailsImageView setImageWithURL:[NSURL URLWithString:productImage.large_url]];
}

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

@end
