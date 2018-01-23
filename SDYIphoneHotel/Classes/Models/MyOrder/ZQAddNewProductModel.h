//
//  ZQAddNewProductModel.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/14.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 新建商品订单的model
 */
@interface ZQAddNewProductModel : NSObject

/** 供应商 id */
@property (nonatomic) NSString *shop_id;
/** 供应商 name */
@property (nonatomic) NSString *shop_name;
/** 供应商 Phone */
@property (nonatomic) NSString *shop_phone;
/** 添加商品的 总价 */
@property (nonatomic) NSString *price;
/** 备注 */
@property (nonatomic) NSString *content;
/** 添加的商品 */
@property (nonatomic) NSMutableArray *details;

@end


/**
 新建商品的detail信息
 */
@interface ZQAddNewProductDetail : NSObject

/** 更新的时候用到 */
@property (nonatomic) NSString *detail_id;
/** 单品id */
@property (nonatomic) NSString *sku_id;
/** 商品名称 */
@property (nonatomic) NSString *product_name;
/** 商品id */
@property (nonatomic) NSString *product_id;
/** 规格 描述 */
@property (nonatomic) NSString *attributes;
/** 单价 */
@property (nonatomic) NSString *price;
/** 数量 */
@property (nonatomic) NSString *quantity;
/** 单位 */
@property (nonatomic) NSString *unit;
/** 缩略图 */
@property (nonatomic) NSString *thumbnail;

@end


