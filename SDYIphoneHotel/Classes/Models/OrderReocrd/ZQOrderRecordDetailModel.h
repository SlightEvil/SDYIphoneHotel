//
//  ZQOrderRecordDetailModel.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/27.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 订单模板详情model  包含 单品列表Ary  和下单列表Ary
 */
@interface ZQOrderRecordDetailModel : NSObject

/** 模版详情，按单品列表 */
@property (nonatomic) NSArray *template_details;
/** 模版详情，按下单列表  （购物车） */
@property (nonatomic) NSArray *direct_order_template_details;

@end
