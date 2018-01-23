//
//  ZQNetWorkServices.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/9.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQNetWorkServices.h"
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD.h>

@interface ZQNetWorkServices ()

@property (nonatomic) AFHTTPSessionManager *manager;

@end

@implementation ZQNetWorkServices


- (void)GET:(NSString *)urlStr parameter:(id)parameter success:(void(^)(NSDictionary *dictionary))successBlock fail:(void(^)(NSString *errorDescription))failBlock
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameter];
    if (AppCT.loginUser.user_id && AppCT.loginUser.token) {
        [dic setObject:AppCT.loginUser.user_id forKey:@"uid"];
        [dic setObject:AppCT.loginUser.token forKey:@"token"];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.manager GET:urlStr parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failBlock) {
            failBlock(error.localizedDescription);
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        [SVProgressHUD dismissWithDelay:1.0];
    }];
}

- (void)POST:(NSString *)urlStr parameter:(id)parameter success:(void(^)(NSDictionary *dictionary))successBlock fail:(void(^)(NSString *errorDescription))failBlock
{
    //需要拼接 uid  跟token 到网址后缀
    if (AppCT.isUserLogin) {
    //除了登录其他的POST 都要拼接 UID  跟token
        NSString *suffixString = [NSString stringWithFormat:@"&uid=%@&token=%@",AppCT.loginUser.user_id,AppCT.loginUser.token];
        urlStr = [urlStr stringByAppendingString:suffixString];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.manager POST:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failBlock) {
            failBlock(error.localizedDescription);
        }
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        [SVProgressHUD dismissWithDelay:1.0];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}



- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];//json返回
        
// 上传json格式
//     _manager.requestSerializer = [AFJSONRequestSerializer serializer];
//     _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//AFN json 解析返回的数据  (back dictionary)
//        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
//设置返回类型
//        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    }
    return _manager;
}

@end
