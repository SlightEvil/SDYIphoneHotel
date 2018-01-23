//
//  ZQOrderDetailFooter.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/20.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQOrderDetailFooter.h"
#import "Masonry.h"


@interface ZQOrderDetailFooter ()

/** 供应商 */
//@property (nonatomic) UILabel *shopNameLabel;
///** 创建时间 */
//@property (nonatomic) UILabel *createAtLabel;
/** 总价 */
@property (nonatomic) UILabel *totalPriceLabel;
/** 订单号 */
//@property (nonatomic) UILabel *tradeNoLabel;
/** 订单状态 */
//@property (nonatomic) UILabel *statusLabel;
///** 备注 */
//@property (nonatomic) UILabel *remarkLabel;
///** 确认收货button 限制：在配送订单，待收货状态显示 */
//@property (nonatomic) UILabel *reveiceBtn;

/** 总计标题 */
@property (nonatomic) UILabel *totalPrice;

@end

@implementation ZQOrderDetailFooter
{
    /** label 的高度  30 */
    CGFloat _height;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        _height = 30.0;
        [self setupUI];
        [self layoutWithAuto];
    }
    return self;
}


#pragma mark - Private method

- (void)setupUI
{    
    [self.contentView addSubview:self.totalPrice];
    [self.contentView addSubview:self.totalPriceLabel];
}
- (void)layoutWithAuto
{
    [self.totalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(self).mas_offset(10);
    }];
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.width.equalTo(self.totalPrice);
        make.right.equalTo(self).mas_offset(-10);
    }];
    [self.totalPrice mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.totalPriceLabel);
    }];
}

- (UILabel *)defaultLabel
{
    UILabel *label = [UILabel new];
    label.font = [UIFont fontWithName:kZQFontNameBold size:14];
    return label;
}

#pragma mark - Getter and Setter

- (void)setTotalPriceStr:(NSString *)totalPriceStr
{
    _totalPriceStr = totalPriceStr;
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%@",_totalPriceStr];
}

- (UILabel *)totalPrice
{
    if (!_totalPrice) {
        _totalPrice = [self defaultLabel];
        _totalPrice.text = @"总计:";
    }
    return _totalPrice;
}
- (UILabel *)totalPriceLabel
{
    if (!_totalPriceLabel) {
        _totalPriceLabel = [self defaultLabel];
        _totalPriceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _totalPriceLabel;
}


@end
