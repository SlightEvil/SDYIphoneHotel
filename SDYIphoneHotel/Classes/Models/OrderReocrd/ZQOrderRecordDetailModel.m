//
//  ZQOrderRecordDetailModel.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/27.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQOrderRecordDetailModel.h"


@implementation ZQOrderRecordDetailModel

/** 返回数组里面的模型 */
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"template_details":@"ZQOrderRecordSkuModel",@"direct_order_template_details":@"ZQAddNewProductModel"};
}

//+ (NSDictionary *)mj_objectClassInArray
//{
//    return @{@"shops":@"ZQProductShopModel",@"skus":@"ZQProductSkusModel",@"attributes":@"ZQProductAttributeModel"};
//}


@end
