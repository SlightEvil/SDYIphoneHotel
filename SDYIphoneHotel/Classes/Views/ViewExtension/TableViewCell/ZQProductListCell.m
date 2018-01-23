//
//  ZQProductListCell.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/10.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQProductListCell.h"
#import "ZQProductDetailModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ZQProductListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setProductModel:(ZQProductDetailModel *)productModel
{
    _productModel = productModel;
    
    self.productName.text = _productModel.product_name;
    self.productMallPrice.text = [NSString stringWithFormat:@"¥%@元",_productModel.mall_price];

    //中划线
    NSDictionary *attributeDic = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *atttibuteString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@元",_productModel.market_price] attributes:attributeDic];
    self.productMakePrice.attributedText = atttibuteString;
    
    [self.productLogo sd_setImageWithURL:[NSURL URLWithString:kSDYImageUrl(_productModel.thumbnail)] placeholderImage:[UIImage imageNamed:@"icon_error"]];
}


@end
