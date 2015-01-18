//
//  JKLeftMenuViewController.m
//  JKShop
//
//  Created by admin on 11/30/13.
//  Copyright (c) 2013 Nguyễn Bá Toàn. All rights reserved.
//

#import "JKLeftMenuViewController.h"

#import "THBaseViewController.h"

#import "THSlideLeftMenuHeaderViewCell.h"
#import "THSlideLeftMenuViewCell.h"

#import "SlideNavigationController.h"
#import "THProducsViewController.h"
#import "THCategoryManager.h"




@interface JKLeftMenuViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
SlideNavigationControllerDelegate
>

@property (assign, nonatomic) BOOL                                isSearching;
@property (strong, nonatomic) NSMutableArray                    * arrMenu;
@property (strong, nonatomic) NSMutableArray                    * filteredList;
@property (strong, nonatomic) NSArray                           * arrSection;
@property (strong, nonatomic) NSArray                           * arrIconSection;
@property (strong, nonatomic) NSArray                           * arrSubMenuSectionOne;
@property (weak, nonatomic) IBOutlet UITableView                * menuTableView;
@property (weak, nonatomic) IBOutlet UIView                     * searchBarView;
@property (weak, nonatomic) IBOutlet UIView                     * profileView;
@property (weak, nonatomic) IBOutlet UILabel                    * userName;
@property (weak, nonatomic) IBOutlet UIView                     * loginView;

@end

@implementation JKLeftMenuViewController

#pragma mark - View controller lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[THCategoryManager shareInstance] getMenulistOncomplete:^(NSArray *menu) {
        self.arrMenu = [menu mutableCopy];
    } orFailure:nil];
    
    self.arrSubMenuSectionOne = @[@"JK Shop", @"Contact us", @"Facebook Fanpage", @"Website"];
    self.arrSection = @[@"Featured", @"Category", @"Gift"];
    self.arrIconSection = @[@"star.png",@"category.png",@"gift.png"];
    
    [self regForTableViewLeftMenu];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.menuTableView setContentOffset:CGPointMake(0, 44)];
}

#pragma mark - SlideLeftMenuTableView datasource

- (void)regForTableViewLeftMenu
{
    
    [self.menuTableView registerNib:[UINib nibWithNibName:NSStringFromClass([THSlideLeftMenuHeaderViewCell class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([THSlideLeftMenuHeaderViewCell class])];
    
    [self.menuTableView registerNib:[UINib nibWithNibName:NSStringFromClass([THSlideLeftMenuViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([THSlideLeftMenuViewCell class])];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.arrSection.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0: {
            return self.arrSubMenuSectionOne.count;
        }
        case 1: {
            if (self.arrMenu.count) {
                return self.arrMenu.count;
            }
        }
        default:
            return 1;
    }
    
}

#pragma TableViewCell

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [THSlideLeftMenuViewCell getHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    THSlideLeftMenuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THSlideLeftMenuViewCell class])];
    switch (indexPath.section) {
        case 0: {
            
            NSString *title = [self.arrSubMenuSectionOne objectAtIndex:indexPath.row];
            NSDictionary *data = @{MENU_TITLE: title};
            
            [cell configWithData:data];
            return cell;
        }
        case 2: {
            
            NSDictionary *data = @{MENU_TITLE : @"Get lucky gift!"};
            [cell configWithData:data];
            
            return cell;
        }
        default: {
            
            if (self.arrMenu.count) {
                
                THCategory *category = [self.arrMenu objectAtIndex:indexPath.row];
                [cell customCategoryCellWithCategory:category];
                return cell;
            }
            
            UITableViewCell *refreshCell = [[UITableViewCell alloc] init];
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            
            [button addTarget:self action:@selector(refreshButtonPressed) forControlEvents:(UIControlEventTouchUpInside)];
            [button setTitle:@"Refresh Menu" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor grayColor]];
            button.frame = CGRectMake(30, 7, 215, 27);
            
            [refreshCell addSubview:button];
            return refreshCell;
            
        }
    }
    
    
    return cell;
}

#pragma Header

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [THSlideLeftMenuHeaderViewCell getHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    THSlideLeftMenuHeaderViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([THSlideLeftMenuHeaderViewCell class])];
    
    if (!cell) {
        cell = [[THSlideLeftMenuHeaderViewCell alloc] init];
    }
    
    [cell configIconWithImageURL:[self.arrIconSection objectAtIndex:section] ];
    [cell configTitleNameWithString:[self.arrSection objectAtIndex:section] ];
    
    return cell;
}

#pragma mark SlideLeftMenuTableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0: {
            
            if (indexPath.row == 0) {
                
                [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
                return;
                
            } else if (indexPath.row == 1) {
                
                THBaseViewController *menu2 = [[THBaseViewController alloc] init];
                CGRect frame = self.view.frame;
                
                UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
                webView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                
                [menu2.view addSubview:webView];
                
                NSString *path = @"https://www.facebook.com/notes/jk-shop/c%C3%A1ch-th%E1%BB%A9c-mua-h%C3%A0ng/244994125626975";
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
                [webView loadRequest:request];
                
                menu2.title = @"How to order";
                
                [[SlideNavigationController sharedInstance] setViewControllers:[NSArray arrayWithObject:menu2] animated:YES];
                [[SlideNavigationController sharedInstance] closeMenuWithCompletion:nil];
                
                return;
            } else if (indexPath.row == 2) {
                
                NSURL *facebookURL = [NSURL URLWithString:@"fb://profile/217999154993139"];
                
                if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
                    [[UIApplication sharedApplication] openURL:facebookURL];
                    return;
                }
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://facebook.com/jkshop.vn"]];
                
                return;
                
            } else if (indexPath.row == 3) {
                
                [[UIApplication sharedApplication] openURL:([NSURL URLWithString:@"http://jkshop.vn"])];
                
                return;
            }
            
        }
        case 1: {
            
            THProducsViewController *vc = [[THProducsViewController alloc] init];
            
            vc.category_id = [[self.arrMenu objectAtIndex:indexPath.row] category_id];
            vc.lblTitle = [[self.arrMenu objectAtIndex:indexPath.row] name];
            
            [[SlideNavigationController sharedInstance] setViewControllers:[NSArray arrayWithObject:vc] animated:YES];
            [[SlideNavigationController sharedInstance] closeMenuWithCompletion:nil];
            
            
            return;
        }
        default:
//            [centralNavVC setViewControllers:[NSArray arrayWithObject:[[JKGiftViewController alloc] init]] animated:YES];
//            [deckViewController toggleLeftViewAnimated:YES];
            return;
    }
    
    
//    THProducsViewController *productList = [[THProducsViewController alloc] init];
//    productList.category_id = @"76";
//    
//    NSLog(@"%@", productList.category_id);
//    
//    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:productList
//                                                             withSlideOutAnimation:YES
//                                                                     andCompletion:nil];
}

#pragma mark HELPERS

- (void)refreshButtonPressed{
    [self loadMenuCategory];
}


- (void)loadMenuCategory
{
    [[THCategoryManager shareInstance] getMenulistOncomplete:^(NSArray *menu) {
        //
        self.arrMenu = [menu mutableCopy];
        [self.menuTableView reloadData];
        
    } orFailure:^(NSError *error) {
        
        DLog(@"Error when load menu");
    
    }];
}

@end
