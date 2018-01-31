//
//  ZQPickerView.h
//  testPickerView
//
//  Created by admin on 2018/1/27.
//  Copyright © 2018年 MaZhiqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQPickerView : UIView

/** dataSource  */
@property (nonatomic) NSArray *dataSource;



/** 显示 */
- (void)show;
/** 隐藏 */
- (void)dismiss;

/**
 点击完成callback
 @param block return name
 */
- (void)comfirmClickBlock:(void(^)(NSString *name))block;

@end
