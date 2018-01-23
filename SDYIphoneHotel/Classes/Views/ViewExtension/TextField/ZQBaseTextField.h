//
//  ZQBaseTextField.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/12.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQBaseTextField : UITextField


/** 键盘上面的inputAccessoryView */
- (UIToolbar *)keyboardTopToolBar;

/** 设置toolBar titleView 的text */
- (void)toolbarTitle:(NSString *)title;


@end
