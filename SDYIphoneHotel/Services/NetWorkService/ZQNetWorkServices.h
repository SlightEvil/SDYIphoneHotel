//
//  ZQNetWorkServices.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/9.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZQNetWorkServices : NSObject



/**
 GET 请求 success 返回字典， 失败返回错误描述，已使用HUD 显示

 @param urlStr URL
 @param parameter 参数
 @param successBlock callback
 @param failBlock callback
 */
- (void)GET:(NSString *)urlStr parameter:(id)parameter success:(void(^)(NSDictionary *dictionary))successBlock fail:(void(^)(NSString *errorDescription))failBlock;


/**
 POST success 返回字典，失败返回错误描述 已使用HUD 显示   下单 

 @param urlStr URL
 @param parameter 参数字典
 @param successBlock callback（字典）
 @param failBlock callback 错误描述
 */
- (void)POST:(NSString *)urlStr parameter:(id)parameter success:(void(^)(NSDictionary *dictionary))successBlock fail:(void(^)(NSString *errorDescription))failBlock;





@end
