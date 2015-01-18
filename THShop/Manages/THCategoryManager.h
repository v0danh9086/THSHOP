//
//  THCategoryManager.h
//  THShop
//
//  Created by JackyChain on 12/24/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//
#define MENU_LIST_USERDEFAULT       @"menu_list"

#import "THBaseModelManager.h"

@interface THCategoryManager : THBaseModelManager

- (void)getMenulistOncomplete:(void(^)(NSArray *menu))complete orFailure:(void(^)(NSError *error))failure;

@end
