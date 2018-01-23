//
//  ZQCostomView.m
//  SDYIphoneHotel
//
//  Created by admin on 2017/12/26.
//  Copyright © 2017年 SanDaoyi. All rights reserved.
//

#import "ZQCostomView.h"

@interface ZQCostomView ()

/** 菊花 */
@property (nonatomic) UIActivityIndicatorView *activity;
/** 黑色背景蒙版 */
@property (nonatomic) UIView *blackBgView;

@property (nonatomic) UILabel *label;




@end

@implementation ZQCostomView





#pragma mark - 加载菊花

- (void)showActivity
{
    [self.blackBgView.superview removeFromSuperview];
    [self.activity startAnimating];
    [self.blackBgView addSubview:self.activity];
    [[UIApplication sharedApplication].keyWindow addSubview:self.blackBgView];
}
- (void)hiddeActivity
{
    if ([self.activity isAnimating]) {
        [self.activity stopAnimating];
    }
    [self.activity removeFromSuperview];
    [self.blackBgView removeFromSuperview];
}

#pragma mark - 显示文字

- (void)showTitle:(NSString *)title
{
    
    [self.blackBgView.superview removeFromSuperview];
    
    self.label.text = title;
    [self.label sizeToFit];
    
    CGRect frame = self.label.frame;
    frame.size.width = self.label.frame.size.width + 20;
    frame.size.height = self.label.frame.size.height +10;
    self.label.frame = frame;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.center = self.blackBgView.center;

    [self.blackBgView addSubview:self.label];
    [[UIApplication sharedApplication].keyWindow addSubview:self.blackBgView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.blackBgView removeFromSuperview];
    });
    
}


#pragma mark - Getter and Setter

- (UIActivityIndicatorView *)activity
{
    if (!_activity) {
        _activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activity.hidesWhenStopped = YES;
        _activity.center = [UIApplication sharedApplication].keyWindow.center;
    }
    return _activity;
}

- (UIView *)blackBgView
{
    if (!_blackBgView) {
        _blackBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _blackBgView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    }
    return _blackBgView;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:16];
        _label.textColor = [UIColor blackColor];
        _label.layer.borderWidth = 0.5;
        _label.layer.borderColor = [UIColor grayColor].CGColor;
        _label.layer.masksToBounds = YES;
        _label.layer.cornerRadius = 10;
    }
    return _label;
}

@end
