//
//  ZQOrderDetailCell.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/20.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQOrderDetailCell.h"
#import "ZQMyOrderListModel.h"

@implementation ZQOrderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.productNameLabel.numberOfLines = 2;
    self.productNameLabel.font = [UIFont fontWithName:kZQFontNameBold size:kZQDetailFont];
    self.priceQuantityLabel.numberOfLines = 2;
    self.priceQuantityLabel.font = [UIFont fontWithName:kZQFontNameBold size:kZQDetailFont];
    
    self.totalPriceLabel.numberOfLines = 2;
    self.totalPriceLabel.font = [UIFont fontWithName:kZQFontNameBold size:kZQDetailFont];
    self.totalPriceLabel.textAlignment = NSTextAlignmentRight;
}

- (void)setDetailModel:(ZQMyOrderListDetailModle *)detailModel
{
    _detailModel = detailModel;
    
    self.productNameLabel.text = _detailModel.product_name;
//    self.priceQuantityLabel.text = [NSString stringWithFormat:@"%@*%zd",_detailModel.price,[_detailModel.quantity  integerValue]];
     self.priceQuantityLabel.text = [NSString stringWithFormat:@"%@*%.2f",_detailModel.price,[_detailModel.quantity  floatValue]];
    self.totalPriceLabel.text = _detailModel.total_price;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
