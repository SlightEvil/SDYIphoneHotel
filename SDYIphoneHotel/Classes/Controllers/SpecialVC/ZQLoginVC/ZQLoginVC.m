//
//  ZQLoginVC.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/11.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQLoginVC.h"
#import "UIButton+Category.h"
#import "UIImage+Cagegory.h"
#import "ZQProductDetailModel.h"
#import <MJExtension/MJExtension.h>

@interface ZQLoginVC ()<UITextFieldDelegate>

/** 取消button */
@property (nonatomic) UIButton *cancelBtn;
/** 登录 */
@property (nonatomic) UIButton *loginBtn;
/** 注册 */
@property (nonatomic) UIButton *registerBtn;

/** 用户名 */
@property (nonatomic) UITextField *userTextField;
/** 密码 */
@property (nonatomic) UITextField *passwordTextField;

/** 标题为 */
@property (nonatomic) UILabel *titleLabel;


@end

@implementation ZQLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Add_Observer(kZQLoginSuccessRequestRecordListNotification, @selector(loginSuccessRequestRecordListNotification:));
    
    [self setupUI];
    [self layoutWithAuto];
    
    if (!self.type) {
        self.type = ZQLoginVCTypeLogin;
        //隐藏注册功能
        self.registerBtn.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark - Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        
        if (textField.tag == 10) {
            [self.passwordTextField becomeFirstResponder];
        }
    }

    return YES;
}

#pragma mark - Event response

/** 取消 button click */
- (void)cancelBtnClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/** 注册 button click */
- (void)registerBtnClick
{
    ZQLoginVC *registerVC  = [[ZQLoginVC alloc] init];
    registerVC.type = ZQLoginVCTypeRegister;
    [self presentViewController:registerVC animated:YES completion:nil];
}
/** 登录 button click */
- (void)loginBtnClick
{
    [self.view endEditing:YES];
    [self requestUserLoginWithUser:self.userTextField.text passWord:self.passwordTextField.text];
}

/** 登录成功后通知  请求我的收藏列表 */
- (void)loginSuccessRequestRecordListNotification:(NSNotification *)notification
{
    [self requestRecordProdutList];
}


#pragma mark - Private method
/** 添加UI */
- (void)setupUI
{
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.userTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.registerBtn];
}
/** UI布局 */
- (void)layoutWithAuto
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_equalTo(30);
        } else {
            make.top.equalTo(self.view).mas_equalTo(30);
        }
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_equalTo(30);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).mas_offset(30);
        } else {
            make.top.left.equalTo(self.view).mas_offset(30);
        }
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(45);
    }];
    [self.userTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).mas_offset(40);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).mas_offset(-40);
        } else {
            make.left.equalTo(self.view).mas_offset(40);
            make.right.equalTo(self.view).mas_offset(-40);
        }
        make.top.equalTo(self.cancelBtn.mas_bottom).mas_offset(40);
        make.height.mas_equalTo(45);
        
    }];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.userTextField);
        make.top.equalTo(self.userTextField.mas_bottom).mas_offset(10);
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).mas_offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(kScreenWidth/2);
        make.height.equalTo(self.cancelBtn);
    }];

    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(self.cancelBtn);
        make.right.equalTo(self.view).mas_offset(-30);
    }];
}

/**
 登录 parameter  username  password

 @param userText username
 @param password password
 */
- (void)requestUserLoginWithUser:(NSString *)userText passWord:(NSString *)password
{
    
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    
    if (self.userTextField.text.length == 0 || self.passwordTextField.text.length == 0) {
        [AppCT showError:@"账号或密码不能为空" dismiss:1.0];
        return;
    }
    
    if (self.type == ZQLoginVCTypeRegister) {
        [SVProgressHUD showErrorWithStatus:@"目前没有注册功能"];
        [SVProgressHUD dismissWithDelay:1.0];
        return;
    }
    
    [AppCT.networkServices POST:kAPIURLShopLogin parameter:@{user_name:userText,user_password:password} success:^(NSDictionary *dictionary) {
        
        NSInteger requestStatus = [dictionary[status] integerValue];
        if (requestStatus != 0) {
            [AppCT showError:dictionary[message] dismiss:1.0];
            return ;
        }
        AppCT.loginUser = [ZQLoginUser cz_objWithDict:dictionary[@"data"]];
        AppCT.userLogin = YES;
        [ZQUserDefault saveValue:userText forKey:UDKUserName];

        Post_Observer(kZQLoginSuccessRequestRecordListNotification, nil, @{});
        [strongSelf cancelBtnClick];
        
    } fail:nil];
}

