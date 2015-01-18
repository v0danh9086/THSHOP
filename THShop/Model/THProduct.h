//
//  THProduct.h
//  THShop
//
//  Created by JackyChain on 12/24/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class THCategory, THProductImages;

@interface THProduct : NSObject

+ (THProduct *)productWithDictionary:(NSDictionary *)dict;
+ (NSSet *)productSetWithDictionary:(NSDictionary *)dict;

@property (nonatomic, copy) NSString * color;
@property (nonatomic, copy) NSString * detail;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * product_code;
@property (nonatomic, copy) NSString * product_id;
@property (nonatomic, copy) NSString * sale_price;
@property (nonatomic, copy) NSString * size;
@property (nonatomic, copy) NSString * stock;
@property (nonatomic, copy) NSString * stock_status;
@property (nonatomic, copy) THCategory *category;
@property (nonatomic, copy) NSSet *images;

@end