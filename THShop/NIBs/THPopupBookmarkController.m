//
//  THPopupController.m
//  THShop
//
//  Created by JackyChain on 12/26/14.
//  Copyright (c) 2014 JackyChain. All rights reserved.
//

#import "THPopupBookmarkController.h"

#import "UIViewController+ENPopUp.h"

#import "UIColor+Custom.h"
#import "NSString+Additions.h"
#import "UIImageView+AFNetworking.h"
#import "THProductImages.h"
#import "THProductManager.h"
#import "SVProgressHUD.h"

#import "SlideNavigationController.h"

static NSString * const STORE_PRODUCT_BOOKMARK      =   @"store_product_bookmark";
static NSString * const STORE_PRODUCT_ID            =   @"store_product_id";
static NSString * const STORE_PRODUCT_NUMBER        =   @"store_product_number";


@interface THPopupBookmarkController ()

@property (strong, nonatomic) IBOutlet UIView *popupView;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UILabel *labelQuantity;
@property (weak, nonatomic) IBOutlet UIImageView *productImage;
@property (weak, nonatomic) IBOutlet UILabel *labelProductName;
@property (weak, nonatomic) IBOutlet UILabel *labelProductSku;
@property (weak, nonatomic) IBOutlet UILabel *labelProductPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelProductDetail;
@property (weak, nonatomic) IBOutlet UIImageView *productImageWrapper;
@property (weak, nonatomic) IBOutlet UIButton *addToCartButton;

@property (strong, nonatomic) THProduct *product;
@property (nonatomic) BOOL isChange;
@property (nonatomic) BOOL isUpdate;


@end


@implementation THPopupBookmarkController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
}

- (void)popupBookmarkToAddProduct:(THProduct *)product
{
    self.product = product;
    self.isChange = YES;
    self.isUpdate = NO;
}

- (void)popupBookmarkToUpdateProduct:(THProduct *)product
{
    self.product = product;
    self.isChange = NO;
    self.isUpdate = YES;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
    [SlideNavigationController sharedInstance].enableSwipeGesture = NO;
    [self loadBookmarked];
    [self loadDetailWithProduct];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SlideNavigationController sharedInstance].enableSwipeGesture = YES;
    
}

- (void)loadBookmarked
{
    if (!self.product) {
        
        [SVProgressHUD showErrorWithStatus:@"Error with product!" maskType:(SVProgressHUDMaskTypeGradient)];
        if (self.isUpdate) {
            [self.delegate popupDismissWithCompleted:self.isChange withValueChange:(int)self.stepper.value];
            
        } else {
            [self.delegate popupDismissWithCompleted];
            
        }
        
        return;
    }
    
    NSArray *bookmarkedProduct = [[THProductManager shareInstance] getAllBookmarkedProduct] ;
    
    for (NSDictionary *product in bookmarkedProduct) {

        if ([self.product.product_id isEqualToString:[product valueForKey:STORE_PRODUCT_ID]]) {
            
            self.stepper.value = [[product valueForKey:STORE_PRODUCT_NUMBER] intValue];
            self.labelQuantity.text = [NSString stringWithFormat:@"%d",(int)self.stepper.value];
        }
    }
    
}

- (void)loadDetailWithProduct
{
    
    if (!self.product) {
        
        [SVProgressHUD showErrorWithStatus:@"Error with product!" maskType:(SVProgressHUDMaskTypeGradient)];
        if (self.isUpdate) {
            [self.delegate popupDismissWithCompleted:self.isChange withValueChange:(int)self.stepper.value];
            
        } else {
            [self.delegate popupDismissWithCompleted];
            
        }
        
        return;
        
    }
    
    self.labelProductName.text = self.product.name;
    [self.labelProductName setFont:[UIFont fontWithName:@"Lato" size:17]];
    [self.labelProductName setTextColor:[UIColor titleColor]];
    
    self.labelProductSku.text = [NSString stringWithFormat:@"Product code: %@",self.product.product_code];
    
    self.labelProductPrice.text = [NSString getVNCurrencyFormatterWithNumber:@([self.product.price intValue])];
    
    self.labelProductDetail.text = self.product.detail;
    [self.productImage setImageWithURL:[NSURL URLWithString:[[self.product.images anyObject] small_url] ]];
    
    self.productImageWrapper.layer.borderWidth = 1;
    self.productImageWrapper.layer.borderColor = [UIColor titleColor].CGColor;
    
}

- (IBAction)steperValueChanged:(UIStepper *)sender
{
    
    double value = [sender value];
    self.labelQuantity.text = [NSString stringWithFormat:@"%d", (int)value];
    self.isChange = YES;
    
}

- (IBAction)addToCartPress:(UIButton *)sender {

    
    if (self.delegate) {
        
        if ([[THProductManager shareInstance] bookmarkProductWithProductID:self.product.product_id withQuantity:[self.labelQuantity.text intValue] ]) {
            
            if (!self.isUpdate) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_CHANGE_BOOKMARK_PRODUCT_COUNT object:self];
                
            }
        };
        
        if (self.isUpdate) {
            
            [SVProgressHUD showSuccessWithStatus:@"Update successful!" maskType:(SVProgressHUDMaskTypeGradient)];
            [self.delegate popupDismissWithCompleted:self.isChange withValueChange:(int)self.stepper.value];
            
        } else {
            
            [SVProgressHUD showSuccessWithStatus:@"Add to cart successful" maskType:(SVProgressHUDMaskTypeGradient)];
            [self.delegate popupDismissWithCompleted];
            
        }
    }
    
}


@end
