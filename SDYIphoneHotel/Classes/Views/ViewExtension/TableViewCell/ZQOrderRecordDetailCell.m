//
//  ZQOrderRecordDetailCell.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/29.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQOrderRecordDetailCell.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ZQOrderRecordSkuModel.h"


@interface ZQOrderRecordDetailCell ()

/** logo */
@property (nonatomic) UIImageView *logoImageView;
/** name */
@property (nonatomic) UILabel *nameLabel;
/** 供应商 */
@property (nonatomic) UILabel *shopLabel;
/** 规格 */
@property (nonatomic) UILabel *attributesLabel;
/** 价格 */
@property (nonatomic) UILabel *priceLabel;


@end


@implementation ZQOrderRecordDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
        [self layoutWithAuto];
    }
    return self;
}


- (void)setupUI
{
    [self.contentView addSubview:self.logoImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.shopLabel];
    [self.contentView addSubview:self.attributesLabel];
    [self.contentView addSubview:self.priceLabel];
}

- (void)layoutWithAuto
{
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(2.5);
        make.left.equalTo(self).mas_offset(10);
        make.width.height.mas_equalTo(kZQCellHeithtOrderRecordDetail-5);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImageView);
        make.left.equalTo(self.logoImageView.mas_right).mas_equalTo(10);
        make.height.mas_equalTo(kZQCellHeithtOrderRecordDetail/2 -5);
    }];
    [self.shopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(self.nameLabel);
        make.right.equalTo(self).mas_offset(-10);
        make.left.equalTo(self.nameLabel.mas_right);
    }];
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shopLabel);
    }];
    [self.attributesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).mas_offset(2.5);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.attributesLabel);
        make.left.right.equalTo(self.shopLabel);
    }];
}


#pragma mark - Getter and Setter

- (void)setSkuModel:(ZQOrderRecordSkuModel *)skuModel
{
    _skuModel = skuModel;
    
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:kSDYImageUrl(_skuModel.thumbnail)] placeholderImage:[UIImage imageNamed:@"icon_error"]];
    
    self.nameLabel.text = _skuModel.product_name;
    self.shopLabel.text = _skuModel.shop_name;
    self.attributesLabel.text = _skuModel.attributes;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@%@",_skuModel.mall_price,_skuModel.unit];
}

- (UIImageView *)logoImageView
{
    if (!_logoImageView) {
        _logoImageView = [UIImageView new];
    }
    return _logoImageView;
}
- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont fontWithName:kZQFontNameBold size:kZQCellDetailFont];
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}
- (UILabel *)shopLabel
{
    if (!_shopLabel) {
        _shopLabel = [UILabel new];
        _shopLabel.font = [UIFont systemFontOfSize:kZQCellDetailFont];
        _shopLabel.numberOfLines = 2;
    }
    return _shopLabel;
}

- (UILabel *)attributesLabel
{
    if (!_attributesLabel) {
        _attributesLabel = [UILabel new];
        _attributesLabel.font = [UIFont systemFontOfSize:kZQCellDetailFont];
        _attributesLabel.numberOfLines = 2;
    }
    return _attributesLabel;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.font = [UIFont fontWithName:kZQFontNameBold size:kZQCellDetailFont];
        _priceLabel.numberOfLines = 2;
        _priceLabel.textColor = kSDYAttributeSelectColor;
    }
        return _priceLabel;
}



@end
