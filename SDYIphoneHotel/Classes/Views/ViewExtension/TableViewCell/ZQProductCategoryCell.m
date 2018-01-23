//
//  ZQProductCategoryCell.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/18.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQProductCategoryCell.h"

@implementation ZQProductCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.ProductNameLabel.font = [UIFont fontWithName:kZQFontNameBold size:17];
    self.ProductNameLabel.numberOfLines = 2;
    
    // Initialization code
}

- (void)setCategoryName:(NSString *)categoryName
{
    _categoryName = categoryName;
    self.ProductNameLabel.text = _categoryName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
