//
//  ZQViewModel.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/16.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ViewModel   [ZQViewModel sharedZQViewModel]

/** 购物车商品数量通知Key */
FOUNDATION_EXPORT NSString *const kZQShopCartQuantityKey;
/** 购物车商品总价通知Key */
FOUNDATION_EXPORT NSString *const kZQShopCartTotalPriceKey;


@class ZQAddNewProductModel;
@interface ZQViewModel : NSObject
single_interface(ZQViewModel)


/** 商品列表的 */
@property (nonatomic) NSArray *productCategoryDataSource;

/** 购物车的数据 */
@property (nonatomic) NSMutableArray *shopCartDataSource;

/** 已收藏的商品product_id   在登录后就请求，判断是否是收藏还是删除收藏  */
@property (nonatomic) NSArray *recordProduct;


/**
 购物车添加新的商品 parameter  ZQAddNewProductModel
 @param newProduct 新建商品的model
 */
- (void)addNewProductToShopCart:(ZQAddNewProductModel *)newProduct;

/**
 删除商品 parameter indexpath 需要删除的元素下标

 @param indexPath 元素下标
 */
- (void)deleteProductToShopCartWithIndexPath:(NSIndexPath *)indexPath;

/**
 修改 指定 商品的数量 quantity 新的商品数量 indexPath  指定的元素下标

 @param quantity 新的商品数量
 @param indexPath 指定的元素
 */
- (void)changeProductQuantity:(NSString *)quantity indexPath:(NSIndexPath *)indexPath;

/**
 清空购物车
 */
- (void)clearShopCartProduct;

/**
 添加新订单 参数

 @return 参数
 */
- (NSString *)addNewOrderContent;


@end
