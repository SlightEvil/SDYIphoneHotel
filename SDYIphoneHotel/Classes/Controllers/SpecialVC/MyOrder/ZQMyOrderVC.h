//
//  ZQMyOrderVC.h
//  SDYIphoneHotel
//
//  Created by admin on 2017/12/25.
//  Copyright © 2017年 SanDaoyi. All rights reserved.
//


/**
 订单类型 显示类型

 - ZQMyOrderSelectTYpeCommit: 已提交
 - ZQMyOrderSelectTypeSending: 待配送   已删除
 - ZQMyOrderSelectTypeReceive: 待收货
 - ZQMyOrderSelectTypeComplete: 已完成
 - ZQMyOrderSelectTypeAllOrder: 全部
 */
typedef NS_ENUM(NSInteger,ZQMyOrderSelectType) {
    ZQMyOrderSelectTYpeCommit   = 0,
//    ZQMyOrderSelectTypeSending  = 1 << 0,
    ZQMyOrderSelectTypeReceive  = 1 << 0,
    ZQMyOrderSelectTypeComplete = 1 << 1,
    ZQMyOrderSelectTypeAllOrder = 1 << 2
};


#import "ZQBaseViewController.h"


/** 我的订单 */
@interface ZQMyOrderVC : ZQBaseViewController


/** 订单显示类型  默认为allOrder   取消待配送状态 */
@property (nonatomic) ZQMyOrderSelectType type;



@end
