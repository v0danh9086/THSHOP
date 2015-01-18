//
//  THBaseModelManager.h
//  THShop
//
//  Created by JackyChain on 12/24/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseHTTPManager.h"

#define SINGLETON_MACRO + (instancetype)shareInstance { static dispatch_once_t once; static id __singleton = nil; dispatch_once(&once, ^{ __singleton = [[self alloc] init]; }); return __singleton; }

typedef void(^THJSONRequestSuccessBlock)(NSInteger statusCode, NSArray *productArray);
typedef void(^THJSONRequestFailureBlock)(NSInteger statusCode, NSError *error);
typedef void(^THJSONNonceSuccessBlock)(NSInteger statusCode, NSString *nonce);

@interface THBaseModelManager : NSObject

+ (instancetype)shareInstance;

- (void)sendNotification:(NSString *)notificationName;
- (void)sendNotification:(NSString *)notificationName body:(id)body;
- (void)sendNotification:(NSString *)notificationName body:(id)body type:(id)type;


@end
