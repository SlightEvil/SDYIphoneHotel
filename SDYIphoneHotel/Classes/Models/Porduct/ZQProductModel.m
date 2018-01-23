//
//  ZQProductModel.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/14.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQProductModel.h"

@implementation ZQProductModel


+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"shops":@"ZQProductShopModel",@"skus":@"ZQProductSkusModel",@"attributes":@"ZQProductAttributeModel"};
}




@end
