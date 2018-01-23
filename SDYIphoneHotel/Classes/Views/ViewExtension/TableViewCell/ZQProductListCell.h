//
//  ZQProductListCell.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/10.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZQProductDetailModel;

@interface ZQProductListCell : UITableViewCell

/** logo */
@property (weak, nonatomic) IBOutlet UIImageView *productLogo;
/** name */
@property (weak, nonatomic) IBOutlet UILabel *productName;
/** 商场价 */
@property (weak, nonatomic) IBOutlet UILabel *productMallPrice;
/** 市场价 */
@property (weak, nonatomic) IBOutlet UILabel *productMakePrice;

/** 商品model */
@property (nonatomic) ZQProductDetailModel *productModel;

@end
