//
//  THProducsViewController.m
//  THShop
//
//  Created by JackyChain on 12/23/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THProducsViewController.h"

#import "THProductManager.h"
#import "SVProgressHUD.h"
#import "THProductCollectionCell.h"
#import "THProductImages.h"
#import "SlideNavigationController.h"
#import "THProductDetailsViewController.h"


static CGFloat const IOS_7_CONTENT_INSET = 60;
static CGFloat const IOS_6_ORIGIN_X = 8;
static CGFloat const IOS_6_ORIGIN_Y = 44;

@interface THProducsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewProducts;

@property (strong, nonatomic) NSMutableArray *products;
@property (strong, nonatomic) UIRefreshControl *requestControl;
@property (weak, nonatomic) IBOutlet UIImageView *noImageCover;

@end

@implementation THProducsViewController
@synthesize category_id = _category_id;

- (NSMutableArray *)products
{
    if (!_products) {
        _products = [[NSMutableArray alloc] init];
    }
    return _products;
}

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
    
    self.title = DEFAULT_NAVIGATION_TITLE;
    [self.navigationController setTitle:DEFAULT_NAVIGATION_TITLE];
    
    if (![self.lblTitle isEqualToString:@""]) {
        self.title = self.lblTitle;
    }
    
    NSLog(@"%@", self.category_id);
    
    [SVProgressHUD showWithStatus:@"Loading..."];
    
    self.requestControl = [[UIRefreshControl alloc] init];
    [self.requestControl addTarget:self action:@selector(refresh) forControlEvents:(UIControlEventValueChanged)];
    [self.collectionViewProducts addSubview:self.requestControl];
    
    [self fillUpTableProduct];
    
    
    [self regCellForCollectionCell];
    
    self.collectionViewProducts.dataSource = self;
    self.collectionViewProducts.delegate = self;
    
}

// Helpers
- (void)regCellForCollectionCell
{
    [self.collectionViewProducts registerNib:[UINib nibWithNibName:NSStringFromClass([THProductCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([THProductCollectionCell class])];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self.collectionViewProducts setContentInset:UIEdgeInsetsMake(IOS_7_CONTENT_INSET, 0, 0, 0)];
    }
    else{
        self.collectionViewProducts.frame = CGRectMake(IOS_6_ORIGIN_X, IOS_6_ORIGIN_Y, CGRectGetWidth(self.collectionViewProducts.frame), CGRectGetHeight(self.collectionViewProducts.frame) - IOS_6_ORIGIN_Y);
    }
}

- (void)fillUpTableProduct
{
    if ([self.category_id isEqualToString:@"21"]) {
        return;
    }
    
    [[THProductManager shareInstance] getListProductWithCategoryID:self.category_id onSuccessBlock:^(NSInteger statusCode, NSArray *productArray) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.products = [[NSMutableArray alloc] initWithArray:[productArray copy] ];
            
            for (THProduct *product in productArray) {
                if (![[[product images] anyObject] medium_url]) {
                    [self.products removeObject:product];
                }
            }
            
            if (!self.products.count) {
                self.collectionViewProducts.hidden = YES;
                self.noImageCover.hidden = NO;
            }
            
            [self.collectionViewProducts reloadData];
            [SVProgressHUD dismiss];
        });
        
        
    } failure:^(NSInteger statusCode, NSError *error) {
        
        //Handler Error
        [SVProgressHUD showErrorWithStatus:@"Please check connection and try again"];
        [[SlideNavigationController sharedInstance] popToRootViewControllerAnimated:YES];
    }];
}

- (void)refresh
{
    [SVProgressHUD showWithStatus:@"Loading..."];
    [self fillUpTableProduct];
    [self.requestControl endRefreshing];
}

#pragma mark - Collection view datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.products.count !=0) {
        self.collectionViewProducts.hidden = NO;
    }
    return self.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    THProductCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([THProductCollectionCell class]) forIndexPath:indexPath];
    [cell customCellWithProduct:[self.products objectAtIndex:indexPath.row] ];
    
    return cell;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    THProductDetailsViewController *detailViewController = [[THProductDetailsViewController alloc] init];
    detailViewController.product = self.products[indexPath.row];
    detailViewController.category_id = self.category_id;
    
    [[SlideNavigationController sharedInstance] pushViewController:detailViewController animated:YES];
}

@end
