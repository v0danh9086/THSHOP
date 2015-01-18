//
//  THDetailsViewController.m
//  THShop
//
//  Created by JackyChain on 12/25/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THProductDetailsViewController.h"

#import "THProductDetailCollectionCell.h"
#import "SlideNavigationController.h"
#import "THCategory.h"
#import "THProductImagesManager.h"
#import "MHFacebookImageViewer.h"
#import "THProductCollectionCell.h"
#import "UIImageView+AFNetworking.h"
#import "THProductManager.h"
#import "UIView+Additions.h"
#import "SVProgressHUD.h"
#import "NSString+Additions.h"
#import "UILabel+Additions.h"

#import "THPopupBookmarkController.h"
#import "UIViewController+ENPopUp.h"


@interface THProductDetailsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, MHFacebookImageViewerDatasource, THPopupBookmarkDelegate>

@property (strong, nonatomic) NSArray *productImageArray;
@property (strong, nonatomic) NSMutableArray *productArr;

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productSKULabel;
@property (weak, nonatomic) IBOutlet UILabel *productDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *relatedProductLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *imagePageControl;
@property (weak, nonatomic) IBOutlet UICollectionView *productCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *relatedCollectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *seperatorBreakView;

@end

@implementation THProductDetailsViewController

#pragma mark - View controller lifecycle

- (void)viewDidLoad
{   
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self regCellForCollectionView];
    
    // Code for product detail collectionView
    [self loadProductDetail];
    [self getImagesFromProduct];
    
    // Code for related collectionView
    [self fillUpCollectionRelatedProductWithCategoryID:self.category_id];
    
}

#pragma mark - Collection view datasource


#pragma - Helper methods

- (void)regCellForCollectionView
{
    self.productCollectionView.delegate = self;
    self.productCollectionView.dataSource = self;
    
    self.relatedCollectionView.delegate = self;
    self.relatedCollectionView.dataSource = self;
    
    [self.productCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([THProductDetailCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([THProductDetailCollectionCell class]) ];
    
    [self.relatedCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([THProductCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([THProductCollectionCell class]) ];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.productCollectionView) {
        return self.productImageArray.count;
    }
    
    return self.productArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.productCollectionView) {

        THProductDetailCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([THProductDetailCollectionCell class]) forIndexPath:indexPath];
        
        [cell customProductsDetailCellWithProductImage:[self.productImageArray objectAtIndex:indexPath.item] ];
        
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
        [imageView setImageWithURL:[NSURL URLWithString:[[self.productImageArray objectAtIndex:indexPath.item] large_url]] ];
        [imageView setupImageViewerWithDatasource:self initialIndex:indexPath.row onOpen:nil onClose:nil];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = NO;
        
        return cell;
    }
    
    THProductCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([THProductCollectionCell class]) forIndexPath:indexPath];
    [cell customCellWithProduct:[self.productArr objectAtIndex:indexPath.item] ];
    
    return cell;
}

#pragma mark Detail product code place

- (void)loadProductDetail
{
    if (self.product) {
        
        self.title = [self.product name];
        [SlideNavigationController sharedInstance].title = self.title;
        
        [self.imagePageControl alignBelowView:self.productCollectionView offsetY:10 sameWidth:NO];
        self.productNameLabel.text = self.product.name;
        self.productPriceLabel.text = [NSString getVNCurrencyFormatterWithNumber:@([[self.product price] intValue]) ];;
        self.productSKULabel.text = [NSString stringWithFormat:@"Product code: %@",self.product.product_code];
        self.productDetailsLabel.text = [NSString stringWithFormat:@"Detail: %@",self.product.detail];
        [self.productDetailsLabel sizeToFitKeepWidth];
        [self.seperatorBreakView alignBelowView:self.productDetailsLabel offsetY:20 sameWidth:NO];
        [self.relatedProductLabel alignBelowView:self.seperatorBreakView offsetY:10 sameWidth:NO];
        [self.relatedCollectionView alignBelowView:self.relatedProductLabel offsetY:10 sameWidth:NO];
        [self.activityIndicator alignBelowView:self.relatedProductLabel offsetY:40 sameWidth:NO];
        
        
        self.contentScrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, CGRectGetMaxY([self.relatedCollectionView frame])) ;
        [self.contentScrollView setContentOffset:CGPointMake(0, -self.contentScrollView.contentInset.top) animated:YES];
    }
}

