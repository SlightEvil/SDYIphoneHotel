//
//  ZQAccountLogModel.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/18.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 账户明细
 */
@interface ZQAccountLogModel : NSObject

/** 明细所属账户 id */
@property (nonatomic) NSString *account_id;
/** 账户明细id */
@property (nonatomic) NSString *log_id;
/** 明细备注 */
@property (nonatomic) NSString *content;
/** 交易订单号 */
@property (nonatomic) NSString *trade_no;
/** 明细标题 */
@property (nonatomic) NSString *log_title;
/** 交易类型。0，消费。1，充值。2，提现。3，管理员调账 */
@property (nonatomic) NSString *change_type;
/** 此次交易后余额 */
@property (nonatomic) NSString *post_balance;
/** 此明细发生金额 */
@property (nonatomic) NSString *fund;
/** 此次交易操作主体 id */
@property (nonatomic) NSString *manage_id;
/** 状态，无用 */
@property (nonatomic) NSString *status;
/** 创建时间 */
@property (nonatomic) NSString *created_at;


@end


/**
 title
 trade_no
 create_at
 fund //发生金额
 post_balance//之后约
 */
