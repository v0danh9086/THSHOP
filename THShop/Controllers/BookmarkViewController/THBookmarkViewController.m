//
//  THBookmarkViewController.m
//  THShop
//
//  Created by JackyChain on 12/24/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THBookmarkViewController.h"

#import "THBookmarkViewCell.h"
#import "THProductManager.h"
#import "THPopupBookmarkController.h"
#import "UIViewController+ENPopUp.h"

#import "THBookmarkViewCell.h"
#import "THBookmarkHeaderViewCell.h"
#import "NSString+Additions.h"
#import "SWTableViewCell.h"
#import "SVProgressHUD.h"
#import "SCLAlertView.h"

#import "THProduct.h"
#import "SlideNavigationController.h"

//NSString * const SlideNavigationControllerDidOpen = @"SlideNavigationControllerDidOpen";

@interface THBookmarkViewController () <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate, THPopupBookmarkDelegate>

@property (weak, nonatomic) IBOutlet UITableView *bookmarkTableView;
@property (strong, nonatomic) NSMutableArray *productBookmarked;
@property (strong, nonatomic) NSMutableArray *products;
@property (nonatomic) BOOL isLoadDone;
@property (strong, nonatomic) NSIndexPath *currentIndexPath;

@end

@implementation THBookmarkViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self regCellForTableView];
    [self loadAllBookmarkData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadAllBookmarkData)
                                                 name:NOTIF_CHANGE_BOOKMARK_PRODUCT_COUNT
                                               object:nil];
    
}

- (void)loadAllBookmarkData
{
    self.isLoadDone = NO;
    [SVProgressHUD showWithStatus:@"Loading" maskType:(SVProgressHUDMaskTypeGradient)];

    self.productBookmarked = [[THProductManager shareInstance] getAllBookmarkedProduct];
    if (![self.productBookmarked count]) {
        
        [SVProgressHUD showErrorWithStatus:@"List current Empty!" maskType:(SVProgressHUDMaskTypeGradient)];
        
    } else {
        
        [self loadAllBookmarkedProducts];
    }
    
}

