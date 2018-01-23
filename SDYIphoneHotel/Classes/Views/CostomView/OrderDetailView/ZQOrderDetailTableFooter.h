//
//  ZQOrderDetailTableFooter.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/20.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ZQMyOrderListModel;

/**
 订单详情 的UItableview 的tableFooter
 */
@interface ZQOrderDetailTableFooter : UIView

/** 订单DataSource */
@property (nonatomic) ZQMyOrderListModel *orderModel;


/** 初始化方法 */
- (instancetype)initWithFrame:(CGRect)frame;

@end
