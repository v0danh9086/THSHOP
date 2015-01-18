//
//  THProductManager.h
//  THShop
//
//  Created by JackyChain on 12/24/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THBaseModelManager.h"

@interface THProductManager : THBaseModelManager

+ (void)getProductWithProductID:(NSString *)product_id
                 onSuccessBlock:(void (^)(id product))successBlock
                        failure:(THJSONRequestFailureBlock)failureBlock;
+ (void)getListProductWithArrayProductID:(NSArray *)product_id_array
                          onSuccessBlock:(void (^)(NSMutableArray *products))successBlock;

- (void)getListProductWithCategoryID:(NSString *)category_id
                      onSuccessBlock:(THJSONRequestSuccessBlock)successBlock
                             failure:(THJSONRequestFailureBlock)failureBlock;

- (BOOL)isBookmarkedAlreadyWithProductID:(NSString *)product_id;
- (BOOL)removeBookmarkProductWithProductID:(NSString *)product_id;
- (NSMutableArray *)getAllBookmarkedProduct;

- (BOOL)bookmarkProductWithProductID:(NSString *)product_id;
- (BOOL)bookmarkProductWithProductID:(NSString *)product_id withQuantity:(NSInteger)quantity;
- (BOOL)updateProductWithProductID:(NSString *)product_id withQuantity:(NSInteger)quantity;

+ (NSInteger)getAllBookmarkedProductCount;
+ (BOOL)removeAllBookmarked;


@end
