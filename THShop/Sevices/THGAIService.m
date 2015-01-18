//
//  THGAIService.m
//  THShop
//
//  Created by JackyChain on 12/22/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THGAIService.h"

#import "GAI.h"

#warning input GoogleAnalytics app id
static NSString *THGAIAppID = @"UA-57928006-1";

@implementation THGAIService

+ (instancetype)GAIService
{
    return [[THGAIService alloc] init];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = -1;
    [[GAI sharedInstance].logger setLogLevel:kGAILogLevelVerbose];
    [[GAI sharedInstance] trackerWithTrackingId:THGAIAppID];
    
    return YES;
}

@end
