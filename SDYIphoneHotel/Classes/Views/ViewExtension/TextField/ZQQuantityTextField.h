//
//  ZQQuantityTextField.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/12.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQBaseTextField.h"

@interface ZQQuantityTextField : ZQBaseTextField

/** 最大数量 */
@property (nonatomic, assign) NSInteger maxNumber;

/** 设置text数量  必须设置  不能设置text */
@property (nonatomic, copy) NSString *textQuantity;


/** 初始化方法 */
- (instancetype)initWithFrame:(CGRect)frame;


@end
