//
//  ZQBaseViewController.m
//  SDYIphoneHotel
//
//  Created by admin on 2017/12/25.
//  Copyright © 2017年 SanDaoyi. All rights reserved.
//

#import "ZQBaseViewController.h"

@interface ZQBaseViewController ()

@end

@implementation ZQBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kZQViewBgColor;

}

- (void)alertTitle:(NSString *)title message:(id)message comple:(CompleBlock)compleClick
{
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *compleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (compleClick) {
            compleClick();
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertCon addAction:compleAction];
    [alertCon addAction:cancelAction];
    [self presentViewController:alertCon animated:YES completion:nil];
}


#pragma mark - Private method

/**  设置普通状态的动画图片 */
- (NSArray *)IdleImageArray
{
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=60; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
        [idleImages addObject:image];
    }
    
    return idleImages;
}
/** 设置即将刷新状态的动画图片（一松开就会刷新的状态)  设置正在刷新状态的动画图片 */
- (NSArray *)PullRefreshingImageAry
{
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }
    return refreshingImages;
}


#pragma mark - Getter and Setter


- (NSArray *)idleImageAry
{
    if (!_idleImageAry) {
        _idleImageAry = [self IdleImageArray];
    }
    return _idleImageAry;
}

- (NSArray *)pullImageAry
{
    if (!_pullImageAry) {
        _pullImageAry = [self PullRefreshingImageAry];
    }
    return _pullImageAry;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
