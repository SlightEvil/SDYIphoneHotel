//
//  ZQOrderDetailHeader.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/20.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 订单详情的header
 */
@interface ZQOrderDetailHeader : UITableViewHeaderFooterView

/** 显示title */
@property (nonatomic, copy) NSString *title;
/** 是否展开 */
@property (nonatomic, assign) BOOL isExpand;

/** 点击header expand button 动作   是否展开 isExpand */
@property (nonatomic, copy) void(^expandClick)(BOOL isExpand);


@end
