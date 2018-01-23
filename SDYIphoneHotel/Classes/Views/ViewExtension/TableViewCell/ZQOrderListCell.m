//
//  ZQOrderListCell.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/19.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQOrderListCell.h"
#import "Masonry.h"
#import "ZQMyOrderListModel.h"


@interface ZQOrderListCell ()

/** 供应商 */
@property (nonatomic) UILabel *shopNameLabel;
/** 创建时间 */
@property (nonatomic) UILabel *createTimeLabel;
/** 订单号  */
@property (nonatomic) UILabel *tradeNoLabel;
/** 订单状态 */
@property (nonatomic) UILabel *statusLabel;
/** 确认收货 默认隐藏 只有待收货才显示  */
@property (nonatomic) UIButton *comfirmReceiveBtn;


@end

@implementation ZQOrderListCell

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


#pragma mark - Event response
/** 确认收货click */
- (void)comfirmReceiveBtnClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(orderListCellReceiveClick:)]) {
        [self.delegate orderListCellReceiveClick:self.indexPath];
    }
}


- (void)setupUI
{
    [self.contentView addSubview:self.shopNameLabel];
    [self.contentView addSubview:self.createTimeLabel];
    [self.contentView addSubview:self.tradeNoLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.comfirmReceiveBtn];
}
- (void)layoutWithAuto
{
    [self.shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(5);
        make.left.equalTo(self).mas_offset(10);
//        make.right.equalTo(self).mas_offset(-10);
        make.height.mas_equalTo(30);
//        make.width.mas_equalTo(150);
    }];
    [self.createTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.shopNameLabel);
        make.width.equalTo(self.shopNameLabel);
        make.right.equalTo(self).mas_offset(-10);
    }];
    [self.shopNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.createTimeLabel);
    }];
    [self.tradeNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shopNameLabel.mas_bottom);
        make.left.equalTo(self).mas_offset(10);
        make.right.equalTo(self).mas_offset(-10);
        make.height.equalTo(self.shopNameLabel);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tradeNoLabel.mas_bottom).mas_offset(2);
        make.left.equalTo(self.tradeNoLabel);
        make.width.mas_equalTo(120);
        make.height.equalTo(self.tradeNoLabel);
        
    }];
    [self.comfirmReceiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusLabel);
        make.right.equalTo(self.tradeNoLabel);
        make.height.equalTo(self.statusLabel);
        make.width.equalTo(self.statusLabel);
    }];
}

#pragma mark - Getter and Setter

- (void)setOrderListModel:(ZQMyOrderListModel *)orderListModel
{
    _orderListModel = orderListModel;
    
    self.shopNameLabel.text = _orderListModel.shop_name;
    self.createTimeLabel.text = _orderListModel.created_at;
    self.tradeNoLabel.text = _orderListModel.order_no;
    
    switch ([_orderListModel.status integerValue]) {
        case 0:
        {
            self.statusLabel.text = @"已提交";
            self.comfirmReceiveBtn.hidden = YES;
        }
            break;
        case 1:
        {
//            self.statusLabel.text = @"待配送";
            self.statusLabel.text = @"已提交";
            self.comfirmReceiveBtn.hidden = YES;
        }
            break;
        case 2:
        {
            self.statusLabel.text = @"待收货";
            self.comfirmReceiveBtn.hidden = NO;
        }
            break;
        case 3:
        {
            self.statusLabel.text = @"已完成";
            self.comfirmReceiveBtn.hidden = YES;
        }
            break;
        default:
            break;
    }
}

- (UILabel *)shopNameLabel
{
    if (!_shopNameLabel) {
        _shopNameLabel = [UILabel new];
        _shopNameLabel.font = [UIFont fontWithName:kZQFontNameBold size:kZQTitleFont];
    }
    return _shopNameLabel;
}

- (UILabel *)createTimeLabel
{
    if (!_createTimeLabel) {
        _createTimeLabel = [UILabel new];
        _createTimeLabel.font = [UIFont fontWithName:kZQFontNameBold size:kZQDetailFont];
        _createTimeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _createTimeLabel;
}

- (UILabel *)tradeNoLabel
{
    if (!_tradeNoLabel) {
        _tradeNoLabel = [UILabel new];
        _tradeNoLabel.font = [UIFont fontWithName:kZQFontNameBold size:kZQDetailFont];
    }
    return _tradeNoLabel;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [UILabel new];
        _statusLabel.font = [UIFont fontWithName:kZQFontNameBold size:kZQDetailFont];
        _statusLabel.textColor = kZQDetailViewTextColor;
    }
    return _statusLabel;
}
- (UIButton *)comfirmReceiveBtn
{
    if (!_comfirmReceiveBtn) {
        _comfirmReceiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_comfirmReceiveBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        [_comfirmReceiveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _comfirmReceiveBtn.titleLabel.font = [UIFont fontWithName:kZQFontNameBold size:kZQTitleFont];
        _comfirmReceiveBtn.layer.borderColor = [UIColor blackColor].CGColor;
        _comfirmReceiveBtn.layer.borderWidth = 1;
        _comfirmReceiveBtn.layer.cornerRadius = 10;
        _comfirmReceiveBtn.layer.masksToBounds = YES;
        [_comfirmReceiveBtn addTarget:self action:@selector(comfirmReceiveBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _comfirmReceiveBtn.hidden = YES;
    }
    return _comfirmReceiveBtn;
}



@end
