//
//  THBookmarkViewCell.h
//  THShop
//
//  Created by JackyChain on 12/28/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "THProduct.h"

@interface THBookmarkViewCell : SWTableViewCell

//- (void)configWithDictionary:(NSDictionary *)dict;
- (void)configWithDictionary:(THProduct *)product andQuantity:(NSInteger)quantity;
+ (CGFloat)getHeigh;

@end
