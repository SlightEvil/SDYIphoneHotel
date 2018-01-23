//
//  ZQProductDetailView.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/11.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQProductDetailView.h"
#import "Masonry.h"
#import <MJExtension/MJExtension.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "ZQQuantityTextField.h"
#import "ZQProductDetailAttributeCell.h"
#import "ZQProductModel.h"
#import "ZQProductDetailModel.h"
#import "ZQProductShopModel.h"
#import "ZQProductSkusModel.h"
#import "ZQProductAttributeModel.h"
#import "ZQAddNewProductModel.h"
#import "UIImage+Cagegory.h"


static NSString *const ZQProductDetailVCCellIdentifier = @"ZQProductDetailVCCellIdentifier";


@interface ZQProductDetailView ()<UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource>


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

/** 商品详情商品的信息 */
@property (nonatomic) ZQProductModel *productModel;

/** 当前的供应商信息 */
@property (nonatomic) ZQProductShopModel *shopModel;

/** 选择的cellIndex */
@property (nonatomic, assign) NSInteger selectCellIndex;
/** 商品价格  */
@property (nonatomic) NSString *productPrice;
/** 获取收藏的商品id */
//@property (nonatomic) NSArray *record_IDAry;

/** 是否已收藏 */
@property (nonatomic, assign) BOOL isRecorded;


@end


@implementation ZQProductDetailView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
         [self setupUI];
         [self layoutWithAuto];
        
        self.selectCellIndex = 0;
    }
    return self;
}

- (void)clearData
{
    [self endEditing:YES];
    self.selectCellIndex = 0;
    self.productPrice = @"";
    self.productQuantityTextField.text = @"1";
}

#pragma mark - Delegate
#pragma mark PickerView 代理
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.productModel.shops.count;
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
    
    if (self.productModel.shops.count > 0) {
        ZQProductShopModel *shopModel = self.productModel.shops[row];
        label.text = shopModel.shop_name;
    } else {
        label.text = @"未知";
    }
    return label;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
#pragma mark - pick 的动作需要动一下
    BOOL isYes  = self.productModel.shops.count > 0;
    if (!isYes) {
        [self.productShopTextField resignFirstResponder];
        return;
    }
    
    isYes = self.productModel.shops.count == 1;
    if (isYes) {
        [self.productShopTextField resignFirstResponder];
        return;
    }
    
    //获取shop model  设置shopName 请求
    ZQProductShopModel *shopModel = self.productModel.shops[row];
    self.shopModel = shopModel;

    self.productShopTextField.text = shopModel.shop_name;
    [self.productShopTextField resignFirstResponder];
    
    NSString *product_name = self.self.productModel.product.product_name;
    NSString *shopID = shopModel.shop_id;
    
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
    return self.productModel.skus.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZQProductDetailAttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:ZQProductDetailVCCellIdentifier forIndexPath:indexPath];
    
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    
    if (self.productModel && self.productModel.skus.count > 0) {
    
        ZQProductSkusModel *skusModel = self.productModel.skus[indexPath.row];
    
        cell.productUnit = self.productModel.product.unit;
        cell.attribute = skusModel.attribute_names;
        cell.mallPrice = skusModel.mall_price;
        cell.makePrice = skusModel.market_price;
        cell.index = indexPath.row;
        if (indexPath.row == self.selectCellIndex) {
            cell.buttonIsSelected  = YES;
        } else {
            cell.buttonIsSelected = NO;
        }
        cell.attributeBtnClick = ^(NSUInteger index) {
            strongSelf.selectCellIndex = index;
            ZQProductSkusModel *skusModels = strongSelf.productModel.skus[index];
            strongSelf.productPrice = skusModels.mall_price;
            [strongSelf.productParameterTableView reloadData];
        };
    }
    return cell;
}

#pragma mark - Event response

