//
//  THProduct+THCategory.h
//  THShop
//
//  Created by JackyChain on 12/22/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THProduct.h"

@interface THProduct (THCategory)

- (void)productsByProductID:(NSString *)productID OnComplete:(void(^)(THProduct *product))complete orFailure:(void(^)(NSError *error))failure;

- (void)productsByCategoryURL:(NSString *)categoryUrl OnComplete:(void(^)(NSSet *productSet))complete orFailure:(void(^)(NSError *error))failure;

- (void)productsByCategoryID:(NSString *)categoryID OnComplete:(void(^)(NSSet *productSet))complete orFailure:(void(^)(NSError *error))failure;

@end
