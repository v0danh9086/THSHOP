//
//  THCategory.h
//  THShop
//
//  Created by JackyChain on 12/24/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class THProduct;

@interface THCategory : NSObject

+ (THCategory *)categoryWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy) NSString * category_id;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * parent_id;
@property (nonatomic, copy) NSSet *products;
@end