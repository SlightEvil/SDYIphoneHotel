//
//  ZQAccountLogCell.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/18.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZQAccountLogModel;
@interface ZQAccountLogCell : UITableViewCell

/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *logTitleLabel;
/** 订单号 */
@property (weak, nonatomic) IBOutlet UILabel *logTradeNoLabel;
/** 创建时间 */
@property (weak, nonatomic) IBOutlet UILabel *logCreateLabel;
/** 订单发生金额 */
@property (weak, nonatomic) IBOutlet UILabel *logFundLabel;
/** 订单发生后余额 */
@property (weak, nonatomic) IBOutlet UILabel *logBalanceLabel;

/** 订单的数据 */
@property (nonatomic) ZQAccountLogModel *accountLogModel;


@end
