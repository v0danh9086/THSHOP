//
//  THMainWindowService.m
//  THShop
//
//  Created by JackyChain on 12/22/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THMainWindowService.h"

#import "THNavigationViewController.h"
#import "THAppDelegate.h"

@implementation THMainWindowService

+ (instancetype)mainWindowService
{
    return [[THMainWindowService alloc] init];
}

- (THAppDelegate *)appDelegate
{
    return (THAppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self appDelegate].window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    UIWindow *window = [self appDelegate].window;
    
    window.backgroundColor = [UIColor whiteColor];
    window.rootViewController = [[THNavigationViewController alloc] init];
    
    [window makeKeyAndVisible];
    
    return YES;
}

@end
