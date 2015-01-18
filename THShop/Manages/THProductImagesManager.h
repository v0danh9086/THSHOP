//
//  THProductImagesManager.h
//  THShop
//
//  Created by JackyChain on 12/25/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THBaseModelManager.h"

typedef void(^THJSONRequestImageSuccessBlock)(NSInteger statusCode, NSSet *productImageSet);
//typedef void (^THJSONRequestFailureBlock) (NSInteger statusCode, id obj);

@interface THProductImagesManager : THBaseModelManager

+ (void)getImagesForProduct:(NSString *)product_id
                  onSuccess:(THJSONRequestImageSuccessBlock)successBlock
                    failure:(THJSONRequestFailureBlock)failureBlock;

@end
