//
//  ZQProductDetailAttributeCell.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/14.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQProductDetailAttributeCell.h"
#import "Masonry.h"


@interface ZQProductDetailAttributeCell ()

/** 选择属性 */
@property (nonatomic) UIButton *attributeSelectBtn;
/** 商家价格 */
@property (nonatomic) UILabel *mallPriceLabel;
/** 市场价格 */
@property (nonatomic) UILabel *maketPriceLabel;

@end


@implementation ZQProductDetailAttributeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.attributeSelectBtn];
        [self.contentView addSubview:self.mallPriceLabel];
        [self.contentView addSubview:self.maketPriceLabel];
        
        [self layoutWithAuto];
    }
    return self;
}

#pragma mark - Event response

- (void)attributeBtnClick:(UIButton *)button
{
    button.selected = !button.selected;
    [button setBackgroundColor: button.selected ? kSDYAttributeSelectColor : [UIColor whiteColor]];
    
    if (self.attributeBtnClick) {
        self.attributeBtnClick(self.index);
    }
}


#pragma mark - Private methods

- (void)layoutWithAuto
{
    [self.attributeSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft).mas_offset(10);
        } else {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).mas_offset(10);
        }
        make.width.mas_equalTo(100);
    }];
    [self.mallPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.height.equalTo(self.attributeSelectBtn);
        make.left.equalTo(self.attributeSelectBtn.mas_right).mas_offset(20);
    }];
    [self.maketPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.height.width.equalTo(self.mallPriceLabel);
        make.left.equalTo(self.mallPriceLabel.mas_right).mas_offset(20);
        if (@available(iOS 11.0, *)) {
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
        } else {
            make.right.equalTo(self);
        }
    }];
}

#pragma mark - Getter and Setter

- (void)setAttribute:(NSString *)attribute
{
    _attribute = attribute;
    [self.attributeSelectBtn setTitle:_attribute forState:UIControlStateNormal];
}
- (void)setMallPrice:(NSString *)mallPrice
{
    _mallPrice = mallPrice;
    self.mallPriceLabel.text = [NSString stringWithFormat:@"¥ %@元/%@",_mallPrice,self.productUnit];
}
- (void)setMakePrice:(NSString *)makePrice
{
    _makePrice = makePrice;
    //添加中划线
    NSDictionary *attributeDic = @{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *atttibuteString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %@元/%@",_makePrice,self.productUnit] attributes:attributeDic];
    self.maketPriceLabel.attributedText = atttibuteString;
}

- (void)setButtonIsSelected:(BOOL)buttonIsSelected
{
    _buttonIsSelected = buttonIsSelected;
    
    self.attributeSelectBtn.selected = _buttonIsSelected;
    
    [self.attributeSelectBtn setBackgroundColor: self.attributeSelectBtn.selected ? kSDYAttributeSelectColor : [UIColor whiteColor]];
}

- (UIButton *)attributeSelectBtn
{
    if (!_attributeSelectBtn) {
        _attributeSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _attributeSelectBtn.layer.masksToBounds = YES;
        _attributeSelectBtn.layer.cornerRadius = 10;
        _attributeSelectBtn.layer.borderWidth = 0.5;
        _attributeSelectBtn.layer.borderColor = [UIColor grayColor].CGColor;
        [_attributeSelectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_attributeSelectBtn addTarget:self action:@selector(attributeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _attributeSelectBtn.titleLabel.font = [UIFont fontWithName:kZQFontNameBold size:kZQTitleFont];
        _attributeSelectBtn.backgroundColor = [UIColor whiteColor];
    }
    return _attributeSelectBtn;
}

- (UILabel *)mallPriceLabel
{
    if (!_mallPriceLabel) {
        _mallPriceLabel = [[UILabel alloc] init];
        _mallPriceLabel.font = [UIFont fontWithName:kZQFontNameBold size:kZQCellFont];
        _mallPriceLabel.textColor = [UIColor redColor];
        _mallPriceLabel.numberOfLines = 2;
    }
    return _mallPriceLabel;
}

- (UILabel *)maketPriceLabel
{
    if (!_maketPriceLabel) {
        _maketPriceLabel = [[UILabel alloc] init];
        _maketPriceLabel.font = [UIFont systemFontOfSize:kZQCellFont];
        _maketPriceLabel.textColor = [UIColor grayColor];
        _maketPriceLabel.numberOfLines = 2;
    }
    return _maketPriceLabel;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
