//
//  ZQOrderDetailView.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/20.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZQMyOrderListModel;
/**
 显示订单详情的View  
 */
@interface ZQOrderDetailView : UIView


/** 显示订单详情视图 */
- (void)showOrderDetailViewModel:(ZQMyOrderListModel *)orderModel;

/** 隐藏订单详情视图 */
- (void)hiddenOrderDetailView;

@end
