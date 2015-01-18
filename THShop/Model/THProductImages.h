//
//  THProductImages.h
//  THShop
//
//  Created by JackyChain on 12/24/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class THProduct;

@interface THProductImages : NSObject

+ (NSSet *)imageSetForProductDictionary:(NSDictionary *)dict;

@property (nonatomic, copy) NSString * image_id;
@property (nonatomic, copy) NSString * large_url;
@property (nonatomic, copy) NSString * medium_url;
@property (nonatomic, copy) NSString * small_url;
@property (nonatomic, copy) THProduct *product;

@end
