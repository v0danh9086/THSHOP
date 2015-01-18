//
//  THProductCollectionCell.m
//  THShop
//
//  Created by JackyChain on 12/23/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THProductCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "THProductImages.h"
#import "UIColor+Custom.h"
#import "NSString+Additions.h"

@interface THProductCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *productImgView;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;



@end

@implementation THProductCollectionCell

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

- (void)customCellWithProduct:(THProduct *)product
{
    if (product) {
        [self.productImgView setImageWithURL:[NSURL URLWithString:[[product.images anyObject] medium_url] ]];
        
        self.productName.text = product.name;
        [self.productName setFont:[UIFont fontWithName:@"Lato" size:14]];
        [self.productName setTextColor:[UIColor titleColor]];
        
        self.productPrice.text = [NSString getVNCurrencyFormatterWithNumber:[NSNumber numberWithInt:[product.price intValue]] ];
    }
}

@end
