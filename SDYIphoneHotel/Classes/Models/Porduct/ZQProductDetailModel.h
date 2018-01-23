//
//  ZQProductDetailModel.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/10.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>


/** 商品的详细信息  */
@interface ZQProductDetailModel : NSObject

/** 计量单位 */
@property (nonatomic) NSString *unit;
/** 产品名称 */
@property (nonatomic) NSString *product_name;
/** 产品副名称 */
@property (nonatomic) NSString *product_sub_name;
/** 描述 */
@property (nonatomic) NSString *product_description;
/** 分类id */
@property (nonatomic) NSString *category_id;
/** 商场价格 */
@property (nonatomic) NSString *mall_price;
/** 商店名字 */
@property (nonatomic) NSString *shop_name;
/** 库存 */
@property (nonatomic) NSString *stock;
/** 是否上架 */
@property (nonatomic) NSString *is_on_sale;
/** 市场价格 */
@property (nonatomic) NSString *market_price;
/** 产品ID */
@property (nonatomic) NSString *product_id;
/** 是否推荐 */
@property (nonatomic) NSString *is_recommand;
/** 是否首页显示 */
@property (nonatomic) NSString *show_index;
/** 缩略图 */
@property (nonatomic) NSString *thumbnail;
/** 销售 */
@property (nonatomic) NSString *sales;
/** 销售基数 */
@property (nonatomic) NSString *show_sales;
/** 商店id */
@property (nonatomic) NSString *shop_id;


@end
