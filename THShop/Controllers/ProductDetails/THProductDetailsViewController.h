//
//  THDetailsViewController.h
//  THShop
//
//  Created by JackyChain on 12/25/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THBaseViewController.h"
#import "THProduct.h"

@interface THProductDetailsViewController : THBaseViewController

@property (strong, nonatomic) THProduct                     *product;
@property (strong, nonatomic) NSString                     *category_id;


- (void)reachabilityDidChange:(NSNotification *)notification;


@end
