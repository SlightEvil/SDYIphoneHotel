//
//  ZQProductDetailVC.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/11.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQProductDetailVC.h"
#import <MJExtension/MJExtension.h>
#import "ZQQuantityTextField.h"

#import "ZQProductDetailModel.h"


static NSString *const ZQProductDetailVCCellIdentifier = @"ZQProductDetailVCCellIdentifier";


@interface ZQProductDetailVC ()<UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource>

/** 商品logo */
@property (nonatomic) UIImageView *productImageView;
/** 商品名称 */
@property (nonatomic) UILabel *productNameLabel;
/** 商品供应商 */
@property (nonatomic) UITextField *productShopTextField;
/** 商品供应商 */
@property (nonatomic) UIPickerView *productShopPickerView;
/** 商品简介 */
@property (nonatomic) UITextView *productDetailTextView;
/*********   tableHeader   *********/
/** 商品规格 单品 */
@property (nonatomic) UITableView *productParameterTableView;
/** 商品数量 */
@property (nonatomic) ZQQuantityTextField *productQuantityTextField;
/** 收藏 */
@property (nonatomic) UIButton *productRecordBtn;
/** 加入购物车 */
@property (nonatomic) UIButton *productAddShopCartBtn;

/**
 dictionary  parameter
 product : detailModle
 shop    : shopDataSource
 [2]    (null)    @"attributes" : @"2 elements"
 attributes :   未设置
 */

@property (nonatomic) ZQProductDetailModel *detailModle;
/** 供应商数组 */
@property (nonatomic) NSArray *shopDataSource;
/** 单品model  tableView 的DataSource */
@property (nonatomic) NSArray *skuDataSource;



@end

@implementation ZQProductDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupUI];
    [self layoutWithAuto];
    
    self.productImageView.image = [UIImage imageNamed:@"icon_error"];
//    self.productNameLabel.text = @"测试商品";
//    self.productShopTextField.text = @"测试商家";
//    
//    self.productDetailTextView.text = @"测试商家v测试商家测试商家测试商家测试商家测试商家测试商家测试商家测试商家测试商家";
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark - Delegate
#pragma mark PickerView 代理
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.shopDataSource ? self.shopDataSource.count : 0;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return kScreenWidth;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 45;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    if (self.shopDataSource.count > 0) {
        NSDictionary *dic = self.shopDataSource[row];
        label.text = dic[shop_name];
    } else {
        label.text = @"未知";
    }
//   NSDictionary *dic = self.shopDataSource ? self.shopDataSource[row] : @{shop_name:@"未知"};
//    label.text = dic[shop_name];
    return label;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (self.shopDataSource.count < 1) {
        return;
    }
    //获取shop model  设置shopName 请求
    NSDictionary *dic = self.shopDataSource[row];
    self.productShopTextField.text = dic[shop_name];
    [self.productShopTextField resignFirstResponder];
    
    NSString *product_name = self.detailModle.product_name;
    NSString *shopID = dic[shop_id];
    
    if (!product_name || !shopID) {
        return;
    }
    //请求商品不同
    [self requestProductDetail:product_name shopid:shopID];
}

#pragma mark - UITableView 代理
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 90;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 49;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZQProductDetailVCCellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = @"测试tableView";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [SVProgressHUD showSuccessWithStatus:@"点击cell"];
    [SVProgressHUD dismissWithDelay:1.0];
}


#pragma mark - Event response

- (void)recordBtnClick
{
    [SVProgressHUD showSuccessWithStatus:@"收藏"];
    [SVProgressHUD dismissWithDelay:1.0];
}
- (void)addShopCartBtnClick
{
    [SVProgressHUD showSuccessWithStatus:@"加入购物车"];
    [SVProgressHUD dismissWithDelay:1.0];
}


#pragma mark - Private medthod

- (void)setupUI
{
    [self.view addSubview:self.productImageView];
    [self.view addSubview:self.productNameLabel];
    [self.view addSubview:self.productShopTextField];
    
    [self.view addSubview:self.productParameterTableView];
    
    [self.view addSubview:self.productRecordBtn];
    [self.view addSubview:self.productAddShopCartBtn];
    
}
- (void)layoutWithAuto
{
    [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(5);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).mas_offset(10);
        } else {
            make.top.equalTo(self.view).mas_offset(5);
            make.left.equalTo(self.view).mas_offset(10);
        }
        make.width.height.mas_equalTo(70);
    }];
    [self.productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(5);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).mas_offset(-10);
        } else {
            make.top.equalTo(self.view).mas_offset(5);
            make.right.equalTo(self.view).mas_offset(-10);
        }
        
        make.left.equalTo(self.productImageView.mas_right).mas_offset(10);
        make.height.mas_equalTo(35);
    }];
    [self.productShopTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productNameLabel.mas_bottom);
        make.left.right.height.equalTo(self.productNameLabel);
    }];
    
    [self.productRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45);
        make.width.mas_equalTo(kScreenWidth/2);
        if (@available(iOS 11.0, *)) {
           make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-60);
        } else {
            make.bottom.equalTo(self.view).mas_offset(-60);
            make.left.equalTo(self.view);
        }
    }];
    [self.productAddShopCartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.width.equalTo(self.productRecordBtn);
        if (@available(iOS 11.0, *)) {
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        } else {
            make.right.equalTo(self.view);
        }
    }];
    
    [self.productParameterTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productShopTextField.mas_bottom).mas_offset(5);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.productAddShopCartBtn.mas_top);
        if (@available(iOS 11.0, *)) {
            make.left.right.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        } else {
            make.left.right.equalTo(self.view);
        }
    }];
}

