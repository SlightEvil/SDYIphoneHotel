//
//  ZQViewModel.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/16.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQViewModel.h"
#import "ZQAddNewProductModel.h"
#import <MJExtension/MJExtension.h>


NSString *const kZQShopCartQuantityKey = @"kZQShopCartQuantityKey";
NSString *const kZQShopCartTotalPriceKey = @"kZQShopCartTotalPriceKey";


@interface ZQViewModel ()

/** 商品总价 */
@property (nonatomic, assign) CGFloat totalPrice;

@end

@implementation ZQViewModel
single_implementation(ZQViewModel)


- (void)addNewProductToShopCart:(ZQAddNewProductModel *)newProduct
{
    if (!_shopCartDataSource) {
        _shopCartDataSource = [NSMutableArray array];
    }
    self.shopCartDataSource = [self shopCartAddNewProductto:newProduct fromAry:self.shopCartDataSource];
}

- (void)deleteProductToShopCartWithIndexPath:(NSIndexPath *)indexPath
{
    self.shopCartDataSource = [self deleteProductIndexPath:indexPath];
}

- (void)changeProductQuantity:(NSString *)quantity indexPath:(NSIndexPath *)indexPath
{
    self.shopCartDataSource = [self changeProductQuantity:quantity withIndexPath:indexPath];
    
}
- (void)clearShopCartProduct
{
    self.shopCartDataSource = [NSMutableArray array];
}


/** 购物车里面的数据的个数 */
- (NSInteger)shopCartCount
{
    __block  NSInteger number = 0;
    __block CGFloat price = 0.00;
    
    @autoreleasepool {
        [self.shopCartDataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            ZQAddNewProductModel *productModel = obj;

            [productModel.details enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ZQAddNewProductDetail *detailModel = obj;
                number += [detailModel.quantity integerValue];
                price += [detailModel.price floatValue] * [detailModel.quantity floatValue];
            }];
        }];
    }
    self.totalPrice = price;
    return number;
}


#pragma mark - Private method

/**
 添加新的商品到购物车 DataSource
 
 @param product ZQAddNewProductModel 新的商品
 */
- (NSMutableArray *)shopCartAddNewProductto:(ZQAddNewProductModel *)product fromAry:(NSMutableArray *)shopCartAry
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:shopCartAry];
    if (array.count == 0) {
        [array addObject:product];
        return array;
    }
    
    //判断购物车数组包含 相同供应商
    __block BOOL isContain = NO;
    @autoreleasepool {
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            ZQAddNewProductModel *productModel = obj;
            if (productModel.shop_id == product.shop_id) {
                
                //新添加商品只有一个 所以直接就是数组index  0
                productModel.details = [self productAddProductDetail:product.details[0] formDetailAry:productModel.details];
                isContain = YES;
            }
        }];
    }
    //不包含 添加新的元素
    if (!isContain) {
        [array addObject:product];
    }
    return array;
}

/**
 相同供应商 添加商品（相同/不同）
 
 @param productDetail ZQAddNewProductDetail 商品详情model
 */
- (NSMutableArray *)productAddProductDetail:(ZQAddNewProductDetail *)productDetail formDetailAry:(NSMutableArray *)detailAry
{
    //数组
    NSMutableArray *array = [NSMutableArray arrayWithArray:detailAry];
    //数组里面舒服存在 新的商品信息
    __block BOOL isContain = NO;
    @autoreleasepool {
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            ZQAddNewProductDetail *detailModel = obj;
            //判断单品id 是否相同，相同则合并元素
            if (detailModel.sku_id == productDetail.sku_id) {
                NSString *number = [NSString stringWithFormat:@"%zd",[detailModel.quantity integerValue] + [productDetail.quantity integerValue]];
                detailModel.quantity = number;
                //该数组存在 相同  元素
                isContain = YES;
            }
        }];
    }
    //如果不存在 则添加新元素
    if (!isContain) {
        [array addObject:productDetail];
    }
    return array;
}

