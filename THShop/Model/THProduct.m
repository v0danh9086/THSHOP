//
//  THProduct.m
//  THShop
//
//  Created by JackyChain on 12/24/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THProduct.h"
#import "THCategory.h"
#import "THProductImages.h"

@interface THProduct ()<NSCopying>

@end


@implementation THProduct

-(id)copyWithZone:(NSZone *)zone
{
    // We'll ignore the zone for now
    THProduct *another = [[THProduct allocWithZone:zone] init];
    
    [another setColor:self.color];
    [another setDetail:self.detail ];
    [another setName:self.name ];
    [another setPrice:self.price ];
    [another setProduct_code:self.product_code ];
    [another setProduct_id:self.product_id ];
    [another setSale_price:self.sale_price ];
    [another setSize:self.size ];
    [another setStock:self.stock ];
    [another setStock_status:self.stock_status ];
    [another setCategory:self.category ];
    [another setImages:self.images ];
    
    return another;
}

+ (THProduct *)productWithDictionary:(NSDictionary *)dict
{
    THProduct *product = nil;
    
    if (![dict[@"name"] isKindOfClass:[NSNull class]]) {
        product = [[THProduct alloc] init];
        product.product_id = [NSString stringWithFormat:@"%@",dict[@"id"]];
        product.color = [NSString stringWithFormat:@"%@",dict[@"color"]];
        product.product_code = [NSString stringWithFormat:@"%@",dict[@"sku"]];
        product.detail = [NSString stringWithFormat:@"%@",dict[@"description"]];
        product.name = dict[@"name"];
        product.price = dict[@"price"];
        product.sale_price = dict[@"sale_price"];
        product.size = dict[@"size"];
        product.stock = dict[@"stock"];
        product.stock_status = dict[@"stock_status"];
        
        product.images = [THProductImages imageSetForProductDictionary:dict];
        
    }
    
    return product;
}


+ (NSSet *)productSetWithDictionary:(NSDictionary *)dict
{
    NSMutableSet *productSet = [[NSMutableSet alloc] init];
    
    for (NSDictionary *dataSet in [dict valueForKey:@"products"]) {
        
        THProduct *item = [THProduct productWithDictionary:dataSet];
        [productSet addObject:item];
        //NSLog(@"%@", item);
        
    }
    
    return productSet;
}

@end