/** tableView footer */
- (UIView *)tableFooterView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
    view.backgroundColor = self.view.backgroundColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 70, 40)];
    label.text = @"数量";
    label.font = [UIFont fontWithName:kZQFontNameSystem size:kZQCellFont];
    [view addSubview:label];
    
    CGRect frame = self.productQuantityTextField.frame;
    frame.origin = CGPointMake(kScreenWidth - CGRectGetWidth(self.productQuantityTextField.bounds)-20, 5);
    self.productQuantityTextField.frame = frame;
    
    [view addSubview:self.productQuantityTextField];
    return view;
}

/**
 请求不同商家的 商品详情  parameter  product_name shop_id

 @param productName 商品name
 @param shopID shop id
 */
- (void)requestProductDetail:(NSString *)productName shopid:(NSString *)shopID
{
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    [AppCT.networkServices GET:kAPIURLProductDetail parameter:@{} success:^(NSDictionary *dictionary) {
        
        NSInteger requestStatus = [dictionary[status] integerValue];
        if (requestStatus != 0) {
            return ;
        }
        NSDictionary *dic = dictionary[@"data"];
        strongSelf.productDetailDic = dic;
        
    } fail:nil];
}


#pragma mark - Getter and Setter

- (void)setProductDetailDic:(NSDictionary *)productDetailDic
{
    _productDetailDic = productDetailDic;
    
    ZQProductDetailModel *detailModel = [ZQProductDetailModel mj_objectWithKeyValues:_productDetailDic[@"product"]];
    self.detailModle = detailModel;
    
    NSArray *shopsAry = _productDetailDic[@"shops"];
    self.shopDataSource = shopsAry;
    
    NSArray *skusAry = _productDetailDic[@"skus"];
    self.skuDataSource = skusAry;
}

- (void)setDetailModle:(ZQProductDetailModel *)detailModle
{
    _detailModle = detailModle;
    self.productNameLabel.text = _detailModle.product_name;
    self.productShopTextField.text = _detailModle.shop_name;
}

- (void)setShopDataSource:(NSArray *)shopDataSource
{
    _shopDataSource = shopDataSource;
    [self.productShopPickerView reloadAllComponents];
}

- (void)setSkuDataSource:(NSArray *)skuDataSource
{
    _skuDataSource = skuDataSource;
    [self.productParameterTableView reloadData];
}

- (UIImageView *)productImageView
{
    if (!_productImageView) {
        _productImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 60, 60)];
    }
    return _productImageView;
}
- (UILabel *)productNameLabel
{
    if (!_productNameLabel) {
        _productNameLabel = [[UILabel alloc] init];
        _productNameLabel.font = [UIFont fontWithName:kZQFontNameBold size:kZQTitleFont];
    }
    return _productNameLabel;
}
- (UITextField *)productShopTextField
{
    if (!_productShopTextField) {
        _productShopTextField = [[UITextField alloc] init];
        _productShopTextField.font = [UIFont fontWithName:kZQFontNameSystem size:kZQCellFont];
        _productShopTextField.leftViewMode = UITextFieldViewModeAlways;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 65, 40)];
        label.font = [UIFont fontWithName:kZQFontNameSystem size:kZQCellFont];
        label.text = @"选择";
        _productShopTextField.leftView = label;
        _productShopTextField.inputView = self.productShopPickerView;
        
        _productShopTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _productShopTextField;
}

- (UIPickerView *)productShopPickerView
{
    if (!_productShopPickerView) {
        _productShopPickerView = [[UIPickerView alloc] init];
        _productShopPickerView.delegate = self;
        _productShopPickerView.dataSource = self;
    }
    return _productShopPickerView;
}


- (UITextView *)productDetailTextView
{
    if (!_productDetailTextView) {
        _productDetailTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        _productDetailTextView.font = [UIFont fontWithName:kZQFontNameSystem size:kZQDetailFont];
        _productDetailTextView.editable = NO;
        _productDetailTextView.selectable = NO;
        _productDetailTextView.textColor = kZQDetailViewTextColor;
    }
    return _productDetailTextView;
}

- (UITableView *)productParameterTableView
{
    if (!_productParameterTableView) {
        _productParameterTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _productParameterTableView.delegate = self;
        _productParameterTableView.dataSource = self;
        
        _productParameterTableView.tableHeaderView = self.productDetailTextView;
        _productParameterTableView.tableFooterView = [self tableFooterView];
        
        [_productParameterTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ZQProductDetailVCCellIdentifier];
    }
    return _productParameterTableView;
}


- (ZQQuantityTextField *)productQuantityTextField
{
    if (!_productQuantityTextField) {

        _productQuantityTextField = [[ZQQuantityTextField alloc] initWithFrame:CGRectMake(0, 0, 130, 35)];
    }
    return _productQuantityTextField;
}

- (UIButton *)productRecordBtn
{
    if (!_productRecordBtn) {
        _productRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_productRecordBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [_productRecordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _productRecordBtn.backgroundColor = kZQBlackColor;
        [_productRecordBtn addTarget:self action:@selector(recordBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _productRecordBtn;
}

- (UIButton *)productAddShopCartBtn
{
    if (!_productAddShopCartBtn) {
        _productAddShopCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_productAddShopCartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        [_productAddShopCartBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _productAddShopCartBtn.backgroundColor = [UIColor redColor];
        [_productAddShopCartBtn addTarget:self action:@selector(addShopCartBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _productAddShopCartBtn;
}


#pragma mark - Dealloc 

- (void)dealloc
{
    _detailModle = nil;
    _shopDataSource = nil;
    _skuDataSource = nil;
    _productDetailDic = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
