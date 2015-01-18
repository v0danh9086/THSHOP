//
//  THBaseModelManager.m
//  THShop
//
//  Created by JackyChain on 12/24/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THBaseModelManager.h"

@implementation THBaseModelManager

+ (instancetype)shareInstance
{
    DLog(@"Warning! Must always override +sharedInstance method with SINGLETON_MACRO in subclass of THBaseModelManager");
    
    static dispatch_once_t once;
    static id __singleton = nil;
    
    dispatch_once(&once, ^{
        __singleton = [[self alloc] init];
    });
    
    return __singleton;
}

- (void)sendNotification:(NSString *)notificationName
{
    [self sendNotification:notificationName body:nil];
}

- (void)sendNotification:(NSString *)notificationName body:(id)body
{
    [self sendNotification:notificationName body:body type:nil];
}

- (void)sendNotification:(NSString *)notificationName body:(id)body type:(id)type
{
    NSMutableDictionary *dict = nil;
    
    if (body || type) {
        
        dict = [[NSMutableDictionary alloc] init];
        
        if (body) { [dict setObject:body forKey:@"body"]; }
        if (type) { [dict setObject:type forKey:@"type"]; }
    }
    
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:notificationName object:self userInfo:dict] ];
}

@end
