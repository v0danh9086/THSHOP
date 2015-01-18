//
//  THBookmarkHeaderViewCell.h
//  THShop
//
//  Created by JackyChain on 12/29/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface THBookmarkHeaderViewCell : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

- (void)changeNumberOfBookmarkProduct:(NSInteger)numberProducts;
+ (CGFloat)getHeight;

@end
