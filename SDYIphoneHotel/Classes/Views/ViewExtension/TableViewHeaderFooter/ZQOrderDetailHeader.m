//
//  ZQOrderDetailHeader.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/20.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQOrderDetailHeader.h"
#import "Masonry.h"


@interface ZQOrderDetailHeader ()

/** title   */
@property (nonatomic) UILabel *titleLabel;
/** 展开button */
@property (nonatomic) UIButton *expandBtn;


@end


@implementation ZQOrderDetailHeader


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
        [self layoutWithAuto];
    }
    return self;
}

#pragma mark - Event response

/** 点击展开btnClick */
- (void)expandBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    self.isExpand = !self.isExpand;
    
    if (self.expandClick) {
        self.expandClick(self.isExpand);
    }
}


#pragma mark - private method

- (void)setupUI
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.expandBtn];
}

- (void)layoutWithAuto
{
    //header 会自适应
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.left.equalTo(self).mas_offset(10);
        make.width.mas_equalTo(100);
    }];
    [self.expandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(-10);
        make.top.bottom.width.equalTo(self.titleLabel);
    }];
}

#pragma mark - dealloc

- (void)dealloc
{
    _expandBtn.imageView.transform = CGAffineTransformIdentity;
}


#pragma mark - Getter and Setter

- (void)setIsExpand:(BOOL)isExpand
{
    _isExpand = isExpand;
    if (_isExpand) {
        //旋转180
        self.expandBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        //回归原来的样子
        self.expandBtn.imageView.transform = CGAffineTransformIdentity;
    }
    
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = _title;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:kZQFontNameBold size:kZQTitleFont];
    }
    return _titleLabel;
}

- (UIButton *)expandBtn
{
    if (!_expandBtn) {
        _expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _expandBtn.titleLabel.font = [UIFont fontWithName:kZQFontNameBold size:kZQTitleFont];
        [_expandBtn setTitle:@"商品列表" forState:UIControlStateNormal];
        [_expandBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_expandBtn setImage:[UIImage imageNamed:@"icon_arrow"] forState:UIControlStateNormal];
        [_expandBtn addTarget:self action:@selector(expandBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _expandBtn;
}








@end
