//
//  ZQOrderRecordAddSkuModel.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/26.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>


/** 添加单品到订单模板 */
@interface ZQOrderRecordAddSkuModel : NSObject

#pragma mark - 添加单品

#pragma mark - 必须 @required

/** 商品名称 */
@property (nonatomic) NSString *name;
/** 商品 id */
@property (nonatomic) NSString *pid;
/** 单品 id */
@property (nonatomic) NSString *sid;
/** 商店 id */
@property (nonatomic) NSString *shop_id;
/** 单品价格 */
@property (nonatomic) NSString *price;
/** 单品数量 */
@property (nonatomic) NSString *quantity;
/** 单品属性集合，半角逗号隔开（如：单价,一级） */
@property (nonatomic) NSString *attributes;

#pragma mark -  可选  @optional
/** 计量单位 */
@property (nonatomic) NSString *unit;
/** 模版名称 */
@property (nonatomic) NSString *template;


@end
