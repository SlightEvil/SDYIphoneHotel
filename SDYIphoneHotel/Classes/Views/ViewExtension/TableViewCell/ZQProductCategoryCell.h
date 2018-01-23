//
//  ZQProductCategoryCell.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/18.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 商品分类的cell */
@interface ZQProductCategoryCell : UITableViewCell

/** 商品分类 */
@property (weak, nonatomic) IBOutlet UILabel *ProductNameLabel;
/** 商品分类名称 */
@property (nonatomic, copy) NSString *categoryName;

@end
