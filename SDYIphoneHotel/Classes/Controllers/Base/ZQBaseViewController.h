//
//  ZQBaseViewController.h
//  SDYIphoneHotel
//
//  Created by admin on 2017/12/25.
//  Copyright © 2017年 SanDaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import <MJRefresh/MJRefresh.h>
#import "UIView+Category.h"


typedef void(^CompleBlock)(void);

@interface ZQBaseViewController : UIViewController

/** 下拉刷新普通状态的动画图片 */
@property (nonatomic) NSArray *idleImageAry;
/** 设置即将刷新状态的动画图片（一松开就会刷新的状态)  设置正在刷新状态的动画图片 */
@property (nonatomic) NSArray *pullImageAry;

///** 设置UI  */
//- (void)setupUI;
///**布局使用自动布局 */
//- (void)layoutWithAuto;
///** 布局使用frame */
//- (void)layoutWithFrame;


/**
 系统的弹窗实现，点击确定 实现block

 @param title title
 @param message message
 @param compleClick 确定事件
 */
- (void)alertTitle:(NSString *)title message:(id)message comple:(CompleBlock)compleClick;

@end
