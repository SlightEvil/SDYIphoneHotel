//
//  ZQOrderRcordModel.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/25.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 订单模板 model
 */
@interface ZQOrderRecordModel : NSObject

/** 创建时间 */
@property (nonatomic) NSString *created_at;
/** 模板名称 */
@property (nonatomic) NSString *template_name;
/** 模版编码 */
@property (nonatomic) NSString *template_no;
/** 用户id */
@property (nonatomic) NSString *user_id;
/** 模板id */
@property (nonatomic) NSString *template_id;
/** 模板描述 */
@property (nonatomic) NSString *template_description;



@end
