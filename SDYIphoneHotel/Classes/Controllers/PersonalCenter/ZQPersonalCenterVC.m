//
//  ZQPersonalCenterVC.m
//  SDYIphoneHotel
//
//  Created by admin on 2017/12/25.
//  Copyright © 2017年 SanDaoyi. All rights reserved.
//

#import "ZQPersonalCenterVC.h"
#import "ZQLoginVC.h"
#import "UIImage+Cagegory.h"
#import "ZQMoneyCenterVC.h"


static NSString *const personalCellIdentifier = @"SDYPersonalCenterVCCellIdentifier";
static NSString *const personalFirstCellIdentifier = @"SDYPersonalCenterVCpersonalFirstCellIdentifier";
static NSString *const personalFooterIdentifier = @"SDYPersonalCenterVCpersonalFooterIdentifier";

@interface ZQPersonalCenterVC ()<UITableViewDelegate,UITableViewDataSource>



@property (nonatomic) UITableView *personalTableView;
/** 数据源 */
@property (nonatomic) NSMutableArray *dataSource;
/** 个人中心设置 */
@property (nonatomic) UIImageView *tableHeaderView;
/** 头像 */
@property (nonatomic) UIImageView *headProtraitImageView;
/** 登录 */
@property (nonatomic) UIButton *loginButton;
/** 登录之后显示用户名 */
@property (nonatomic) UILabel *userNameLabel;
/** 退出登录 */
@property (nonatomic) UIView *loginOutBtn;


@end

/*
 个人信息
 流水记录
 退出登录
 */

@implementation ZQPersonalCenterVC
{
    CGFloat _width;
    CGFloat _height;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人中心";
    
    _width = self.view.width;
    _height = self.view.height;
    
    [self.view addSubview:self.personalTableView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self isLoginSetupUI];
}


#pragma mark - Delegate   代理方法

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!AppCT.isUserLogin) {
        [AppCT showLoginVC];
        return;
    }
    
    if (indexPath.row == 0) [self cellMyMondyClick];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    __weak typeof(self)weakSelf = self;
//    __strong typeof(weakSelf)strongSelf = weakSelf;
//    PersonalFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:personalFooterIdentifier];
//    footer.buttonClick = ^{
//        [strongSelf registerLoginButtonClick];
//    };
//
//    return footer;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:personalCellIdentifier forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}


#pragma mark - Event response  事件响应链

/** 登录 */
- (void)loginButtonClick
{
    [AppCT showLoginVC];
}

/**
 退出登录
 */
- (void)registerLoginButtonClick
{
    if (AppCT.isUserLogin) {
        
        __weak typeof(self)weakSelf = self;
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [self alertTitle:@"是否退出登录" message:nil comple:^{
            [AppCT.networkServices GET:kAPIURLLoginOut parameter:@{} success:^(NSDictionary *dictionary) {
                
                NSInteger requestStatus = [dictionary[status] integerValue];
                if (requestStatus != 0) {
                    [SVProgressHUD showErrorWithStatus:dictionary[message]];
                    [SVProgressHUD dismissWithDelay:1.0];
                    return ;
                }
                [SVProgressHUD showSuccessWithStatus:dictionary[message]];
                [SVProgressHUD dismissWithDelay:1.0];
                AppCT.userLogin = NO;
                AppCT.loginUser = [ZQLoginUser new];
                [strongSelf isLoginSetupUI];
                
            } fail:^(NSString *errorDescription) {
                
            }];
        }];
    }
}

/** 点击tableview 头部 图片 */
- (void)tableHeaderViewClick:(UITapGestureRecognizer *)gesture
{
    NSLog(@"图片view 互动");
}


/** 财务中心 */
- (void)cellMyMondyClick
{
    ZQMoneyCenterVC *moneyVC = [[ZQMoneyCenterVC alloc] init];
    moneyVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:moneyVC animated:YES];
}

/** 我的订单 */
- (void)cellMyOrderClick
{
    self.tabBarController.selectedIndex = 3;
}

#pragma mark - Private method  私有方法

/** 根据登录状态设置 */
- (void)isLoginSetupUI
{
    if (AppCT.isUserLogin) {
        self.loginButton.hidden = YES;
        self.userNameLabel.hidden = NO;
        self.userNameLabel.text = AppCT.loginUser.user_name;
    } else {
        self.loginButton.hidden = NO;
        self.userNameLabel.hidden = YES;
    }
}

#pragma mark - Getter and Setter


- (UITableView *)personalTableView
{
    if (!_personalTableView) {
        _personalTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _personalTableView.delegate = self;
        _personalTableView.dataSource = self;
        
        _personalTableView.tableHeaderView = self.tableHeaderView;
        _personalTableView.tableFooterView = self.loginOutBtn;
        
        [_personalTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:personalCellIdentifier];

    }
    return _personalTableView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithObjects:@"我的资金", nil];
    }
    return _dataSource;
}

- (UIImageView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
        _tableHeaderView.image = [UIImage sizeImageWithImage:[UIImage imageNamed:@"background"] sizs:CGSizeMake(kScreenWidth, 120)];
        //userInteractionEnabled 开启用户互动
        _tableHeaderView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tableHeaderViewClick:)];
        [_tableHeaderView addGestureRecognizer:tap];
        
        CGRect frame = self.headProtraitImageView.frame;
        frame.origin = CGPointMake(kScreenWidth/2-100, 20);
        self.headProtraitImageView.frame = frame;
        [_tableHeaderView addSubview:self.headProtraitImageView];
        
        frame = self.loginButton.frame;
        frame.origin = CGPointMake(kScreenWidth/2, 40);
        self.loginButton.frame = frame;
        [_tableHeaderView addSubview:self.loginButton];
        
        self.userNameLabel.frame = self.loginButton.frame;
        [_tableHeaderView addSubview:self.userNameLabel];
        
    }
    return _tableHeaderView;
}

- (UIImageView *)headProtraitImageView
{
    if (!_headProtraitImageView) {
        _headProtraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _headProtraitImageView.layer.masksToBounds = YES;
        _headProtraitImageView.layer.cornerRadius = 10;
        _headProtraitImageView.image = [UIImage sizeImageWithImage:[UIImage imageNamed:@"icon_account"] sizs:CGSizeMake(60, 60)];
    }
    return _headProtraitImageView;
}

- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _loginButton.frame = CGRectMake(0, 0, 160, 40);
    }
    return _loginButton;
}

- (UIView *)loginOutBtn
{
    if (!_loginOutBtn) {
        _loginOutBtn = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        _loginOutBtn.backgroundColor = [UIColor whiteColor];
        UIButton *loginOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        loginOutBtn.frame = CGRectMake(40, 0, kScreenWidth-80, 50);
        [loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [loginOutBtn setTitleColor:kZQTabbarTintColor forState:UIControlStateNormal];
        [loginOutBtn addTarget:self action:@selector(registerLoginButtonClick) forControlEvents:UIControlEventTouchUpInside];
        loginOutBtn.backgroundColor = [UIColor colorWithRed:(248/255.0) green:(248/255.0) blue:(248/255.0) alpha:1];
        [_loginOutBtn addSubview:loginOutBtn];
    }
    return _loginOutBtn;
}

- (UILabel *)userNameLabel
{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] initWithFrame:self.loginButton.frame];
        _userNameLabel.font = [UIFont systemFontOfSize:16];
        _userNameLabel.textColor = [UIColor blackColor];
        _userNameLabel.hidden = YES;
    }
    return _userNameLabel;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
