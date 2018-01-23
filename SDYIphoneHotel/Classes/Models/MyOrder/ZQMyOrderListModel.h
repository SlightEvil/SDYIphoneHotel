//
//  ZQMyOrderListModel.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/10.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>


/**
 订单列表
 */
@interface ZQMyOrderListModel : NSObject

/** 订单id */
@property (nonatomic, copy) NSString *order_id;     //
/** 供应商  */
@property (nonatomic, copy) NSString *shop_name;        //
/** 供应商电话 */
@property (nonatomic, copy) NSString *shop_phone;       //
/** 用户id */
@property (nonatomic, copy) NSString *user_id;      //
/** 用户name */
@property (nonatomic, copy) NSString *user_name;        //
/** 订单号 */
@property (nonatomic, copy) NSString *order_no;         //
/** 创建时间 */
@property (nonatomic, copy) NSString *created_at;       //
/** 预订单总价 */
@property (nonatomic, copy) NSString *price;        //
/** 配送单总价 */
@property (nonatomic, copy) NSString *post_price;
/** 订单状态 */
@property (nonatomic, copy) NSString *status;           //
/** 备注 */
@property (nonatomic, copy) NSString *content;          //

/** 预订单数组 */
@property (nonatomic) NSMutableArray *details;          //
/** 配送订单数组 */
@property (nonatomic) NSMutableArray *post_details;     //


@end

/** 订单列表 预订单和配送订单 */
@interface ZQMyOrderListDetailModle : NSObject

/** 详情id  更新订单的时候需要 */
@property (nonatomic) NSString *detail_id;
/** 订单id */
@property (nonatomic) NSString *order_id;
/** 商品名称 */
@property (nonatomic) NSString *product_name;
/** 单价 */
@property (nonatomic) NSString *price;
/** 数量 */
@property (nonatomic) NSString *quantity;
/** 总价 */
@property (nonatomic) NSString *total_price;


@end

