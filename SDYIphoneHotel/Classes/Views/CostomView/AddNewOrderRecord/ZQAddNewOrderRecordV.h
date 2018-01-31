//
//  ZQAddNewOrderRecordV.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/25.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 确认按钮的回调

 @param nameStr 订单模板的名称
 @param describeStr 订单模板的描述
 */
typedef void(^ConfirmCallBack)(NSString *nameStr,NSString *describeStr);




@protocol ZQAddNewOrderRecordVDelegate <NSObject>

/** 点击确定时间 nameStr 名称  describeStr 描述 */
- (void)confirmButtonClickAction:(NSString *)nameStr describe:(NSString *)describeStr;

@end


@interface ZQAddNewOrderRecordV : UIView


@property (nonatomic, weak) id<ZQAddNewOrderRecordVDelegate>delegate;

/** 是否需要描述   默认需要 */
@property (nonatomic, assign) BOOL isNeedDescribe;
/** 名称 */
@property (nonatomic, copy) NSString *nameString;
/** 描述 */
@property (nonatomic, copy) NSString *describeString;


/** 显示 */
- (void)show;
/** 隐藏 */
- (void)dismiss;

@end
