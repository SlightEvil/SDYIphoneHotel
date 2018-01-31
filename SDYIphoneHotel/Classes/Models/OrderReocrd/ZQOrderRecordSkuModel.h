//
//  ZQOrderRecordSkuModel.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/26.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 订单模板 单品model   数组key  template_details
 */
@interface ZQOrderRecordSkuModel : NSObject


/** 用户id */
@property (nonatomic) NSString *user_id;
/** 商品 id */
@property (nonatomic) NSString *product_id;
/** 单品 id */
@property (nonatomic) NSString *sku_id;
/** 商店 id */
@property (nonatomic) NSString *shop_id;
/** 数量 */
@property (nonatomic) NSString *quantity;
/** 单品属性集合 */
@property (nonatomic) NSString *attributes;
/** 创建时间 */
@property (nonatomic) NSString *created_at;
/** 市场价 */
@property (nonatomic) NSString *market_price;
/** 商城价 */
@property (nonatomic) NSString *mall_price;
/** 商品名称 */
@property (nonatomic) NSString *product_name;
/** 缩略图 */
@property (nonatomic) NSString *thumbnail;
/** 计量单位 */
@property (nonatomic) NSString *unit;
/** 商店名称 */
@property (nonatomic) NSString *shop_name;
/** 商店电话 */
@property (nonatomic) NSString *phone;

//"user_id": "2",
//"product_id": "232",
//"sku_id": "947",
//"shop_id": "146",
//"quantity": "3.00",
//"attributes": "单价",
//"created_at": "2018-01-17 11:29:47",
//"market_price": "2.50",
//"mall_price": "1.50",
//"product_name": "精瘦肉",
//"thumbnail": "/uploads/image/lksjodf92832.jpg",
//"unit": "斤",
//"shop_name": "立世调料行",
//"phone": "15539281268"


@end
