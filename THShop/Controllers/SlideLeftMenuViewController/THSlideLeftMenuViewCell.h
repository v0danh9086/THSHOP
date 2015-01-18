//
//  THSlideLeftMenuViewCell.h
//  THShop
//
//  Created by JackyChain on 12/31/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THCategory.h"

#define MENU_TITLE                      @"name"
#define CATEGORY_ID                     @"term_id"

@interface THSlideLeftMenuViewCell : UITableViewCell

- (void)customCategoryCellWithCategory:(THCategory *)category;
- (void)configWithData:(id)data;
+ (CGFloat)getHeight;

@end
