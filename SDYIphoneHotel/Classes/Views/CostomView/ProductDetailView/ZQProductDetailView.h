//
//  ZQProductDetailView.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/11.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>



@class ZQAddNewProductModel;
@protocol ZQProductDetailViewDelegate <NSObject>

@required
/**
 添加新商品到购物车   ZQAddNewProductModel
 @param newProductModel ZQAddNewProductModel 新的商品
 */
- (void)productDetailViewAddNewProduct:(ZQAddNewProductModel *)newProductModel;
//
///**
// 收藏商品   的商品id  ，也可以作为取消收藏商品 isRecord 是否已收藏
// @param productID 商品id
// */
//- (void)productDetailViewRecordProductID:(NSString *)productID isRecord:(BOOL)isRecord;
//

/**
 收藏按钮成功   为了刷新列表    isCancelRecord 是否为取消收藏
 */
- (void)productDetailViewRecordSuccessForIsCancelRecord:(BOOL)isCancelRecord;

@end

/**
 显示商品详情界面
 */
@interface ZQProductDetailView : UIView

/** 商品详情的DataSource */
@property (nonatomic) NSDictionary *productDetailDic;
/** 商品详情的事件代理   添加新商品  收藏商品 */
@property (nonatomic,weak) id<ZQProductDetailViewDelegate>delegate;

/** 唯一初始化方法 */
- (instancetype)initWithFrame:(CGRect)frame;


- (void)clearData;



@end
