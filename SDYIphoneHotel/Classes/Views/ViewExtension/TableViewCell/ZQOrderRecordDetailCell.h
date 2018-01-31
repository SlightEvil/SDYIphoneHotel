//
//  ZQOrderRecordDetailCell.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/29.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ZQOrderRecordSkuModel;

/**
 订单模板 详情列表 cell
 */
@interface ZQOrderRecordDetailCell : UITableViewCell

/** 列表商品model */
@property (nonatomic) ZQOrderRecordSkuModel *skuModel;

@end
