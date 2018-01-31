//
//  ZQAddNewOrderRecordV.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/25.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQAddNewOrderRecordV.h"


@interface ZQAddNewOrderRecordV ()


/** title label */
@property (nonatomic) UILabel *titleLabel;
/** 取消button */
@property (nonatomic) UIButton *cancelBtn;
/** 确认button */
@property (nonatomic) UIButton *confirmBtn;
/** 描述textView */
@property (nonatomic) UITextView *describeTextView;
/** 新增订单收藏的名称 */
@property (nonatomic) UITextField *orderRecordNameTextField;
/** name label */
@property (nonatomic) UILabel *nameLabel;
/** 描述 label */
@property (nonatomic) UILabel *describeLabel;

/** 蒙版 */
@property (nonatomic) UIView *becloudView;


@end


@implementation ZQAddNewOrderRecordV


- (instancetype)init
{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self setBtnEnadle];
        self.isNeedDescribe = YES;
        
        [self setViewRadius:self.orderRecordNameTextField];
        [self setViewRadius:self.describeTextView];
        [self setViewRadius:self.confirmBtn];
        
        self.describeTextView.layer.borderWidth = 1;
        self.describeTextView.layer.borderColor = [UIColor colorWithRed:(184/255.0) green:(184/255.0) blue:(184/255.0) alpha:1].CGColor;
        
        self.orderRecordNameTextField.layer.borderWidth = 1;
        self.orderRecordNameTextField.layer.borderColor = [UIColor colorWithRed:(184/255.0) green:(184/255.0) blue:(184/255.0) alpha:1].CGColor;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotificaton) name:UITextFieldTextDidChangeNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotificaton) name:UITextViewTextDidChangeNotification object:nil];
        
    }
    return self;
}

#pragma mark - Event response

/** 名称  textfield  textview 文字发生改变通知 */
- (void)textFieldTextDidChangeNotificaton
{
    /**  name  有值 */
    BOOL textFieldValue = self.orderRecordNameTextField.text.length != 0;
    /** 名称  和描述都有值   */
    BOOL textFieldDescribeValue = self.orderRecordNameTextField.text.length != 0 && self.describeTextView.text.length != 0;
    
    /** 是否需要描述 默认需要 */
    if (self.isNeedDescribe ? textFieldDescribeValue : textFieldValue) {
        
        self.confirmBtn.enabled = YES;
        self.confirmBtn.backgroundColor = [UIColor redColor];
        self.confirmBtn.layer.opacity = 0.5;
    } else {
        [self setBtnEnadle];
    }
}

/** 取消buttonCLick */
- (void)cancelButtonClick
{
    [self dismiss];
    [self clearData];
}
/** 确定click */
- (void)confirmButtonClick
{
    [self dismiss];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmButtonClickAction:describe:)]) {
        [self.delegate confirmButtonClickAction:self.orderRecordNameTextField.text describe:self.describeTextView.text];
    }
    [self clearData];
    
}
/** 蒙版点击 */
- (void)beclundViewClick
{
    [self endEditing:YES];
}


#pragma mark - Private method
/** 设置button 无效 */
- (void)setBtnEnadle
{
    self.confirmBtn.enabled = NO;
    self.confirmBtn.backgroundColor = [UIColor lightGrayColor];
    self.confirmBtn.layer.opacity = 0.5;
}

- (void)setViewRadius:(UIView *)view
{
    view.layer.cornerRadius = 5.0;
    view.layer.masksToBounds = YES;
}


- (void)show
{
    [TopWindow addSubview:self.becloudView];
    
    self.frame = CGRectMake(0, 0, self.becloudView.bounds.size.width*0.8, self.becloudView.bounds.size.height *0.4);
    self.center = CGPointMake(self.becloudView.center.x, self.becloudView.bounds.size.height *0.4);
    
    [TopWindow addSubview:self];
    
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.nameLabel];
    [self addSubview:self.orderRecordNameTextField];
    [self addSubview:self.describeLabel];
    [self addSubview:self.describeTextView];
    [self addSubview:self.confirmBtn];
    
    
    self.titleLabel.frame = CGRectMake(30, 0, self.bounds.size.width-60, 35);
    self.cancelBtn.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, 30, 30);
    self.nameLabel.frame = CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame)+5, 60, 35);
    self.orderRecordNameTextField.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame), CGRectGetMaxY(self.titleLabel.frame)+5, self.bounds.size.width-CGRectGetMaxX(self.nameLabel.frame)-10, 35);
    self.describeLabel.frame = CGRectMake(10, CGRectGetMaxY(self.orderRecordNameTextField.frame)+5, self.bounds.size.width-20, 35);
    self.describeTextView.frame = CGRectMake(10, CGRectGetMaxY(self.describeLabel.frame)+5, self.describeLabel.bounds.size.width, self.bounds.size.height - 180);
    self.confirmBtn.frame = CGRectMake(10, CGRectGetMaxY(self.describeTextView.frame)+5, self.describeTextView.bounds.size.width, 40);
    
}

- (void)dismiss
{
    [self removeFromSuperview];
    [self.becloudView removeFromSuperview];
}

- (void)clearData
{
    self.orderRecordNameTextField.text = @"";
    self.describeTextView.text = @"";
    _nameString = @"";
    _describeString = @"";
    [self setBtnEnadle];
}

#pragma mark - Getter and Setter

- (void)setNameString:(NSString *)nameString
{
    _nameString = nameString;
    self.orderRecordNameTextField.text = _nameString;
    [self textFieldTextDidChangeNotificaton];
}

- (void)setDescribeString:(NSString *)describeString
{
    _describeString = describeString;
    self.describeTextView.text = _describeString;
    [self textFieldTextDidChangeNotificaton];
}


- (UIView *)becloudView
{
    if (!_becloudView) {
        UIView *becludView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        becludView.backgroundColor = [UIColor blackColor];
        becludView.layer.opacity = 0.5;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beclundViewClick)];
        [becludView addGestureRecognizer:tap];
        _becloudView = becludView;
    }
 
    return _becloudView;
}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"新增订单模板";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.text = @"名称:";
    }
    return _nameLabel;
}
- (UILabel *)describeLabel
{
    if (!_describeLabel) {
        _describeLabel = [UILabel new];
        _describeLabel.text = @"描述:";
    }
    return _describeLabel;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UITextField *)orderRecordNameTextField
{
    if (!_orderRecordNameTextField) {
        _orderRecordNameTextField = [[UITextField alloc] init];
        _orderRecordNameTextField.font = [UIFont systemFontOfSize:kZQTitleFont];
        _orderRecordNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _orderRecordNameTextField;
}

- (UITextView *)describeTextView
{
    if (!_describeTextView) {
        _describeTextView = [[UITextView alloc] init];
        _describeTextView.font = [UIFont systemFontOfSize:kZQTitleFont];
    }
    return _describeTextView;
}




@end
