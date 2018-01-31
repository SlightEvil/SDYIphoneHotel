//
//  AppContext.m
//  SDYIphoneHotel
//
//  Created by admin on 2017/12/25.
//  Copyright © 2017年 SanDaoyi. All rights reserved.
//

#import "AppContext.h"
#import "UIImage+Cagegory.h"
#import "ZQBaseViewController.h"
#import "ZQBaseNavCon.h"

NSString *const tabbarTitleKey = @"title";
NSString *const tabbarImageNameKey = @"imageName";
NSString *const tabbarSelectImageKey = @"selectImageName";
NSString *const tabbarClassStringKey = @"classString";


@interface AppContext ()


@end


@implementation AppContext
single_implementation(AppContext)



#pragma mark - public medhtod

- (void)showLoginVC
{
    ZQBaseViewController *loginVC = [[NSClassFromString(@"ZQLoginVC") class] new];
    [[self topViewController] presentViewController:loginVC animated:YES completion:nil];
}


#pragma mark - HUD
- (void)showSuccess:(NSString *)success dismiss:(NSTimeInterval)time
{
    [SVProgressHUD showSuccessWithStatus:success];
    [SVProgressHUD dismissWithDelay:time ? time : 1.0];
}

- (void)showError:(NSString *)fail dismiss:(NSTimeInterval)time
{
    [SVProgressHUD showErrorWithStatus:fail];
    [SVProgressHUD dismissWithDelay:time ? time : 1.0];
}


#pragma mark - 私有的方法
/** 获取当前控制器对象 */

- (UIViewController *)topViewController
{
    UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    UIViewController *parent = rootVC;
    
    while ((parent = rootVC.presentedViewController) != nil ) {
        rootVC = parent;
    }
    
    while ([rootVC isKindOfClass:[UINavigationController class]]) {
        rootVC = [(UINavigationController *)rootVC topViewController];
    }
    return rootVC;
}

/** tabbar 的DataSource */

- (NSArray *)viewConArray
{
    return @[@{tabbarTitleKey:@"首页",tabbarImageNameKey:@"tabbar_home",tabbarSelectImageKey:@"tabbar_home_select",tabbarClassStringKey:@"ZQHomeVC"},
             @{tabbarTitleKey:@"分类",tabbarImageNameKey:@"tabbar_category",tabbarSelectImageKey:@"tabbar_category_select",tabbarClassStringKey:@"ZQProductCategoryVC"},
             @{tabbarTitleKey:@"购物车",tabbarImageNameKey:@"tabbar_shopCart",tabbarSelectImageKey:@"tabbar_shopCart_select",tabbarClassStringKey:@"ZQShoppingCartVC"},
             @{tabbarTitleKey:@"个人中心",tabbarImageNameKey:@"tabbar_account",tabbarSelectImageKey:@"tabbar_account_select",tabbarClassStringKey:@"ZQPersonalCenterVC"}];
}


#pragma mark - Getter and Setter


- (ZQNetWorkServices *)networkServices
{
    if (!_networkServices) {
        _networkServices = [[ZQNetWorkServices alloc]init];
    }
    return _networkServices;
}




@end




