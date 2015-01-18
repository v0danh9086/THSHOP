//
//  THProductManager.m
//  THShop
//
//  Created by JackyChain on 12/24/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THProductManager.h"
#import "THBookmarkViewController.h"
#import "THProduct.h"

@implementation THProductManager

SINGLETON_MACRO

+ (void)getProductWithProductID:(NSString *)product_id
                 onSuccessBlock:(void (^)(id product))successBlock
                        failure:(THJSONRequestFailureBlock)failureBlock
{
    NSDictionary *params = @{@"product_id": product_id};
    NSString *path = [NSString stringWithFormat:@"%@%@",API_SERVER_HOST,API_GET_PRODUCT_BY_PRODUCT_ID];
    
    [[BaseHTTPManager sharedInstance] GET:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (successBlock) {
            successBlock( [[responseObject valueForKey:@"products"] firstObject] );
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //code
        
        NSHTTPURLResponse *respone = (NSHTTPURLResponse *)task.response;
        failureBlock(respone.statusCode, error);
    }];
}

+ (void)getListProductWithArrayProductID:(NSArray *)product_id_array
                          onSuccessBlock:(void (^)(NSMutableArray *products))successBlock
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    if (!product_id_array) {
        product_id_array = [[THProductManager alloc] getAllBookmarkedProduct];
    }
    
    [product_id_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [THProductManager getProductWithProductID:[obj valueForKey:STORE_PRODUCT_ID] onSuccessBlock:^(id product) {
            
            THProduct *value = [THProduct productWithDictionary:product];
            [arr addObject:value];
            
            if (successBlock) {
                successBlock(arr);
            }
            
        } failure:^(NSInteger statusCode, NSError *error) {
            //
        }];

    }];

}

- (void)getListProductWithCategoryID:(NSString *)category_id
                      onSuccessBlock:(THJSONRequestSuccessBlock)successBlock
                             failure:(THJSONRequestFailureBlock)failureBlock
{
    if (!category_id) {
        return;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@%@", API_SERVER_HOST,API_GET_PRODUCT_BY_CATEGORY_ID];
    NSDictionary *params = @{@"category_id": category_id};
    
    [[BaseHTTPManager sharedInstance] GET:path
                               parameters:params
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      //code
                                      
                                      [[THProductManager shareInstance] productsFromResponeObject:[responseObject valueForKey:@"products"] onSuccess:^(NSArray *products) {
                                          
                                          NSHTTPURLResponse *respone = (NSHTTPURLResponse *)task.response;
                                          successBlock(respone.statusCode, products);
                                      }];
                                  
                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      //code
                                      
                                      NSHTTPURLResponse *respone = (NSHTTPURLResponse *)task.response;
                                      failureBlock(respone.statusCode, error);
                                  }];
    
}

- (BOOL)isBookmarkedAlreadyWithProductID:(NSString *)product_id
{
    if (product_id) {
        NSMutableArray *productBookmarked = [self getAllBookmarkedProduct] ;
        
        for (NSDictionary *dict in productBookmarked) {
            NSString *pro_id = [dict valueForKey:STORE_PRODUCT_ID];
            
            if ([pro_id isEqualToString:product_id]) {
                
                return YES;
            }
        }
        
        [self saveBookmarkProductWithArray:productBookmarked];
    }
    
    return NO;
}

- (BOOL)removeBookmarkProductWithProductID:(NSString *)product_id
{
    if (product_id) {
        NSMutableArray *productBookmarked = [[NSMutableArray alloc] initWithArray:[self getAllBookmarkedProduct]] ;
        
        for (NSDictionary *dict in productBookmarked) {
            NSString *pro_id = [dict valueForKey:STORE_PRODUCT_ID];
            
            if ([pro_id isEqualToString:product_id]) {
                
                [productBookmarked removeObject:dict];
                break;
            }
        }
        
        return [self saveBookmarkProductWithArray:productBookmarked];
    }
    return NO;
}

- (NSMutableArray *)getAllBookmarkedProduct
{
    NSMutableArray *bookmarkedProduct = [[NSUserDefaults standardUserDefaults] objectForKey:STORE_PRODUCT_BOOKMARK];
    
    if (bookmarkedProduct) {
        return bookmarkedProduct;
    }
    
    return [[NSMutableArray alloc] init];
}

- (BOOL)bookmarkProductWithProductID:(NSString *)product_id
{
    return [self bookmarkProductWithProductID:product_id withQuantity:1];
}

- (BOOL)bookmarkProductWithProductID:(NSString *)product_id withQuantity:(NSInteger)quantity
{
    if ([self isBookmarkedAlreadyWithProductID:product_id]) {
        return [self updateProductWithProductID:product_id withQuantity:quantity];
    }
    
    NSDictionary *product = @{STORE_PRODUCT_ID: product_id,
                              STORE_PRODUCT_NUMBER: @(quantity)};
    
    NSMutableArray *bookmarkedProduct = [[NSMutableArray alloc] initWithArray:[self getAllBookmarkedProduct]];
    
    [bookmarkedProduct addObject:product];
    return [self saveBookmarkProductWithArray:bookmarkedProduct];
}

- (BOOL)updateProductWithProductID:(NSString *)product_id withQuantity:(NSInteger)quantity
{
    if (product_id) {
        NSMutableArray *productBookmarked = [[NSMutableArray alloc] initWithArray:[[self getAllBookmarkedProduct] copy] ] ;
        NSDictionary *product = @{STORE_PRODUCT_ID: product_id,
                                  STORE_PRODUCT_NUMBER: @(quantity)};
        
        int index = 0;
        for (NSDictionary *dict in productBookmarked) {
            
            NSString *pro_id = [dict valueForKey:STORE_PRODUCT_ID];
            if ([pro_id isEqualToString:product_id]) {
                
                [productBookmarked replaceObjectAtIndex:index withObject:product];
                break;
                
            }
            index++;
        }
        
        return [self saveBookmarkProductWithArray:productBookmarked];
    }
    
    return NO;
}

// Class method
+ (NSInteger)getAllBookmarkedProductCount
{
    NSArray *productBookmarked = [[[NSUserDefaults standardUserDefaults] objectForKey:STORE_PRODUCT_BOOKMARK] copy];
    
    return [productBookmarked count];
}

+ (BOOL)removeAllBookmarked
{
    NSArray *productBookmarked = nil;
    return [[THProductManager alloc] saveBookmarkProductWithArray:productBookmarked];
}

// Helpers function

- (BOOL)saveBookmarkProductWithArray:(NSArray *)productArray
{
    [[NSUserDefaults standardUserDefaults] setObject:productArray forKey:STORE_PRODUCT_BOOKMARK];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)productsFromResponeObject:(NSArray *)productDictionaryArray
                        onSuccess:(void(^)(NSArray *products))succcessBlock
{
    NSMutableArray *arrProduct = [[NSMutableArray alloc] init];
    NSBlockOperation *saveInBackgound = [NSBlockOperation blockOperationWithBlock:^{
        [productDictionaryArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            THProduct *product = [THProduct productWithDictionary:obj];
            [arrProduct addObject:product];
        }];
    }];
    
    [saveInBackgound setCompletionBlock:^{
        if (succcessBlock) {
            succcessBlock(arrProduct);
        }
    }];
    
    [saveInBackgound start];
}


@end
