//
//  UIButton+Category.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/11.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Category)

/**
 button parameter title font textColor bgcolor
 */
+ (instancetype)btnWithTitle:(NSString *)title font:(CGFloat)font textColor:(UIColor *)textColor bgColor:(UIColor *)bgColor;

@end
