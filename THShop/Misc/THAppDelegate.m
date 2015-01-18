//
//  THAppDelegate.m
//  THShop
//
//  Created by JackyChain on 12/22/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THAppDelegate.h"
#import "THGAIService.h"
#import "THCrittercismService.h"
#import "THMainWindowService.h"

@implementation THAppDelegate

@synthesize services = _services;

- (NSArray *)services
{
    if (!_services) {
        _services = @[[THMainWindowService mainWindowService],
                      [THGAIService GAIService],
                      [THCrittercismService crittercismService]];
    }
    
    return _services;
}

@end
