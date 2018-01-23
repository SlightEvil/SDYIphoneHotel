//
//  ZQBaseNavCon.m
//  SDYIphoneHotel
//
//  Created by admin on 2017/12/25.
//  Copyright © 2017年 SanDaoyi. All rights reserved.
//

#import "ZQBaseNavCon.h"

@interface ZQBaseNavCon ()

@end

@implementation ZQBaseNavCon

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setTranslucent:NO];
    self.navigationBar.barTintColor = kZQTabbarTintColor;
    self.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
  
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
