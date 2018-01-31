//
//  ZQShopCartCell.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/16.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQShopCartCell.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ZQQuantityTextField.h"
#import "UIImage+Cagegory.h"
#import "ZQAddNewProductModel.h"


NSString *const kQuantityNumberKey = @"self.productQuantityTextField.text";


@interface ZQShopCartCell ()

/** 商品logo */
@property (nonatomic) UIImageView *productLogoImageView;
/** 商品名称  */
@property (nonatomic) UILabel *productNameLabel;
/** 商品规格 */
@property (nonatomic) UILabel *productAttributeLabel;
/** 商品quantity */
@property (nonatomic) ZQQuantityTextField *productQuantityTextField;
/** 商品单价 */
@property (nonatomic) UILabel *productPriceLabel;
/** 删除商品button */
@property (nonatomic) UIButton *deleteProductBtn;

@end

@implementation ZQShopCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
        [self layoutWithAuto];
        
    }
    return self;
}


#pragma mark - Event response

- (void)deleteProductBtnClick
{
//    if (self.cellDeleteProductClick) {
//        self.cellDeleteProductClick();
//    }
//
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellProductDeleteIndexPath:)]) {
        [self.delegate cellProductDeleteIndexPath:self.indexPath];
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:kQuantityNumberKey]) {
        
//        NSString *oldValue = [change objectForKey:NSKeyValueChangeOldKey];
        NSString *newValue = [change objectForKey:NSKeyValueChangeNewKey];
    
//        if (self.cellQuantityChangeClick) {
//            self.cellQuantityChangeClick(newValue);
//        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(cellProductQuantityChange:indexPath:)]) {
            [self.delegate cellProductQuantityChange:newValue indexPath:self.indexPath];
        }
        
    }
}

#pragma mark - Private medthod

- (void)setupUI
{
    [self.contentView addSubview:self.productLogoImageView];
    [self.contentView addSubview:self.productNameLabel];
    [self.contentView addSubview:self.productAttributeLabel];
    [self.contentView addSubview:self.productPriceLabel];
    [self.contentView addSubview:self.productQuantityTextField];
    [self.contentView addSubview:self.deleteProductBtn];
    
    [self addObserver:self forKeyPath:kQuantityNumberKey options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)layoutWithAuto
{
    [self.productLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).mas_offset(10);
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).mas_offset(-10);
            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft).mas_offset(10);
        } else {
            make.top.left.equalTo(self.contentView).mas_offset(10);
            make.bottom.equalTo(self.contentView).mas_offset(-10);
        }
        make.width.mas_equalTo(80);
    }];
    [self.deleteProductBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).mas_equalTo(-10);
        } else {
            make.right.equalTo(self).mas_equalTo(-10);
        }
        make.height.width.mas_equalTo(30);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).mas_equalTo(5);
        } else {
           make.top.equalTo(self).mas_equalTo(5);
        }
        make.left.equalTo(self.productLogoImageView.mas_right).mas_offset(10);
        make.right.equalTo(self.deleteProductBtn.mas_left).mas_offset(10);
    }];
    [self.productAttributeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productNameLabel.mas_bottom);
        make.height.left.right.equalTo(self.productNameLabel);
    }];
    [self.productPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).mas_equalTo(-5);
        } else {
            make.bottom.equalTo(self).mas_offset(-5);
        }
        make.top.equalTo(self.productAttributeLabel.mas_bottom);
        make.left.height.equalTo(self.productAttributeLabel);
    }];

    [self.productQuantityTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
             make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom).mas_offset(-5);
        } else {
             make.bottom.equalTo(self).mas_offset(-5);
        }
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
        make.right.equalTo(self.deleteProductBtn.mas_left).mas_offset(-20);
    }];
    [self.productNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.productPriceLabel);
    }];
    [self.productPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.productQuantityTextField.mas_left).mas_offset(10);
    }];
}


- (UILabel *)labelWithFont:(UIFont *)font textColor:(UIColor *)textColor
{
    UILabel *label = [UILabel new];
    label.font = font;
    label.textColor = textColor;
    label.numberOfLines = 2;
    return label;
}



#pragma mark - Setter and Getter

- (void)setDetaiModel:(ZQAddNewProductDetail *)detaiModel
{
    _detaiModel = detaiModel;
    
    [self.productLogoImageView sd_setImageWithURL:[NSURL URLWithString:kSDYImageUrl(_detaiModel.thumbnail)] placeholderImage:[UIImage imageNamed:@"icon_error"]];
    self.productNameLabel.text = _detaiModel.product_name;
    self.productAttributeLabel.text = _detaiModel.attributes;
    self.productPriceLabel.text = [NSString stringWithFormat:@"¥%@元",_detaiModel.price];
    self.productQuantityTextField.textQuantity = [NSString stringWithFormat:@"%zd",[_detaiModel.quantity integerValue]];
    
}

- (UIImageView *)productLogoImageView
{
    if (!_productLogoImageView) {
        _productLogoImageView = [[UIImageView alloc] init];
    }
    return _productLogoImageView;
}

- (UILabel *)productNameLabel
{
    if (!_productNameLabel) {
        _productNameLabel = [self labelWithFont:[UIFont fontWithName:kZQFontNameBold size:kZQCellFont] textColor:[UIColor blackColor]];
    }
    return _productNameLabel;
}

- (UILabel *)productAttributeLabel
{
    if (!_productAttributeLabel) {
        _productAttributeLabel = [self labelWithFont:[UIFont systemFontOfSize:kZQCellFont] textColor:[UIColor blackColor]];
    }
    return _productAttributeLabel;
}

- (UILabel *)productPriceLabel
{
    if (!_productPriceLabel) {
        _productPriceLabel = [self labelWithFont:[UIFont fontWithName:kZQFontNameBold size:kZQCellFont] textColor:[UIColor redColor]];
    }
    return _productPriceLabel;
}

- (ZQQuantityTextField *)productQuantityTextField
{
    if (!_productQuantityTextField) {
        _productQuantityTextField = [[ZQQuantityTextField alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    }
    return _productQuantityTextField;
}

- (UIButton *)deleteProductBtn
{
    if (!_deleteProductBtn) {
        _deleteProductBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteProductBtn addTarget:self action:@selector(deleteProductBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_deleteProductBtn setImage:[UIImage sizeImageWithImage:[UIImage imageNamed:@"icon_delete"] sizs:CGSizeMake(35, 35)] forState:UIControlStateNormal];
    }
    return _deleteProductBtn;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
