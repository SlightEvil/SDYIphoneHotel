//
//  ZQShopCartCell.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/16.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol   ZQShopCartCellDelegate <NSObject>

/**
 商品数量发生改变 quantity 新的数量  indexpath 指定元素下标

 @param quantity 数量
 @param indexPath 指定元素
 */
- (void)cellProductQuantityChange:(NSString *)quantity indexPath:(NSIndexPath *)indexPath;

/**
 删除商品 indexpath 指定元素下标
 @param indexPath 指定元素
 */
- (void)cellProductDeleteIndexPath:(NSIndexPath *)indexPath;


@end

@class ZQAddNewProductDetail;
@interface ZQShopCartCell : UITableViewCell

/** 商品的详情 */
@property (nonatomic) ZQAddNewProductDetail *detaiModel;
/** 代理事件中需要的指定元素下标 */
@property (nonatomic, assign) NSIndexPath *indexPath;
/** 删除商品 修改商品数量的指定下标 */
@property (nonatomic, weak) id<ZQShopCartCellDelegate>delegate;

///** 商品修改数量 callback */
//@property (nonatomic, copy) void(^cellQuantityChangeClick)(NSString *quantity);
///** 删除商品按钮 */
//@property (nonatomic, copy) void(^cellDeleteProductClick)(void);


@end
