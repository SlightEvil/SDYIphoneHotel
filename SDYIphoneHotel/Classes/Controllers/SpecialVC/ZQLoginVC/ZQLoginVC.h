//
//  ZQLoginVC.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/11.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQBaseViewController.h"

typedef NS_ENUM(NSInteger,ZQLoginVCType) {
    ZQLoginVCTypeLogin = 0,
    ZQLoginVCTypeRegister = 1,
};

@interface ZQLoginVC : ZQBaseViewController

/** 选择登录界面的类型  登录ZQLoginVCTypeLogin  注册ZQLoginVCTypeLogin */
@property (nonatomic) ZQLoginVCType type;


@end
