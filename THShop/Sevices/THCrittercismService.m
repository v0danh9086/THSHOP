//
//  THCrittercismService.m
//  THShop
//
//  Created by JackyChain on 12/22/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THCrittercismService.h"

#import "Crittercism.h"

static NSString *crittercismAppID = @"5497e0bb51de5e9f042ec54e";

@implementation THCrittercismService

+ (instancetype)crittercismService
{
    return[[THCrittercismService alloc] init];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Crittercism enableWithAppID:crittercismAppID];
    
    return YES;
}

@end
