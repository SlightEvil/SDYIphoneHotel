//
//  ZQBaseTextField.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/12.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQBaseTextField.h"

@interface ZQBaseTextField ()

@property (nonatomic) UILabel *titleLabel;


@end

@implementation ZQBaseTextField


- (void)toolbarTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)rightItemClick
{
    [self endEditing:YES];
}

- (UIToolbar *)keyboardTopToolBar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    toolbar.tintColor = [UIColor redColor];
    toolbar.barTintColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"输入" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIBarButtonItem *titleView = [[UIBarButtonItem alloc] initWithCustomView:self.titleLabel];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    
    toolbar.items = @[leftItem,titleView,rightItem];
        
    return toolbar;
}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth*2/3, 40)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont fontWithName:kZQFontNameSystem size:kZQCellFont];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}


@end
