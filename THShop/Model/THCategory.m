//
//  THCategory.m
//  THShop
//
//  Created by JackyChain on 12/24/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THCategory.h"
#import "THProduct.h"


@implementation THCategory

+ (THCategory *)categoryWithDictionary:(NSDictionary *)dictionary
{
    THCategory *category = nil;
    
    if (![dictionary[@"name"] isKindOfClass:[NSNull class]] ) {
        category = [[THCategory alloc] init];
        category.category_id = dictionary[@"term_id"];
        category.name = dictionary[@"name"];
        category.parent_id = dictionary[@"parent"];
        
    }
    return category;
}

@end
