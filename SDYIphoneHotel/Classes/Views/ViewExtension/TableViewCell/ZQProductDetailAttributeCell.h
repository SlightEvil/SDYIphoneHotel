//
//  ZQProductDetailAttributeCell.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/14.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZQProductDetailAttributeCell : UITableViewCell

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign) BOOL buttonIsSelected;
@property (nonatomic, copy) void(^attributeBtnClick)(NSUInteger index);

/** 必须在其他属性前设置 */
@property (nonatomic, copy) NSString *productUnit;
/** 规格 */
@property (nonatomic, copy) NSString *attribute;
/** 商场价格 */
@property (nonatomic, copy) NSString *mallPrice;
/** 市场价格 */
@property (nonatomic, copy) NSString *makePrice;



@end
