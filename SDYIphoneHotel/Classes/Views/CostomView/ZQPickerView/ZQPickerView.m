//
//  ZQPickerView.m
//  testPickerView
//
//  Created by admin on 2018/1/27.
//  Copyright © 2018年 MaZhiqiang. All rights reserved.
//

#import "ZQPickerView.h"
#import "ZQOrderRecordModel.h"


#define TopWindow [UIApplication sharedApplication].keyWindow

@interface ZQPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic) UIPickerView *pickerView;

/** callback */
@property (nonatomic, copy) void(^callBack)(NSString *name);
/** 点击的row 的 */
@property (nonatomic) ZQOrderRecordModel *orderRcordModel;
/** 取消button */
@property (nonatomic) UIButton *cancelBtn;
/** 完成button */
@property (nonatomic) UIButton *confirmBtn;
/** 蒙版 */
@property (nonatomic) UIView *beclundView;

/** 标题 */
@property (nonatomic) UILabel *titleLabel;


@end

@implementation ZQPickerView

- (instancetype)init
{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor colorWithRed:(210/255.0) green:(213/255.0) blue:(220/255.0) alpha:1];
        
        [self setViewRadius:self];
        [self setViewRadius:self.cancelBtn];
        [self setViewRadius:self.confirmBtn];
        
    }
    return self;
}


#pragma mark - Public method

- (void)comfirmClickBlock:(void (^)(NSString *))block
{
    self.callBack = block;
}

- (void)show
{
    UIView *beclundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    beclundView.backgroundColor = [UIColor blackColor];
    beclundView.layer.opacity = 0.3;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [beclundView addGestureRecognizer:tap];
    
    [TopWindow addSubview:beclundView];
    self.beclundView = beclundView;
    
    CGRect rect = [UIScreen mainScreen].bounds;
    
    self.frame = CGRectMake(0, 0, rect.size.width, rect.size.height*0.3);
    self.center = CGPointMake(rect.size.width/2, rect.size.height/2);
    
    
    
    self.cancelBtn.frame = CGRectMake(10, 0, 100, 40);
    self.confirmBtn.frame = CGRectMake(rect.size.width - 120, 0, 100, 40);
    self.pickerView.frame = CGRectMake(0, 40, rect.size.width, self.bounds.size.height-40);
    
    [self addSubview:self.cancelBtn];
    [self addSubview:self.confirmBtn];
    [self addSubview:self.pickerView];
    [TopWindow addSubview:self];
}

- (void)dismiss
{
    [self removeFromSuperview];
    [self.beclundView removeFromSuperview];
}


#pragma mark - Private method

- (void)cancelBtnCLick
{
    [self dismiss];
}

- (void)confirmBtnClick
{
    [self dismiss];
    if (self.callBack) {
        self.callBack(self.orderRcordModel.template_name);
    }
}


- (void)setViewRadius:(UIView *)view
{
    view.layer.cornerRadius = 5.0;
    view.layer.masksToBounds = YES;
}

#pragma mark - Delegate

/** UIPickerViewDataSource */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataSource.count;
}

/** UIPickerViewDelegate */

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [UIScreen mainScreen].bounds.size.width;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 49;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    ZQOrderRecordModel *orderReocrd = self.dataSource[row];
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = orderReocrd.template_name;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.orderRcordModel = self.dataSource[row];
}

#pragma mark - Getter and Setter

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    self.orderRcordModel = dataSource[0];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"选择模板";
    }
    return _titleLabel;
}

- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _cancelBtn .backgroundColor  = [UIColor whiteColor];
        [_cancelBtn addTarget:self action:@selector(cancelBtnCLick) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.layer.borderWidth = 1;
        _cancelBtn.layer.borderColor = [UIColor colorWithRed:(184/255.0) green:(184/255.0) blue:(184/255.0) alpha:1].CGColor;
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _confirmBtn .backgroundColor  = [UIColor whiteColor];
        [_confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.layer.borderWidth = 1;
        _confirmBtn.layer.borderColor = [UIColor colorWithRed:(184/255.0) green:(184/255.0) blue:(184/255.0) alpha:1].CGColor;
    }
    return _confirmBtn;
}



@end
