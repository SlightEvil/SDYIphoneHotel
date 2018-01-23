//
//  ZQOrderListCell.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/19.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZQMyOrderListModel;



@protocol ZQOrderListCellDelegate <NSObject>

/**
 cell 的确认收货 点击事件  indexPath 为cell所在的indexPath

 @param indexPath cell所在的indexPath
 */
- (void)orderListCellReceiveClick:(NSIndexPath *)indexPath;

@end



/** 订单列表的cell */
@interface ZQOrderListCell : UITableViewCell

/** cell的确认收货的代理事件 */
@property (nonatomic, weak) id <ZQOrderListCellDelegate>delegate;
/** 订单数据 */
@property (nonatomic) ZQMyOrderListModel *orderListModel;
/** cell 所在的indexPath */
@property (nonatomic, assign) NSIndexPath *indexPath;

@end
