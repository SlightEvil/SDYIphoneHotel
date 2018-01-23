//
//  ZQShopCartHeaderView.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/22.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ZQShopCartHeaderViewDelegate <NSObject>

/** 显示备注按钮点击事件 */
- (void)showAlertRemarkViewBtnClickIndex:(NSInteger)index;


@end


/** 购物车的header  点击显示输入框 */
@interface ZQShopCartHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id <ZQShopCartHeaderViewDelegate> delegate;
/** title 文字 */
@property (nonatomic, copy) NSString *titleStr;
/** 获取index */
@property (nonatomic, assign) NSInteger index;

@end
