//
//  THPopupController.h
//  THShop
//
//  Created by JackyChain on 12/26/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THProduct.h"

#define POPUP_CART_SIZE CGRectMake(0, 0, 202.0f, 309.0f)

@protocol THPopupBookmarkDelegate <NSObject>

@optional
- (void)popupDismissWithCompleted;
- (void)popupDismissWithCompleted:(BOOL)isChange withValueChange:(NSInteger)quantity;

@end

@interface THPopupBookmarkController : UIViewController

- (void)popupBookmarkToAddProduct:(THProduct *)product;
- (void)popupBookmarkToUpdateProduct:(THProduct *)product;

@property (weak, nonatomic) id<THPopupBookmarkDelegate> delegate;

@end
