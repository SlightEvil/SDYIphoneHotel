//
//  ZQProductShopModel.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/14.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 商品商店model  */
@interface ZQProductShopModel : NSObject

/** 电话号码 */
@property (nonatomic) NSString *phone;
/** 地址 */
@property (nonatomic) NSString *address;
/** 商店内容 */
@property (nonatomic) NSString *shop_content;
/** email */
@property (nonatomic) NSString *email;
/** 商店的用户ID */
@property (nonatomic) NSString *user_id;
/** 商店名字 */
@property (nonatomic) NSString *shop_name;
/** shop_id */
@property (nonatomic) NSString *shop_id;
/** 手机号码 */
@property (nonatomic) NSString *master_phone;

@end