- (void)recordBtnClick
{
    NSString *pid = self.productModel.product.product_id;
//    if (self.delegate && [self.delegate respondsToSelector:@selector(productDetailViewRecordProductID:isRecord:) ]) {
//        [self.delegate productDetailViewRecordProductID:pid isRecord:self.isRecorded];
//    }
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    
    NSString *urlStr = self.isRecorded ? kAPIURLCancelRecordProduct : kAPIURLRecordProduct;
    
    [AppCT.networkServices GET:urlStr parameter:@{@"pid":pid} success:^(NSDictionary *dictionary) {
        NSInteger requestStatus = [dictionary[status] integerValue];
        if (requestStatus != 0) {
            [SVProgressHUD showErrorWithStatus:dictionary[message]];
            [SVProgressHUD dismissWithDelay:1.0];
            return;
        }
        
        //收藏按钮 公共事件， 判断是否为 取消收藏
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(productDetailViewRecordSuccessForIsCancelRecord:)]) {
            [strongSelf.delegate productDetailViewRecordSuccessForIsCancelRecord:strongSelf.isRecorded];
        }
        
        NSMutableArray *recordIDAry = [[ZQUserDefault takeValueForKey:UDKRecordProductID] mutableCopy];
        
        if (strongSelf.isRecorded) {
            if ([recordIDAry containsObject:pid]) {
                [recordIDAry removeObject:pid];
            }
        } else {
            if (![recordIDAry containsObject:pid]) {
                [recordIDAry addObject:pid];
            }
        }
        [ZQUserDefault saveValue:recordIDAry forKey:UDKRecordProductID];
        
        strongSelf.isRecorded = !strongSelf.isRecorded;
        [SVProgressHUD showSuccessWithStatus:dictionary[message]];
        [SVProgressHUD dismissWithDelay:1.0];
        
    } fail:nil];
}
- (void)addShopCartBtnClick
{
#pragma mark - 添加新的商品 使用model ZQAddNewProductModel  ZQAddNewProductDetail
    //单品
    ZQProductSkusModel *skusModel = self.productModel.skus[self.selectCellIndex];
    //商品详情
    ZQProductDetailModel *detailModel = self.productModel.product;

    //新建商品的detail@[]
    ZQAddNewProductDetail *detail = [[ZQAddNewProductDetail alloc] init];
    detail.detail_id = @"";
    detail.sku_id = skusModel.sku_id;
    detail.product_name = detailModel.product_name;
    detail.product_id = detailModel.product_id;
    detail.attributes = skusModel.attribute_names;
    detail.price = self.productPrice;
    detail.quantity = self.productQuantityTextField.text;
    detail.unit = detailModel.unit;
    detail.thumbnail = detailModel.thumbnail;
    
    //添加商品总价
    CGFloat totalPriceFloat = [self.productPrice floatValue] * [self.productQuantityTextField.text floatValue];
    
    NSString *totalPrice = [NSString stringWithFormat:@"%.2f",totalPriceFloat];
    ZQAddNewProductModel *newProduct = [[ZQAddNewProductModel alloc] init];
    newProduct.shop_id = self.shopModel.shop_id;
    newProduct.shop_name = self.shopModel.shop_name;
    newProduct.shop_phone = self.shopModel.phone;
    newProduct.price = totalPrice;
    newProduct.content = @"";
    newProduct.details = [NSMutableArray arrayWithArray:@[detail]];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(productDetailViewAddNewProduct:)]) {
        [self.delegate productDetailViewAddNewProduct:newProduct];
    }
}



#pragma mark - Private medthod

