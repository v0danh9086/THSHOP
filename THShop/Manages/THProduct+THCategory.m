//
//  THProduct+THCategory.m
//  THShop
//
//  Created by JackyChain on 12/22/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THProduct+THCategory.h"
#import "BaseHTTPManager.h"

@implementation THProduct (THCategory)

- (void)productsByProductID:(NSString *)productID OnComplete:(void(^)(THProduct *product))complete orFailure:(void(^)(NSError *error))failure
{
    NSDictionary *params = @{@"product_id": productID};
    NSString *path = [NSString stringWithFormat:@"%@%@",API_SERVER_HOST,API_GET_PRODUCT_BY_PRODUCT_ID];
    
    [[BaseHTTPManager sharedInstance] GET:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        THProduct *product = [THProduct productWithDictionary:(NSDictionary *)responseObject];
        if (complete) {
            complete(product);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)productsByCategoryID:(NSString *)categoryID OnComplete:(void(^)(NSSet *productSet))complete orFailure:(void(^)(NSError *error))failure
{
    
    NSString *path = [NSString stringWithFormat:@"%@%@", API_SERVER_HOST, API_GET_PRODUCT_BY_CATEGORY_ID];
    
    NSDictionary *params = @{@"category_id": categoryID};
    [[BaseHTTPManager sharedInstance] GET:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSSet *productSet = [THProduct productSetWithDictionary:(NSDictionary *)responseObject];
        if (complete) {
            complete(productSet);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (NSSet *)listProductsWithListCategory:(NSDictionary *)listCategory
{
    __block NSMutableSet *products;
    for (NSString *categoryID in [listCategory valueForKey:@"meta_id"]) {
        
        [self productsByCategoryID:categoryID OnComplete:^(NSSet *productSet) {
            [products addObjectsFromArray:[productSet allObjects] ];
        } orFailure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
        
    }
    
    return products;
}

- (void)productsByCategoryURL:(NSString *)categoryUrl OnComplete:(void(^)(NSSet *productSet))complete orFailure:(void(^)(NSError *error))failure
{
    NSString *path = [NSString stringWithFormat:@"%@%@",API_SERVER_HOST,API_GET_LIST_CATEGORY];
    
    [[BaseHTTPManager sharedInstance] GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (complete) {
            NSSet *productSet = [self listProductsWithListCategory:responseObject];
            complete(productSet);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}



@end
