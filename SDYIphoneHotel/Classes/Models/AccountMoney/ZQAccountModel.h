//
//  ZQAccountModel.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/18.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 账户基本信息
 */
@interface ZQAccountModel : NSObject

/** 账户余额 */
@property (nonatomic) NSString *balance;
/** 账户id */
@property (nonatomic) NSString *account_id;
/** 用户id */
@property (nonatomic, copy) NSString *user_id;
/** 账户可用余额 */
@property (nonatomic, copy) NSString *valid_balance;
/** 账户可提现金额 */
@property (nonatomic, copy) NSString *cash_fund;
/** 账户冻结金额 */
@property (nonatomic, copy) NSString *frozen_fund;
/** 创建时间 */
@property (nonatomic, copy) NSString *created_at;
/** 更新时间 */
@property (nonatomic, copy) NSString *updated_at;

@end
