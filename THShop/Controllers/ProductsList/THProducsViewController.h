//
//  THProducsViewController.h
//  THShop
//
//  Created by JackyChain on 12/23/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THBaseViewController.h"

static NSString* const DEFAULT_NAVIGATION_TITLE = @"Danh sách sản phẩm";

@interface THProducsViewController : THBaseViewController

@property (copy, nonatomic) NSString *category_id;
@property (copy, nonatomic) NSString *lblTitle;

- (void)reachAbilityDidChange:(NSNotification *)notification;

@end