- (void)getImagesFromProduct
{
    if ([self.productImageArray count] > 0) {
        self.productImageArray = nil;
    }
    
    if (self.product) {
        
        [THProductImagesManager getImagesForProduct:self.product.product_id onSuccess:^(NSInteger statusCode, NSSet *productImageSet) {
            
            [self performSelectorOnMainThread:@selector(completedGetImagesFromProduct:) withObject:productImageSet waitUntilDone:NO];
            
        } failure:^(NSInteger statusCode, NSError *error) {
            // Handle error
            
            [SVProgressHUD showErrorWithStatus:@"Please check connection and try again"];
            NSLog(@"Error in THProductDetailsViewController with macro is getImagesFromProduct /n %@", error);
            
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.productCollectionView.frame.size.width;
    int page = floor((self.productCollectionView.contentOffset.x - pageWidth/2) / pageWidth) +1;
    self.imagePageControl.currentPage = page;
    
}

- (IBAction)showPopUp:(id)sender
{
    if ([[THProductManager shareInstance] isBookmarkedAlreadyWithProductID:self.product.product_id]) {
        [SVProgressHUD showSuccessWithStatus:@"Product already contain in your cart!" maskType:(SVProgressHUDMaskTypeGradient)];
        return;
    }

    THPopupBookmarkController *vc = [[THPopupBookmarkController alloc] initWithNibName:@"THPopupBookmarkController" bundle:nil];
    [vc popupBookmarkToAddProduct:self.product];
    vc.view.frame = POPUP_CART_SIZE;
    vc.delegate = self;
    
    [self presentPopUpViewController:vc];
    
}

#pragma mark Related collectionView code place

- (void)fillUpCollectionRelatedProductWithCategoryID:(NSString *)category_id
{
    if ([self.productArr count] >0) {
        self.productArr = nil;
    }
    
    [[THProductManager shareInstance] getListProductWithCategoryID:category_id
                                                    onSuccessBlock:^(NSInteger statusCode, NSArray *productArray) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [self completedFillUpCollectionRelatedProductWithCategoryID:productArray];
                                                        });
                                                        
                                                        
                                                    } failure:^(NSInteger statusCode, NSError *error) {
                                                        //Handler error
                                                        NSLog(@"%@", error);
                                                    }];
    
}

- (void)showCollectionView
{
    if (self.productArr.count) {
        
        [self.relatedCollectionView reloadData];
        self.relatedCollectionView.hidden = NO;
        [self.activityIndicator stopAnimating];
        
        
        if (self.productArr.count <3) {
            [self.relatedCollectionView setHeight:253];
        }
        
    } else {
        [self.relatedCollectionView setHeight:0];
    }
    [SVProgressHUD dismiss];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.relatedCollectionView) {
        if (indexPath.row >= 0) {
            self.product = self.productArr[indexPath.row];
            
            [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
            
            [self loadProductDetail];
            [self getImagesFromProduct];
            
            // Code for related collectionView
            [self fillUpCollectionRelatedProductWithCategoryID:self.category_id];
            
            [self.productCollectionView reloadData];
            [self.relatedCollectionView reloadData];
            
        }
    }
}


#pragma mark - MHFacebook Image Viewer delegate

- (NSInteger) numberImagesForImageViewer:(MHFacebookImageViewer*) imageViewer
{
    return self.productImageArray.count;
}

- (NSURL*) imageURLAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer*) imageViewer
{
    
    NSURL *url = [NSURL URLWithString:[[self.productImageArray objectAtIndex:index] large_url] ];
    return url;
    
}

- (UIImage*) imageDefaultAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer*) imageViewer
{
    return nil;
}

#pragma mark THPopupBookmark Delegate

- (void)popupDismissWithCompleted
{
    [self dismissPopUpViewController];
}

- (void)completedGetImagesFromProduct:(NSSet *)productImageSet
{
    //
    self.productImageArray = [productImageSet allObjects];
    
    [self.imagePageControl setNumberOfPages:self.productImageArray.count];
    
    self.contentScrollView.scrollEnabled = YES;
    [self.productCollectionView reloadData];
    
    //[self.activityIndicator stopAnimating];
    [SVProgressHUD dismiss];
}

- (void)completedFillUpCollectionRelatedProductWithCategoryID:(NSArray *)productArray
{
    //Set to productArr
    self.productArr = [[NSMutableArray alloc] initWithArray:[productArray copy]];
    int countProduct = self.productArr.count;
    for (int i=0; i<countProduct; i++) {
        if ([[productArray[i] product_id] isEqualToString:self.product.product_id]) {
            [self.productArr removeObjectAtIndex:i];
        }
    }
    
    [self showCollectionView];
}

@end
