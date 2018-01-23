//
//  ZQProductDetailV.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/14.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZQAddNewProductModel;
@protocol ZQProductDetailVDeleagte <NSObject>

@required
/** 添加新的商品  ZQAddNewProductModel */
- (void)productAddNewProduct:(ZQAddNewProductModel *)newProduct;
///** 收藏或者 取消收藏   productID  商品ID   isRecord  是否已收藏 */
//- (void)productRecordProduct:(NSString *)productID isRecord:(BOOL)isRecord;

/**
 收藏按钮成功   为了刷新列表    isCancelRecord 是否为取消收藏

 @param isCancelRecord 是否为取消收藏
 */
- (void)productRecordSuccessForIsCancelRecord:(BOOL)isCancelRecord;

@end



/** 商品详情View */
@interface ZQProductDetailV : UIView

/** 添加新商品  和收藏商品的代理事件 */

@property (nonatomic, weak) id <ZQProductDetailVDeleagte>delegate;

/** 显示商品详情 DataSource dic */
- (void)showDetailView:(NSDictionary *)productDic;
/** 隐藏商品详情 */
- (void)hiddenDetailView;


@end
