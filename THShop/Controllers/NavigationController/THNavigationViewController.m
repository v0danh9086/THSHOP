//
//  THNavigationViewController.m
//  THShop
//
//  Created by JackyChain on 12/22/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THNavigationViewController.h"

#import "JKLeftMenuViewController.h"
#import "THHomeViewController.h"
#import "THBookmarkViewController.h"

#import "SlideNavigationContorllerAnimatorSlideAndFade.h"

@interface THNavigationViewController ()

@end

@implementation THNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self generateControllerStack];
    }
    return self;
}

- (instancetype)init
{
    //id a = [[THHomeViewController alloc] init];
    self = [super initWithRootViewController:[[THHomeViewController alloc] init]];
    if (self) {
        [self generateControllerStack];
    }
    
    return self;
}

- (void)generateControllerStack
{
    if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
    
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:THSHOP_NAVIGATION_BG] forBarMetrics:(UIBarMetricsDefault)];
        [self.navigationBar setTranslucent:NO];
    }
    
    JKLeftMenuViewController *leftNavController = [[JKLeftMenuViewController alloc] init];
    self.leftMenu = leftNavController;
    
    THBookmarkViewController *rightNavController = [[THBookmarkViewController alloc] init];
    self.rightMenu = rightNavController;

    self.portraitSlideOffset = 20;
    self.enableShadow = YES;
    self.menuRevealAnimator = [[SlideNavigationContorllerAnimatorSlideAndFade alloc] initWithMaximumFadeAlpha:.8 fadeColor:[UIColor blackColor] andSlideMovement:100];
}

@end
