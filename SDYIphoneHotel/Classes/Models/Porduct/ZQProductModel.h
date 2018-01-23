//
//  ZQProductModel.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/14.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>


@class ZQProductDetailModel;


/** 商品详情商品的信息 */
@interface ZQProductModel : NSObject

/** 商品 */
@property (nonatomic) ZQProductDetailModel *product;
/** 供应商数组 */
@property (nonatomic) NSArray *shops;
/** 单品数组 */
@property (nonatomic) NSArray *skus;
/** 规格数组 */
@property (nonatomic) NSArray *attributes;







@end