/**
 删除指定的商品

 @param indexPath 指定元素的下标
 @return 返回删除后的数组
 */
- (NSMutableArray *)deleteProductIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.shopCartDataSource];
    //删除知指定的元素  from indexpath
    ZQAddNewProductModel *sectionModel  = array[indexPath.section];
    [sectionModel.details removeObjectAtIndex:indexPath.row];
    //如果指定的section 商家 里面没有商品了  则删除该商家section
    if (sectionModel.details.count == 0) {
        [array removeObjectAtIndex:indexPath.section];
    }
    return array;
}

/**
 修改指定元素的 数量 parameter  quantity  indexpath

 @param quantity 数量
 @param indexPath indexPath
 @return 返回修改后的数组
 */
- (NSMutableArray *)changeProductQuantity:(NSString *)quantity withIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.shopCartDataSource];
    ZQAddNewProductModel *sectionModel = array[indexPath.section];
    ZQAddNewProductDetail *rowModel = sectionModel.details[indexPath.row];
    rowModel.quantity = quantity;
    return array;
}

- (NSString *)addNewOrderContent
{
    NSArray *dataSource = self.shopCartDataSource;
    NSMutableArray *array = [NSMutableArray array];
    
    @autoreleasepool {
        [dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            ZQAddNewProductModel *productModel = obj;
            
            [dic setObject:productModel.shop_id forKey:shop_id];
            [dic setObject:productModel.shop_name forKey:shop_name];
            [dic setObject:productModel.shop_phone forKey:shop_phone];
            [dic setObject:productModel.content forKey:content];
            [dic setObject:AppCT.loginUser.user_id forKey:user_id];
            [dic setObject:AppCT.loginUser.user_name forKey:user_name];
            
            __block CGFloat totalPrice = 0.00;
            NSMutableArray *detailAry = [NSMutableArray array];
            
            
                [productModel.details enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSMutableDictionary *detailDic = [NSMutableDictionary dictionary];
                    ZQAddNewProductDetail *detailModel = obj;
                    [detailDic setObject:detailModel.detail_id ? detailModel.detail_id : @"" forKey:detail_id];
                    [detailDic setObject:detailModel.sku_id forKey:sku_id];
                    [detailDic setObject:detailModel.product_name forKey:@"product_name"];
                    [detailDic setObject:detailModel.product_id forKey:product_id];
                    [detailDic setObject:detailModel.attributes forKey:attributes];
                    [detailDic setObject:detailModel.price forKey:@"price"];
                    [detailDic setObject:detailModel.quantity forKey:quantity];
                    [detailDic setObject:detailModel.unit forKey:unit];
                    //合并总价
                    totalPrice += ([detailModel.price floatValue] * [detailModel.quantity floatValue]);
                    [detailAry addObject:detailDic];
                }];
            
            //设置总价
            [dic setObject:[NSString stringWithFormat:@"%.2f",totalPrice] forKey:@"price"];
            //设置商品
            [dic setObject:detailAry forKey:@"details"];

            [array addObject:dic];
        }];
    }
    NSError *error ;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *jsonResult = [jsonTemp stringByReplacingOccurrencesOfString:@" " withString:@""];

    return jsonResult;
}


#pragma mark - Getter and Setter

- (void)setShopCartDataSource:(NSMutableArray *)shopCartDataSource
{
    _shopCartDataSource = shopCartDataSource;
    
    zq_asyncDispatchToMainQueue(^{
        //购物车商品个数
        NSString *productNumber = [NSString stringWithFormat:@"%zd",[self shopCartCount]];
        NSString *productTotalPrice = [NSString stringWithFormat:@"%.2f",self.totalPrice];
        Post_Observer(kZQShopCartProductNumberBadgeValueNotification, nil, (@{kZQShopCartQuantityKey:productNumber,kZQShopCartTotalPriceKey:productTotalPrice}));
    });
}


@end
