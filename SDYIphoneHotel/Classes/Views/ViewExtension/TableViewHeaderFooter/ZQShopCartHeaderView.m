//
//  ZQShopCartHeaderView.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/22.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQShopCartHeaderView.h"
#import "Masonry.h"


@interface ZQShopCartHeaderView ()

/** 显示title */
@property (nonatomic) UILabel *titleLabel;
/** 显示备注输入框的button */
@property (nonatomic) UIButton *showRemarkViewBtn;

@end


@implementation ZQShopCartHeaderView


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self layoutWithAuto];
    }
    return self;
}

- (void)showRemarkViewBtnClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showAlertRemarkViewBtnClickIndex:)]) {
        [self.delegate showAlertRemarkViewBtnClickIndex:self.index];
    }
}

- (void)setupUI
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.showRemarkViewBtn];
}

- (void)layoutWithAuto
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).mas_offset(10);
        make.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
    [self.showRemarkViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).mas_offset(-20);
        make.width.mas_equalTo(80);
    }];
}

- (void)setTitleStr:(NSString *)titleStr
{
    _titleStr = titleStr;
    self.titleLabel.text = _titleStr;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:kZQFontNameBold size:kZQTitleFont];
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UIButton *)showRemarkViewBtn
{
    if (!_showRemarkViewBtn) {
        _showRemarkViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showRemarkViewBtn setTitle:@"输入备注" forState:UIControlStateNormal];
        _showRemarkViewBtn.titleLabel.font = [UIFont fontWithName:kZQFontNameBold size:kZQTitleFont];
        [_showRemarkViewBtn setTitleColor:kZQBlackColor forState:UIControlStateNormal];
        [_showRemarkViewBtn addTarget:self action:@selector(showRemarkViewBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showRemarkViewBtn;
}




@end
