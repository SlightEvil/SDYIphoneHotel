//
//  AppContext.h
//  SDYIphoneHotel
//
//  Created by admin on 2017/12/25.
//  Copyright © 2017年 SanDaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZQLoginUser.h"
#import "ZQNetWorkServices.h"


FOUNDATION_EXPORT NSString *const tabbarTitleKey;
FOUNDATION_EXPORT NSString *const tabbarImageNameKey;
FOUNDATION_EXPORT NSString *const tabbarSelectImageKey;
FOUNDATION_EXPORT NSString *const tabbarClassStringKey;


#define AppCT [AppContext sharedAppContext]

@interface AppContext : NSObject
single_interface(AppContext)


/** 登录用户信息 */
@property (nonatomic) ZQLoginUser *loginUser;

/** 网络请求 GET POST */
@property (nonatomic) ZQNetWorkServices *networkServices;


/** 判断用户的登录状态  set用userLogin get 用isUserLogin */
@property (nonatomic, assign, getter = isUserLogin) BOOL userLogin;

/** tabbar view数据 */
@property (nonatomic) NSArray *viewConArray;





/** 进入登录界面 */
- (void)showLoginVC;

#pragma mark - 显示HUD

/** 显示成功的HUD 设置时间() 默认1.0 */
- (void)showSuccess:(NSString *)success  dismiss:(NSTimeInterval)time;
/** 显示错误 的HUD 设置时间 默认1.0 */
- (void)showError:(NSString *)fail  dismiss:(NSTimeInterval)time;





@end
