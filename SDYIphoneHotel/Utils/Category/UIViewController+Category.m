//
//  UIViewController+Category.m
//  SDYHotel
//
//  Created by admin on 2017/12/13.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "UIViewController+Category.h"


@implementation UIViewController (Category)


- (void)alertTitle:(NSString *)title message:(id)message complete:(void(^)(void))completeBlock
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *completeAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (completeBlock) {
            completeBlock();
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:completeAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
