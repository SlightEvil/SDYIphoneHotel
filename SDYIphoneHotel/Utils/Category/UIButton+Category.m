//
//  UIButton+Category.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/11.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "UIButton+Category.h"

@implementation UIButton (Category)


/**
 button parameter title font textColor bgcolor

 */
+ (instancetype)btnWithTitle:(NSString *)title font:(CGFloat)font textColor:(UIColor *)textColor bgColor:(UIColor *)bgColor
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:textColor ? textColor : [UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font ? font : 17];
    [btn setBackgroundColor:bgColor];
    return btn;
}

@end
