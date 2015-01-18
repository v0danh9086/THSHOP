//
//  THProductImagesManager.m
//  THShop
//
//  Created by JackyChain on 12/25/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THProductImagesManager.h"

#import "THProductImages.h"

@implementation THProductImagesManager

+ (void)getImagesForProduct:(NSString *)product_id onSuccess:(THJSONRequestImageSuccessBlock)successBlock failure:(THJSONRequestFailureBlock)failureBlock
{
    
    NSDictionary *params = @{@"product_id": product_id};
    NSString *path = [NSString stringWithFormat:@"%@%@",API_SERVER_HOST,API_GET_PRODUCT_BY_PRODUCT_ID];
    
    [[BaseHTTPManager sharedInstance] GET:path parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSSet *arrayOfImages = [THProductImages imageSetForProductDictionary:[[responseObject valueForKey:@"products"] firstObject]];
        
        NSHTTPURLResponse *respone = (NSHTTPURLResponse *)task.response;
        if (successBlock) {
            successBlock(respone.statusCode, arrayOfImages);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //code
        
        NSHTTPURLResponse *respone = (NSHTTPURLResponse *)task.response;
        failureBlock(respone.statusCode, error);
    }];
}

@end
