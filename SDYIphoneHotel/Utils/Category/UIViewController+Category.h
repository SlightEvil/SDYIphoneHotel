//
//  UIViewController+Category.h
//  SDYHotel
//
//  Created by admin on 2017/12/13.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Category)


/**
 弹窗 只有complete 有callback

 @param title title
 @param message message
 @param completeBlock completeBlock 
 */
- (void)alertTitle:(NSString *)title message:(id)message complete:(void(^)(void))completeBlock;

@end
