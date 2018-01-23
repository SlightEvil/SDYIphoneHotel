//
//  ZQQuantityTextField.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/12.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQQuantityTextField.h"
#import "UIImage+Cagegory.h"

@interface ZQQuantityTextField ()<UITextFieldDelegate>


@property (nonatomic) UIButton *reductionBtn;

@property (nonatomic) UIButton *addBtn;


@end

@implementation ZQQuantityTextField
{
    CGFloat _height;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
       
        _height = frame.size.height;
        
//        self.borderStyle = UITextBorderStyleRoundedRect;
        self.layer.borderWidth = 0.7;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.delegate = self;
        self.textAlignment = NSTextAlignmentCenter;
        self.inputAccessoryView = [self keyboardTopToolBar];
        self.keyboardType = UIKeyboardTypeNumberPad;
//        self.keyboardType = UIKeyboardTypeDecimalPad;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.rightViewMode = UITextFieldViewModeAlways;
        
        self.leftView = self.reductionBtn;
        self.rightView = self.addBtn;
        self.text = @"1";
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *titleText = @"";
    BOOL isYes = YES;
    
    if ([string isEqualToString:@""]) {
        if (textField.text.length == 0 || textField.text.length == 1) {
            textField.text = @"0";
            titleText = @"0";
//            isYes = NO;
        } else {
            titleText = [textField.text substringToIndex:textField.text.length -1];
        }
    } else {
        NSInteger maxNumber = (self.maxNumber || self.maxNumber == 0) ? 500 : self.maxNumber;
        NSString *textText = [textField.text stringByAppendingString:string];
        if ([textText integerValue] >= maxNumber) {
            textField.text = [NSString stringWithFormat:@"%zd",maxNumber];
            titleText = [NSString stringWithFormat:@"%zd",maxNumber];
            isYes = NO;
        } else {
            titleText = [textField.text stringByAppendingString:string];
        }
    }
    
    [self toolbarTitle:titleText];
    return isYes;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *titleText = @"";
    if (textField.text.length == 0 || [textField.text isEqualToString:@"0"]) {
        textField.text = @"1";
        titleText = @"1";
    }
    [self toolbarTitle:titleText];
    
    if ([textField.text integerValue] > 1) {
        self.reductionBtn.enabled = NO;
        self.addBtn.enabled = YES;
    }
    if ([textField.text integerValue] >= 500) {
        self.reductionBtn.enabled = YES;
        self.addBtn.enabled  = NO;
    }
}

/** 减去 */
- (void)reductionBtnClick
{
    self.text = [NSString stringWithFormat:@"%zd",([self.text integerValue]-1)];
    NSInteger textNumber = [self.text integerValue];
    if (textNumber == 1) {
        self.reductionBtn.enabled = NO;
    }
    self.addBtn.enabled = YES;
}

- (void)addBtnClick
{
    self.text = [NSString stringWithFormat:@"%zd",([self.text integerValue])+1];
    NSInteger textNumber = [self.text integerValue];
    NSInteger maxNumber = (self.maxNumber != 0 || self.maxNumber) ? self.maxNumber : 500;
    if (textNumber >= maxNumber) {
        self.addBtn.enabled = NO;
    }
    self.reductionBtn.enabled = YES;
}

- (void)setTextQuantity:(NSString *)textQuantity
{
    _textQuantity = textQuantity;
    self.text = _textQuantity;
    if ([_textQuantity integerValue] > 1) {
        self.reductionBtn.enabled = YES;
        self.addBtn.enabled = YES;
    }
    if ([_textQuantity integerValue] == 1) {
        self.reductionBtn.enabled = NO;
        self.addBtn.enabled = YES;
    }
}



- (UIButton *)reductionBtn
{
    if (!_reductionBtn) {
        _reductionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reductionBtn.frame = CGRectMake(0, 0, _height, _height);
        [_reductionBtn setImage:[UIImage sizeImageWithImage:[UIImage imageNamed:@"icon_subtract"] sizs:CGSizeMake(_height, _height)] forState:UIControlStateNormal];
        [_reductionBtn addTarget:self action:@selector(reductionBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _reductionBtn.enabled = NO;
        _reductionBtn.layer.borderWidth = 0.7;
        _reductionBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    }
    return _reductionBtn;
}

- (UIButton *)addBtn
{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.frame = CGRectMake(0, 0, _height, _height);
        [_addBtn setImage:[UIImage sizeImageWithImage:[UIImage imageNamed:@"icon_add"] sizs:CGSizeMake(_height, _height)] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.layer.borderWidth = 0.7;
        _addBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    }
    return _addBtn;
}

@end
