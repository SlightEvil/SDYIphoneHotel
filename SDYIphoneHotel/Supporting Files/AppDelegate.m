//
//  AppDelegate.m
//  SDYIphoneHotel
//
//  Created by admin on 2017/12/25.
//  Copyright © 2017年 SanDaoyi. All rights reserved.
//

#import "AppDelegate.h"
#import "ZQBaseNavCon.h"
#import "ZQBaseViewController.h"
#import "UIImage+Cagegory.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupTabbar];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
/** 设置方向 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}
/** 设置tabbar */
- (void)setupTabbar
{
    UITabBarController *tabbar = [[UITabBarController alloc] init];
    tabbar.tabBar.tintColor = kZQTabbarTintColor;
    tabbar.tabBar.barTintColor = kZQTabbarBarTintColor;
    tabbar.tabBar.translucent = NO;

    NSMutableArray *viewContArray = [NSMutableArray array];
    for (NSDictionary *dic in AppCT.viewConArray) {
        ZQBaseNavCon *nav = [self rootNavigationViewControlWithDic:dic];
        [viewContArray addObject:nav];
    }
    tabbar.viewControllers = viewContArray;
    
    self.window.rootViewController = tabbar;
    [self.window makeKeyAndVisible];
}
/** 返回一个NAV */
- (ZQBaseNavCon *)rootNavigationViewControlWithDic:(NSDictionary *)dic
{
    NSString *titleStr = dic[tabbarTitleKey];
    NSString *imageName = dic[tabbarImageNameKey];
    NSString *selectImageName = dic[tabbarSelectImageKey];
    NSString *className = dic[tabbarClassStringKey];
    ZQBaseViewController *vc = [[NSClassFromString(className) class] new];
    vc.tabBarItem.title = titleStr;
    vc.navigationItem.title = titleStr;
    vc.tabBarItem.image = [[UIImage sizeImageWithImage:[UIImage imageNamed:imageName] sizs:CGSizeMake(30, 30)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage sizeImageWithImage:[UIImage imageNamed:selectImageName] sizs:CGSizeMake(30, 30)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:kZQTabbarTintColor} forState:UIControlStateSelected];
    return [[ZQBaseNavCon alloc] initWithRootViewController:vc];
}


@end
