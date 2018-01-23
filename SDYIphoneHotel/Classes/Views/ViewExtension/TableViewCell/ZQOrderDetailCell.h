//
//  ZQOrderDetailCell.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/20.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZQMyOrderListDetailModle;

/**
 订单详情显示商品的cell
 */
@interface ZQOrderDetailCell : UITableViewCell

/** 商品名称 */
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
/** 单价*数量 */
@property (weak, nonatomic) IBOutlet UILabel *priceQuantityLabel;
/** 总价 */
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

/** 预订单和配送单的DataSource */
@property (nonatomic) ZQMyOrderListDetailModle *detailModel;



@end