- (void)setupUI
{
    [self addSubview:self.productImageView];
    [self addSubview:self.productNameLabel];
    [self addSubview:self.productShopTextField];
    
    [self addSubview:self.productParameterTableView];
    
    [self addSubview:self.productRecordBtn];
    [self addSubview:self.productAddShopCartBtn];
    
}
- (void)layoutWithAuto
{
    [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).mas_offset(5);
            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft).mas_offset(10);
        } else {
            make.top.equalTo(self).mas_offset(5);
            make.left.equalTo(self).mas_offset(10);
        }
        make.width.height.mas_equalTo(70);
    }];
    [self.productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.mas_safeAreaLayoutGuideTop).mas_offset(5);
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight).mas_offset(-10);
        } else {
            make.top.equalTo(self).mas_offset(5);
            make.right.equalTo(self).mas_offset(-10);
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
        make.width.mas_equalTo(kScreenWidth/2-0.5);
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self);
            make.left.equalTo(self);
        }
    }];
    [self.productAddShopCartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.width.equalTo(self.productRecordBtn);
        if (@available(iOS 11.0, *)) {
           make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
        } else {
           make.right.equalTo(self);
        };
    }];
    
    [self.productParameterTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productShopTextField.mas_bottom).mas_offset(5);
        make.bottom.equalTo(self.productAddShopCartBtn.mas_top);
        if (@available(iOS 11.0, *)) {
            make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
        } else {
            make.right.equalTo(self);
            make.left.right.equalTo(self);
        };
    }];
}

/** tableView footer */
- (UIView *)tableFooterView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
    view.backgroundColor = self.backgroundColor;
    
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
    [AppCT.networkServices GET:kAPIURLProductDetail parameter:@{name:productName,shop_id:shopID} success:^(NSDictionary *dictionary) {
        
        NSInteger requestStatus = [dictionary[status] integerValue];
        if (requestStatus != 0) {
            [SVProgressHUD showErrorWithStatus:dictionary[message]];
            [SVProgressHUD dismissWithDelay:1.0];
            return ;
        }
        NSDictionary *dic = dictionary[@"data"];
        strongSelf.productDetailDic = dic;
        
    } fail:nil];
}

/** 判断并设置当前的shopModel  parameter 为shop_id  或者shop_id */
- (ZQProductShopModel *)judgeShopModelWithShopID:(NSString *)shopID shopAry:(NSArray *)shopAry
{
    __block NSInteger index = 0;
    [shopAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ZQProductShopModel *shopModel = obj;
        if (shopModel.shop_id == shopID) {
            index = idx;
        }
    }];
    return shopAry[index];
}


#pragma mark - Getter and Setter

- (void)setProductDetailDic:(NSDictionary *)productDetailDic
{
    _productDetailDic = productDetailDic;
    
    self.productModel = [ZQProductModel mj_objectWithKeyValues:_productDetailDic];
    //默认价格为第一个单品的价格
    ZQProductSkusModel *skusModel = self.productModel.skus[0];
    self.productPrice = skusModel.mall_price;
    
    NSString *shopID = self.productModel.product.shop_id;
    self.shopModel = [self judgeShopModelWithShopID:shopID shopAry:self.productModel.shops];

    ZQProductDetailModel *productDetailModel = self.productModel.product;
    self.productNameLabel.text = productDetailModel.product_name;
    self.productShopTextField.text = productDetailModel.shop_name;
    self.productDetailTextView.text = productDetailModel.product_description;
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:kSDYImageUrl(productDetailModel.thumbnail)] placeholderImage:[UIImage imageNamed:@"icon_error"]];
    
    [self.productParameterTableView reloadData];
    
    
    //获取收藏的商品id
    NSArray *recordAry  = [ZQUserDefault takeValueForKey:UDKRecordProductID];
    
    NSString *productID = self.productModel.product.product_id;
    if ([recordAry containsObject:productID]) {
        self.isRecorded = YES;
    } else {
        self.isRecorded = NO;
    }
}

- (void)setIsRecorded:(BOOL)isRecorded
{
    _isRecorded = isRecorded;
    [self.productRecordBtn setTitle:(_isRecorded ? @"已收藏" :@"收藏") forState:UIControlStateNormal];
    [self.productRecordBtn setImage:[UIImage sizeImageWithImage:[UIImage imageNamed:(_isRecorded ? @"icon_record_select":@"icon_record")] sizs:CGSizeMake(30, 30)] forState:UIControlStateNormal];
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
        
        [_productParameterTableView registerClass:[ZQProductDetailAttributeCell class] forCellReuseIdentifier:ZQProductDetailVCCellIdentifier];
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
        [_productRecordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _productRecordBtn.backgroundColor = kZQRecordColor;
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


@end