/** 请求收藏列表 */
- (void)requestRecordProdutList
{
    NSString *uissss = AppCT.loginUser.user_id;
    [AppCT.networkServices GET:kAPIURLReocrdProductList parameter:@{@"uid":uissss} success:^(NSDictionary *dictionary) {
        
        if ([dictionary[status] integerValue] != 0) {
            [AppCT showError:dictionary[message] dismiss:1.0];
            return ;
        }
        NSArray *array = dictionary[@"data"];
        //存放到userdefault
        NSMutableArray *userDefaultAry = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDictionary *dic = obj;
            [userDefaultAry addObject:dic[product_id]];
//            ZQProductDetailModel *model = [ZQProductDetailModel mj_objectWithKeyValues:obj];
//            [userDefaultAry addObject:model.product_id];
        }];
        //保存商品id到userDefault
        [ZQUserDefault saveValue:userDefaultAry forKey:UDKRecordProductID];
            
    } fail:^(NSString *errorDescription) {
        
    }];
}


/** 当前界面为登录界面 */
- (void)typeIsLogin
{
    self.titleLabel.text = @"登录";
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    NSString *userName = [ZQUserDefault takeValueForKey:UDKUserName];
    if (userName) {
        self.userTextField.text = userName;
    }
    self.registerBtn.hidden = NO;
}
/** 当前界面为注册界面 */
- (void)typeIsRegister
{
    self.titleLabel.text = @"注册";
    [self.loginBtn setTitle:@"注册" forState:UIControlStateNormal];
    self.registerBtn.hidden = YES;
}

- (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder
{
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = placeholder;
    textField.font = [UIFont systemFontOfSize:kZQTitleFont];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.backgroundColor = [UIColor whiteColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.delegate = self;
    return textField;
}

#pragma mark - Dealloc
- (void)dealloc
{
//    Remove_Observer(kZQLoginSuccessRequestRecordListNotification);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Getter and Setter

- (void)setType:(ZQLoginVCType)type
{
    _type = type;
    switch (_type) {
        case ZQLoginVCTypeLogin:
            [self typeIsLogin];
            break;
        case ZQLoginVCTypeRegister:
            [self typeIsRegister];
            break;
        default:
            break;
    }
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton btnWithTitle:@"取消" font:kZQTitleFont textColor:nil bgColor:[UIColor whiteColor]];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.layer.masksToBounds = YES;
        _cancelBtn.layer.cornerRadius = 10;
    }
    return _cancelBtn;
}

- (UIButton *)registerBtn
{
    if (!_registerBtn) {
        _registerBtn = [UIButton btnWithTitle:@"注册" font:kZQTitleFont textColor:nil bgColor:[UIColor whiteColor]];
        [_registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _registerBtn.layer.masksToBounds = YES;
        _registerBtn.layer.cornerRadius = 10;
        _registerBtn.hidden = YES;
    }
    return _registerBtn;
}

- (UIButton *)loginBtn
{
    if (!_loginBtn) {
        _loginBtn = [UIButton btnWithTitle:@"登录" font:kZQTitleFont textColor:nil bgColor:[UIColor whiteColor]];
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.cornerRadius = 10;
        [_loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UITextField *)userTextField
{
    if (!_userTextField) {
        _userTextField = [self textFieldWithPlaceholder:@"用户名"];
        _userTextField.tag = 10;

        _userTextField.leftViewMode = UITextFieldViewModeAlways;
        _userTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage sizeImageWithImage:[UIImage imageNamed:@"icon_account"] sizs:CGSizeMake(35, 35)]];
    }
    return _userTextField;
}
- (UITextField *)passwordTextField
{
    if (!_passwordTextField) {
        _passwordTextField = [self textFieldWithPlaceholder:@"密码"];
        _passwordTextField.tag = 20;
        _passwordTextField.secureTextEntry = YES;
        
        _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
        _passwordTextField.leftView = [[UIImageView alloc] initWithImage:[UIImage sizeImageWithImage:[UIImage imageNamed:@"icon_password"] sizs:CGSizeMake(35, 35)]];
    }
    return _passwordTextField;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = @"登录";
    }
    return _titleLabel;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
