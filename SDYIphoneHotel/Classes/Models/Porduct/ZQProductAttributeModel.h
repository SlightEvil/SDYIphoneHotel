//
//  ZQProductAttributeModel.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/14.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>


/** 商品规格model  */
@interface ZQProductAttributeModel : NSObject

//规格分组名称
@property (nonatomic) NSString *group_name;

//规格名称
@property (nonatomic) NSString *attribute_name;
//单品id
@property (nonatomic) NSString *sku_id;
//单品库存
@property (nonatomic) NSString *stock;
//单品销量
@property (nonatomic) NSString *sales;
//销量基数
@property (nonatomic) NSString *show_sales;
//级别
@property (nonatomic) NSMutableArray *attributes;

@end
