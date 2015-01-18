//
//  THBookmarkViewCell.m
//  THShop
//
//  Created by JackyChain on 12/28/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THBookmarkViewCell.h"

#import "THProduct.h"
#import "THProductManager.h"
#import "UIImageView+AFNetworking.h"
#import "THProductImages.h"
#import "NSString+Additions.h"


static NSString * const STORE_PRODUCT_ID            =   @"store_product_id";
static NSString * const STORE_PRODUCT_NUMBER        =   @"store_product_number";

@interface THBookmarkViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productQuantityLabel;

@end

@implementation THBookmarkViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configWithDictionary:(NSDictionary *)dict
{
    NSString *productID = dict[STORE_PRODUCT_ID];
    
    [THProductManager getProductWithProductID:productID onSuccessBlock:^(id product) {
        
        [self bookmarkWithProduct: [THProduct productWithDictionary:product] andQuantity:(long)[dict[STORE_PRODUCT_NUMBER] integerValue]];
        
        
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"Fail THBookmarkViewCell");
    }];
    
}

- (void)bookmarkWithProduct:(THProduct *)product andQuantity:(NSInteger)quantity
{
    if (product) {
        
        [self.productImageView setImageWithURL:[NSURL URLWithString:[[product.images anyObject] small_url]]];
        
        self.productNameLabel.text = product.name;
        //[self.productNameLabel setFont:[UIFont fontWithName:@"Lato" size:17]];
        
        self.productPriceLabel.text = [NSString getVNCurrencyFormatterWithNumber:@([product.price intValue])];
        
        self.productQuantityLabel.text = [NSString stringWithFormat:@"X %ld", (long)quantity];
    }
}


- (void)configWithDictionary:(THProduct *)product andQuantity:(NSInteger)quantity
{
    [self bookmarkWithProduct:product andQuantity:(long)quantity];
}


+ (CGFloat)getHeigh
{
    return 80;
}

@end
