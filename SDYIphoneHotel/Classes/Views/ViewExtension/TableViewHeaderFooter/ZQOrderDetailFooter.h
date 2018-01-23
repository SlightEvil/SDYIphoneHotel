//
//  ZQOrderDetailFooter.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/20.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZQMyOrderListModel;

/**
 订单详情的footer
 */
@interface ZQOrderDetailFooter : UITableViewHeaderFooterView

///** 订单的数据 */
//@property (nonatomic) ZQMyOrderListModel *orderModel;

/** 订单总价 */
@property (nonatomic, copy) NSString *totalPriceStr;


@end