- (void)regCellForTableView
{
    self.bookmarkTableView.dataSource = self;
    self.bookmarkTableView.delegate = self;
    
    [self.bookmarkTableView registerNib:[UINib nibWithNibName:NSStringFromClass([THBookmarkHeaderViewCell class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([THBookmarkHeaderViewCell class]) ];
    
    [self.bookmarkTableView registerNib:[UINib nibWithNibName:NSStringFromClass([THBookmarkViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([THBookmarkViewCell class]) ];
    
}

#pragma mark UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isLoadDone) {
        return self.products.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isLoadDone) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [THBookmarkHeaderViewCell getHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [THBookmarkViewCell getHeigh];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    THBookmarkHeaderViewCell *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([THBookmarkHeaderViewCell class])];
    
    [header changeNumberOfBookmarkProduct:self.products.count];
    header.totalPriceLabel.text = [NSString getVNCurrencyFormatterWithNumber:@([self getTotalPrice])];

    if (self.isLoadDone) {
        
        [SVProgressHUD dismiss];
    }
    
    return header;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    THBookmarkViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THBookmarkViewCell class]) forIndexPath:indexPath];
    
    THProduct *product = self.products[indexPath.row];
    int quantity = [[self.productBookmarked[indexPath.row] valueForKey:STORE_PRODUCT_NUMBER] intValue];
    
    [cell configWithDictionary:product andQuantity:quantity];
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    return cell;
}

#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Button delete all action

- (IBAction)buttonDeleteAllPressed:(UIButton *)sender {
    
    if (![THProductManager getAllBookmarkedProductCount]) {
        [SVProgressHUD showErrorWithStatus:@"List current Empty!"];
        return;
    }
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    [alert addButton:@"Delete All" actionBlock:^{
        
        if ([THProductManager removeAllBookmarked]) {
            
            [self.products removeAllObjects];
            [self.bookmarkTableView deleteRowsAtIndexPaths:[self.bookmarkTableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [self updateHeaderBookmarkTableView];
            [SVProgressHUD showErrorWithStatus:@"List current Empty!"];
            
        }
    }];
    
    [alert showWarning:self title:@"Warning delete all!" subTitle:@"Really want to remove all products in your cart?" closeButtonTitle:@"Cancel" duration:0.0f];
}

#pragma mark Swipeable Cell Action

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    self.currentIndexPath = [self.bookmarkTableView indexPathForCell:cell];
    int row = self.currentIndexPath.row;
    
    if (index == 0) {
        
        THPopupBookmarkController *vc = [[THPopupBookmarkController alloc] initWithNibName:@"THPopupBookmarkController" bundle:nil];
        
        THProduct *product = self.products[row];
        if (product) {
            [vc popupBookmarkToUpdateProduct:product];
            vc.view.frame = POPUP_CART_SIZE;
            vc.delegate = self;
            
            [self presentPopUpViewController:vc];

        }
    } else if (index == 1){
        
        NSString *product_id = [self.productBookmarked[row] valueForKey:STORE_PRODUCT_ID];
        
        if ([[THProductManager shareInstance] removeBookmarkProductWithProductID:product_id]) {
            
            [self.products removeObjectAtIndex:row];
            [self.bookmarkTableView deleteRowsAtIndexPaths:@[self.currentIndexPath]
                                  withRowAnimation:UITableViewRowAnimationLeft];
            
            [self updateHeaderBookmarkTableView];

        }
        
    }
}

#pragma mark PopupBookmark Delegate

- (void)popupDismissWithCompleted:(BOOL)isChange withValueChange:(NSInteger)quantity
{
    
    [self dismissPopUpViewController];
    
    if (isChange && self.isLoadDone) {
        
        self.productBookmarked = [[THProductManager shareInstance] getAllBookmarkedProduct];
        
        THBookmarkViewCell *currentCell = (THBookmarkViewCell *)[self.bookmarkTableView cellForRowAtIndexPath:self.currentIndexPath];
        THProduct *product = self.products[self.currentIndexPath.row];
        int quantity = [[self.productBookmarked[self.currentIndexPath.row] valueForKey:STORE_PRODUCT_NUMBER] intValue];
        [currentCell configWithDictionary:product andQuantity:quantity];
        
        [self updateHeaderBookmarkTableView];
        
    }
}

#pragma mark HELPERS

- (void)updateHeaderBookmarkTableView
{
    self.productBookmarked = [[THProductManager shareInstance] getAllBookmarkedProduct];
    
    THBookmarkHeaderViewCell *header = (THBookmarkHeaderViewCell *)[self.bookmarkTableView headerViewForSection:0];
    [header changeNumberOfBookmarkProduct:self.products.count];
    header.totalPriceLabel.text = [NSString getVNCurrencyFormatterWithNumber:@([self getTotalPrice])];
}

- (void)loadAllBookmarkedProducts
{
    
    self.products = [[NSMutableArray alloc] init];
    [THProductManager getListProductWithArrayProductID:nil
                                        onSuccessBlock:^(NSMutableArray *products) {
                                            
                                            if ([products count] == [self.productBookmarked count]) {
                                                self.isLoadDone = YES;
                                            }
                                            
                                            if (self.isLoadDone) {
                                                
                                                self.products = products;
                                                
                                                if ([self performSelector:@selector(sortWhenDoneLoadProduct)]) {
                                                    [self.bookmarkTableView reloadData];
                                                };
                                                
                                            }
                                        }];
    
}

- (NSInteger)getTotalPrice
{
    long sum = 0;
    for (int i = 0; i < self.products.count; i++) {
        
        int price = [[self.products[i] price] intValue];
        int quantity = [[self.productBookmarked[i] valueForKey:STORE_PRODUCT_NUMBER] intValue];
        
        sum = sum + (price * quantity);
    }
    
    return sum;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightButtons = [[NSMutableArray alloc] init];
    
    [rightButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0] title:@"More"];
    [rightButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:1.0f]
                                         title:@"Delete"];;
    
    return  rightButtons;
}

- (BOOL)sortWhenDoneLoadProduct
{
    if (self.isLoadDone) {
        
        for (int i = 0; i< self.products.count; i++) {
            if (![[self.products[i] product_id] isEqualToString:[self.productBookmarked[i] valueForKey:STORE_PRODUCT_ID]]) {
                
                THProduct *value = [self.products[i] copy];
                for (int j = i+1; j<self.products.count; j++) {
                    
                    if ([[self.products[j] product_id] isEqualToString:[self.productBookmarked[i] valueForKey:STORE_PRODUCT_ID]])
                    {
                        [self.products replaceObjectAtIndex:i withObject:self.products[j] ];
                        [self.products replaceObjectAtIndex:j withObject:value];
                    }
                }
            }
        }
        
        return YES;
    }
    
    return NO;
}

@end
