//
//  THProductImages.m
//  THShop
//
//  Created by JackyChain on 12/24/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THProductImages.h"
#import "THProduct.h"


@implementation THProductImages

+ (THProductImages *)productImageWithArray:(NSArray *)array
{
    THProductImages *product = [[THProductImages alloc] init];
    
    int n = [array count];
    
    switch (n) {
        case 3: {
            product.large_url = array[2];
        }
        case 2: {
            product.medium_url = array[1];
        }
        case 1: {
            product.small_url = array[0];
        }
    }
    
    return product;
}

+ (NSSet *)imageSetForProductDictionary:(NSDictionary *)dict
{
    int i = 0;
    NSMutableSet *productSet = [[NSMutableSet alloc] init];
    
    for (NSArray *dataSet in [dict valueForKey:@"images"]) {
        
        THProductImages *item = [THProductImages productImageWithArray:dataSet];
        [productSet addObject:item];
        
        item.image_id = [NSString stringWithFormat:@"%d", i];
        i++;
        //NSLog(@"%@", item);
        
    }
    
    return productSet;
}

@end
