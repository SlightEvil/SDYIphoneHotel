//
//  ZQProductListVC.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/9.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//


/**
 商品列表 DataSource来源  （分类？收藏？搜索结果）

 - ZQProductListTypeCategory: 商品列表的DataSource 分类
 - ZQProductListTypeRecord: 商品列表的DataSource 收藏
 - ZQProductListTypeSearchResult: 商品列表的DataSource 搜索结果
 */
typedef NS_ENUM(NSUInteger, ZQProductListType){
    ZQProductListTypeCategory = 0,
    ZQProductListTypeRecord = 1,
    ZQProductListTypeSearchResult = 2,
};


#import "ZQBaseViewController.h"

/** 商品列表 （分类->,收藏->,搜索->） */
@interface ZQProductListVC : ZQBaseViewController

/** 商品列表DataSource 类型 */
@property (nonatomic) ZQProductListType productListType;

/** 当列表类型为 商品分类的时候设置需要 请求的商品分类的id */
@property (nonatomic) NSString *productCategoryID;


@end
