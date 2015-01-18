//
//  THSlideLeftMenuHeaderCell.h
//  THShop
//
//  Created by JackyChain on 12/31/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THSlideLeftMenuHeaderViewCell : UITableViewHeaderFooterView

- (void)configTitleNameWithString:(NSString *)title;
- (void)configIconWithImageURL:(NSString *)iconURL;
+ (CGFloat)getHeight;

@end
