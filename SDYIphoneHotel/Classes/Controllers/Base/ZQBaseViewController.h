//
//  ZQBaseViewController.h
//  SDYIphoneHotel
//
//  Created by admin on 2017/12/25.
//  Copyright © 2017年 SanDaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "UIView+Category.h"


typedef void(^CompleBlock)(void);

@interface ZQBaseViewController : UIViewController



/**
 系统的弹窗实现，点击确定 实现block

 @param title title
 @param message message
 @param compleClick 确定事件
 */
- (void)alertTitle:(NSString *)title message:(id)message comple:(CompleBlock)compleClick;

@end
