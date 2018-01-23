//
//  ZQProductSkusModel.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/14.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 商品单品model */
@interface ZQProductSkusModel : NSObject


/** 产品名字 */
@property (nonatomic) NSString *product_name;
/** 创建时间 */
@property (nonatomic) NSString *created_at;
/** 商场价格 */
@property (nonatomic) NSString *mall_price;
/** 单品id */
@property (nonatomic) NSString *sku_id;
/** 库存 */
@property (nonatomic) NSString *stock;
/** 市场价格 */
@property (nonatomic) NSString *market_price;
/** 产品ID */
@property (nonatomic) NSString *product_id;
/** 是否删除 */
@property (nonatomic) NSString *is_delete;
/** 规格id */
@property (nonatomic) NSString *attributes;
/** 规格名称 */
@property (nonatomic) NSString *attribute_names;
/** 销售 */
@property (nonatomic) NSString *sales;
/** 显示销售 */
@property (nonatomic) NSString *show_sales;

/** 规格的数组 用来根据规格数字显示规格    没用到 */
@property (nonatomic) NSArray *attributeArray;

@end
