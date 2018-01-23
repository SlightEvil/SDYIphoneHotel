//
//  ZQOrderDetailTableFooter.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/20.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQOrderDetailTableFooter.h"
#import "Masonry.h"
#import "ZQMyOrderListModel.h"


@interface ZQOrderDetailTableFooter ()

/** 订单的状态 */
@property (nonatomic) UILabel *statusLabel;
/** 确认收货 */
//@property (nonatomic) UIButton *receiveBtn;
/** 订单号 */
@property (nonatomic) UILabel *tradeNoLabel;
/** 创建时间 */
@property (nonatomic) UILabel *createAtLabel;
/** 备注 */
@property (nonatomic) UITextView *remarkTextView;


@end



@implementation ZQOrderDetailTableFooter


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
        [self layoutWithAuto];
    }
    return self;
}


#pragma mark - Event response


#pragma mark - private method

- (void)setupUI
{
    [self addSubview:self.statusLabel];
//    [self addSubview:self.receiveBtn];
    [self addSubview:self.tradeNoLabel];
    [self addSubview:self.createAtLabel];
    [self addSubview:self.remarkTextView];
}
- (void)layoutWithAuto
{
    /*
     高度  35  35*3   115 120 130   180
     */
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).mas_offset(5);
        make.left.equalTo(self).mas_offset(10);
        make.height.mas_equalTo(35);
        make.right.equalTo(self).mas_offset(-10);
    }];
    [self.tradeNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusLabel.mas_bottom);
        make.left.right.height.equalTo(self.statusLabel);
    }];
    [self.createAtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tradeNoLabel.mas_bottom);
        make.left.right.height.equalTo(self.tradeNoLabel);
    }];
    [self.remarkTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.createAtLabel.mas_bottom);
        make.left.right.equalTo(self.createAtLabel);
        make.height.mas_equalTo(60);
    }];
}


- (UILabel *)defaultLabel
{
    UILabel *label = [UILabel new];
    label.font = [UIFont fontWithName:kZQFontNameSystem size:kZQCellFont];
    return label;
}


#pragma mark - Getter and Setter

- (void)setOrderModel:(ZQMyOrderListModel *)orderModel
{
    _orderModel = orderModel;
    
    self.tradeNoLabel.text = [NSString stringWithFormat:@"订单号： %@",_orderModel.order_no];
    self.createAtLabel.text = [NSString stringWithFormat:@"下单时间： %@",_orderModel.created_at];
    self.remarkTextView.text = [NSString stringWithFormat:@"备注： %@",_orderModel.content];
    
    switch ([_orderModel.status integerValue]) {
        case 0:
            self.statusLabel.text = @"订单状态： 已提交";
            break;
        case 1:
            self.statusLabel.text = @"订单状态： 已提交";
            break;
        case 2:
            self.statusLabel.text = @"订单状态： 待收货";
            break;
        case 3:
            self.statusLabel.text = @"订单状态： 已完成";
            break;
        default:
            break;
    }
}

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [self defaultLabel];
        _statusLabel.text = @"订单状态： ";
    }
    return _statusLabel;
}

- (UILabel *)tradeNoLabel
{
    if (!_tradeNoLabel) {
        _tradeNoLabel = [self defaultLabel];
        _tradeNoLabel.text = @"订单号： ";
    }
    return _tradeNoLabel;
}

- (UILabel *)createAtLabel
{
    if (!_createAtLabel) {
        _createAtLabel = [self defaultLabel];
        _createAtLabel.text = @"下单时间： ";
    }
    return _createAtLabel;
}

- (UITextView *)remarkTextView
{
    if (!_remarkTextView) {
        _remarkTextView = [[UITextView alloc] init];
        _remarkTextView.font = [UIFont fontWithName:kZQFontNameSystem size:kZQDetailFont];
        _remarkTextView.editable = NO;
        _remarkTextView.selectable = NO;
        _remarkTextView.backgroundColor = kUIColorFromRGB(0xf0f0f0);
    }
    return _remarkTextView;
}

@end
