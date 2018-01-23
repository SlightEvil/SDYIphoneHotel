//
//  ZQLoginUser.h
//  SDYIphoneHotel
//
//  Created by admin on 2017/12/26.
//  Copyright © 2017年 SanDaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Category.h"

@interface ZQLoginUser : NSObject

/** 用户id */
@property (nonatomic, copy) NSString *user_id;
/** 用户名称 */
@property (nonatomic, copy) NSString *user_name;
/** 用户电话 */
@property (nonatomic, copy) NSString *phone;
/** 用户邮箱 */
@property (nonatomic, copy) NSString *email;
/**  */
@property (nonatomic, copy) NSString *group_name;
/** token  */
@property (nonatomic, copy) NSString *token;


@end
