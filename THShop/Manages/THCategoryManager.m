//
//  THCategoryManager.m
//  THShop
//
//  Created by JackyChain on 12/24/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THCategoryManager.h"
#import "THCategory.h"
#import "BaseHTTPManager.h"

#define THSHOP_CATEGORY_NAME @"categories"

@implementation THCategoryManager

SINGLETON_MACRO

- (void)getMenulistOncomplete:(void (^)(NSArray *))complete orFailure:(void (^)(NSError *))failure
{
    NSString *path = [NSString stringWithFormat:@"%@%@",API_SERVER_HOST,API_GET_LIST_CATEGORY];
    
    [[BaseHTTPManager sharedInstance] GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (complete) {
            
            NSArray *productSet = [self getListMenu:[responseObject valueForKey:THSHOP_CATEGORY_NAME] ];
            complete(productSet);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (NSArray *)getListMenu:(NSArray *)categories
{
    NSMutableArray *menuList = [[NSMutableArray alloc] init];
    
    for (NSDictionary *category in categories) {
        THCategory *item = [THCategory categoryWithDictionary:category];
        
        [menuList addObject:item];
    }
    
    return menuList;
}


@end
