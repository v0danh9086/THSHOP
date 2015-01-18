//
//  THBaseViewController.m
//  THShop
//
//  Created by JackyChain on 12/22/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THBaseViewController.h"

#import "SlideNavigationController.h"
#import "UIColor+Custom.h"
#import "Crittercism.h"
#import "JKLeftMenuViewController.h"
#import "THProductManager.h"

@interface THBaseViewController ()<SlideNavigationControllerDelegate>

@end

@implementation THBaseViewController

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
    // Do any additional setup after loading the view.
    self.title = TH_SHOP_NAME;
    [self trackCrittercismBreadCrumb:__LINE__];
    
    [self addNavigationItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addNavigationItem)
                                                 name:NOTIF_CHANGE_BOOKMARK_PRODUCT_COUNT
                                               object:nil];
  
}

- (void)viewDidAppear:(BOOL)animated
{
    // Config for google analytics
    if (self.title) {
        self.screenName = self.title;
    }
    
    [super viewDidAppear:animated];
    
}
#pragma mark - Helper methods

- (void)addNavigationItem
{
    NSDictionary *textTitleOptions = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor titleColor], UITextAttributeTextColor, [UIColor whiteColor], UITextAttributeTextShadowColor, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:textTitleOptions];
    
    // Nav left button
    UIButton *leftButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    
    if (self == [[self.navigationController viewControllers] objectAtIndex:0]) {
        
        [leftButton setImage:[UIImage imageNamed:@"left-nav-button"] forState:(UIControlStateNormal)];
        
    } else {
        
        [leftButton setImage:[UIImage imageNamed:@"nav-back-btn-bg"] forState:(UIControlStateNormal)];
        [leftButton addTarget:self action:@selector(onBtnBack) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    leftButton.frame = CGRectMake(0, 0, 35, 35);
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
     self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    // Nav right button
    UILabel *labelCount = [[UILabel alloc] initWithFrame:CGRectMake(2, 5, 20, 20)];
    [labelCount setFont:[UIFont fontWithName:@"Lato" size:10] ];
    [labelCount setTextColor:[UIColor titleColor] ];
    [labelCount setTextAlignment:(NSTextAlignmentCenter)];
    
#warning input product bookmark in here
    labelCount.text = [NSString stringWithFormat:@"%d", [THProductManager getAllBookmarkedProductCount]];
    
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
	[button setImage:[UIImage imageNamed:@"bookmark_list"] forState:UIControlStateNormal];
	[button addTarget:[SlideNavigationController sharedInstance] action:@selector(toggleRightMenu) forControlEvents:UIControlEventTouchUpInside];
    [button addSubview:labelCount];
    
	UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
	[SlideNavigationController sharedInstance].rightBarButtonItem = rightBarButtonItem;
}

- (void)onBtnBack
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Helper methods

- (void)trackCrittercismBreadCrumb:(NSUInteger)lineNumber
{
    NSString *breadcrumb = [NSString stringWithFormat:@"%@:%d", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], lineNumber];
    [Crittercism leaveBreadcrumb:breadcrumb];
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return YES;
}

@end
