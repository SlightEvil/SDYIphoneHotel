//
//  ZQShoppingCartVC.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/9.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQShoppingCartVC.h"
#import "UIImage+Cagegory.h"
#import "ZQAddNewProductModel.h"
#import "ZQShopCartCell.h"
#import "ZQShopCartHeaderView.h"
#import "ZYInputAlertView.h"//弹出输入框
#import "ZQPickerView.h"
#import "ZQOrderRecordModel.h"
#import "ZQAddNewOrderRecordV.h"



static NSString *const ZQShoppingCartVCCellIdentifier = @"ZQShoppingCartVCCellIdentifier";
static NSString *const ZQShoppingCartVCHeaderIdentifier = @"ZQShoppingCartVCHeaderIdentifier";

@interface ZQShoppingCartVC ()<UITableViewDelegate,UITableViewDataSource,ZQShopCartCellDelegate,ZQShopCartHeaderViewDelegate,ZQAddNewOrderRecordVDelegate>

/** 购物车 list */
@property (nonatomic) UITableView *tableView;
/** 购物车里面没有数据 显示文字 */
@property (nonatomic) UILabel *label;

/** 购物车的工具条   */
@property (nonatomic) UIView *toolBar;

/** 清空购物车 */
@property (nonatomic) UIButton *clearBtn;
/** 总计总价 */
@property (nonatomic) UILabel *totalPriceLabel;
/** 下单 */
@property (nonatomic) UIButton *downOrderBtn;

/** 添加商品到订单模板 */
@property (nonatomic) UIButton *addToOrderRecord;
/** 是否添加到订单模板 */
@property (nonatomic, assign) BOOL isAddOrderReocrd;

/** 模板的名称 */
@property (nonatomic) UILabel *orderRecordNameLabel;

/** 选择订单模板 */
@property (nonatomic) ZQPickerView *pickerView;
/** 弹出输入框 */
@property (nonatomic) ZYInputAlertView *alertView;
/** 弹出 新增订单模板 */
@property (nonatomic) ZQAddNewOrderRecordV *addNewOrderRecord;

@end

/*
 购物车商品列表
 （加减数量，删除商品，名称，logo，规格，单价）
 工具条
 （清空购物车，商品总价，提交订单）
 */

@implementation ZQShoppingCartVC

#pragma mark- overwrite  重写init, 在设置UITabbarController 里面初始化的时候就注册通知 接收ViewModel badgeValue
 - (instancetype)init
{
    if (self = [super init]) {
        Add_Observer(kZQShopCartProductNumberBadgeValueNotification, @selector(shopCartProductNumberNotification:));
        NSLog(@"初始化");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self layoutWithAuto];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (ViewModel.shopCartDataSource.count == 0) {
        [self hiddeTableView:YES];
    } else {
        [self.tableView reloadData];
        [self hiddeTableView:NO];
    }
}


#pragma mark - Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 49;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ViewModel.shopCartDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (ViewModel.shopCartDataSource.count > 0) {
        ZQAddNewProductModel *sectionModle = ViewModel.shopCartDataSource[section];
        return sectionModle.details.count;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ZQShopCartHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ZQShoppingCartVCHeaderIdentifier];
    header.index = section;
    header.delegate = self;
    if (ViewModel.shopCartDataSource.count > 0) {
        ZQAddNewProductModel *sectionModel = ViewModel.shopCartDataSource[section];
        header.titleStr = [NSString stringWithFormat:@"  %@",sectionModel.shop_name];
    }
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZQShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:ZQShoppingCartVCCellIdentifier forIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    if (ViewModel.shopCartDataSource.count > 0) {
        ZQAddNewProductModel *sectionModle = ViewModel.shopCartDataSource[indexPath.section];
        ZQAddNewProductDetail *rowModel = sectionModle.details[indexPath.row];
        cell.detaiModel = rowModel;
    }

    return cell;
}

#pragma mark - Other Delegate

#pragma mark - 自定义 cell的代理实现
/** 自定义 cell的代理实现 */
/**
 商品数量发生改变 quantity 新的数量  indexpath 指定元素下标
 
 @param quantity 数量
 @param indexPath 指定元素
 */
- (void)cellProductQuantityChange:(NSString *)quantity indexPath:(NSIndexPath *)indexPath
{
    zq_asyncDispatchToGlobalQueue(^{
        [ViewModel changeProductQuantity:quantity indexPath:indexPath];
    });
}

/**
 删除商品 indexpath 指定元素下标
 @param indexPath 指定元素
 */
- (void)cellProductDeleteIndexPath:(NSIndexPath *)indexPath
{
    [self alertDeleteCompleWithIndexPath:indexPath];
}

#pragma mark - 自定义header代理实现

- (void)showAlertRemarkViewBtnClickIndex:(NSInteger)index
{
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    ZQAddNewProductModel *model = ViewModel.shopCartDataSource[index];
    ZYInputAlertView *alertView = [ZYInputAlertView alertView];
    if (model.content && model.content.length > 0) {
        alertView.reMarkStr = model.content;
    } else {
        alertView.placeholder = @"输入您想说的留言...";
    }
    [alertView confirmBtnClickBlock:^(NSString *inputString) {
        model.content = inputString;
        [strongSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
    }];
    [alertView show];
}

#pragma mark - 新增订单模板 代理实现

/**
 新增 订单模板的 callback

 @param nameStr name
 @param describeStr 描述
 */
- (void)confirmButtonClickAction:(NSString *)nameStr describe:(NSString *)describeStr
{
    self.orderRecordNameLabel.text = nameStr;
    self.isAddOrderReocrd = YES;
}

#pragma mark - Event response
/** 购物车商品个数的通知 */
- (void)shopCartProductNumberNotification:(NSNotification *)notification
{
    NSDictionary *dic = [notification userInfo];
    self.tabBarItem.badgeValue =  dic[kZQShopCartQuantityKey];
    
    NSString *totalPrice = dic[kZQShopCartTotalPriceKey];
    
    if (self.totalPriceLabel) {
        self.totalPriceLabel.text = [NSString stringWithFormat:@"总价:¥%@元",totalPrice];
    }
}

/**
 弹窗提醒是否删除商品  indexPath  指定的元素下标
 @param indexPath indexPath
 */
- (void)alertDeleteCompleWithIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    
    [strongSelf alertTitle:@"确定删除商品" message:nil comple:^{
        
        zq_asyncDispatchToMainQueue(^{
            [ViewModel deleteProductToShopCartWithIndexPath:indexPath];
             [strongSelf.tableView reloadData];
            if (ViewModel.shopCartDataSource.count == 0) {
                [strongSelf hiddeTableView:YES];
            }
        });
    }];
}

/** 清空购物车 */
- (void)clearBtnClick
{
    zq_asyncDispatchToMainQueue(^{
        [ViewModel clearShopCartProduct];
        [self.tableView reloadData];
        [self hiddeTableView:YES];
        [self clearData];
    });
}
/** 下单 */
- (void)downOrderBtnClick
{
    NSString *jsonStr = [ViewModel addNewOrderContent];
    [self requestAddNewOrderWithContent:jsonStr];
}

/** 添加购物车数据到订单模板 */
- (void)addToOrderRecordBtnClick
{
    if (self.isAddOrderReocrd) {
        self.isAddOrderReocrd = NO;
        self.orderRecordNameLabel.text = @"";
        return;
    }
    
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    
    [AppCT.networkServices GET:kAPIURLOrderRecordList parameter:@{} success:^(NSDictionary *dictionary) {
        
        NSInteger requestStatus = [dictionary[status] integerValue];
        if (requestStatus != 0) {
            [SVProgressHUD showErrorWithStatus:dictionary[message]];
            [SVProgressHUD dismissWithDelay:1.0];
            return ;
        }
        
        NSArray *orderRecordAry = dictionary[@"data"];
        NSMutableArray *array = [NSMutableArray array];
        if (orderRecordAry.count > 0) {
            
            [orderRecordAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ZQOrderRecordModel *model = [ZQOrderRecordModel mj_objectWithKeyValues:obj];
                [array addObject:model];
            }];
        
            ZQPickerView *pickerView = [ZQPickerView new];
            pickerView.dataSource = array;
            [pickerView comfirmClickBlock:^(NSString *name) {
                strongSelf.orderRecordNameLabel.text = name;
                strongSelf.isAddOrderReocrd = YES;
            }];
            [pickerView show];
        } else {
            [strongSelf.addNewOrderRecord show];
        }

    } fail:^(NSString *errorDescription) {
        
    }];
}


#pragma mark - Private method

- (void)setupUI
{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.toolBar];
    [self.view addSubview:self.label];
    
    [self.view addSubview:self.clearBtn];
    [self.view addSubview:self.totalPriceLabel];
    [self.view addSubview:self.downOrderBtn];
    [self.view addSubview:self.addToOrderRecord];
    [self.view addSubview:self.orderRecordNameLabel];
}

- (void)layoutWithAuto
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-84);
        } else {
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).mas_offset(-84);
        }
    }];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).mas_offset(1);
        make.left.right.equalTo(self.tableView);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(1);
        } else {
            make.bottom.equalTo(self.view).mas_offset(1);
        }
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.tableView);
        make.height.mas_equalTo(50);
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
    
    [self.addToOrderRecord mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).mas_offset(10);
//            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).mas_offset(-40);
        } else {
            make.left.equalTo(self.view).mas_offset(10);
//            make.right.equalTo(self.view).mas_offset(-40);
        }
        make.top.equalTo(self.tableView.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(40);
    }];
    
    [self.orderRecordNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).mas_offset(-10);
        } else {
            make.right.equalTo(self.view).mas_offset(-10);
        }
        make.top.bottom.width.equalTo(self.addToOrderRecord);
        make.left.equalTo(self.addToOrderRecord.mas_right).mas_offset(20);
    }];
    [self.addToOrderRecord mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.orderRecordNameLabel);
    }];

    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).mas_offset(10);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-5);
        } else {
            make.left.equalTo(self.view).mas_offset(10);
            make.bottom.equalTo(self.view).mas_offset(-5);
        }
        make.top.equalTo(self.addToOrderRecord.mas_bottom).mas_offset(5);
        
        make.width.mas_equalTo(60);
    }];
    [self.downOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addToOrderRecord.mas_bottom).mas_offset(1);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(1);
        } else {
            make.bottom.equalTo(self.view).mas_offset(1);
        }
        make.right.equalTo(self.tableView);
        make.width.mas_equalTo(90);
    }];
    
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.downOrderBtn);
        make.left.equalTo(self.clearBtn.mas_right).mas_offset(20);
        make.right.equalTo(self.downOrderBtn.mas_left).mas_offset(-20);
    }];
}

/**
 添加新的订单

 @param contentStr 参数
 */
- (void)requestAddNewOrderWithContent:(NSString *)contentStr
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{content:contentStr}];
    //是否添加单品到订单模板
    if (self.isAddOrderReocrd) {
        /*
         set    string    否    是否创建模版。1为创建，留空或其它则忽略。  只要包含模板信息，必须传set  为 1
         template    string    否    模版名称
         */
        [dic setObject:@"1" forKey:@"set"];
        [dic setObject:self.orderRecordNameLabel.text forKey:@"template"];
    }

    __weak typeof(self)weakSelf = self;
    __strong  typeof(weakSelf)strongSelf = weakSelf;
    [AppCT.networkServices POST:kAPIURLAddNewOrder parameter:dic success:^(NSDictionary *dictionary) {
        
        NSInteger requestStatus = [dictionary[status] integerValue];
        if (requestStatus != 0) {
            [SVProgressHUD showErrorWithStatus:dictionary[message]];
            [SVProgressHUD dismissWithDelay:5.0];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:dictionary[message]];
        [SVProgressHUD dismissWithDelay:1.0];
        //清除购物车数据
        [strongSelf clearBtnClick];
        
    } fail:^(NSString *errorDescription) {
        
    }];
}

/**
 是否隐藏tableView isHidden   隐藏

 @param isHidden 是否隐藏
 */
- (void)hiddeTableView:(BOOL)isHidden
{
    self.tableView.hidden = self.clearBtn.hidden = self.totalPriceLabel.hidden = self.downOrderBtn.hidden = self.toolBar.hidden = self.addToOrderRecord.hidden = self.orderRecordNameLabel.hidden = isHidden;
    self.label.hidden = !isHidden;
}

/** 清除数据 */
- (void)clearData
{
    self.isAddOrderReocrd = NO;
    [self.addToOrderRecord setImage:[UIImage sizeImageWithImage:[UIImage imageNamed:@"icon_record"] sizs:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    self.orderRecordNameLabel.text = @"";
}

#pragma mark - Dealloc

- (void)dealloc
{
    [_addToOrderRecord setImage:[UIImage sizeImageWithImage:[UIImage imageNamed:@"icon_record"] sizs:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    _isAddOrderReocrd = NO;
}



#pragma mark - Getter and Setter

- (void)setIsAddOrderReocrd:(BOOL)isAddOrderReocrd
{
    _isAddOrderReocrd = isAddOrderReocrd;
    
    [self.addToOrderRecord setImage:[UIImage sizeImageWithImage:[UIImage imageNamed:(_isAddOrderReocrd ? @"icon_record_select":@"icon_record")] sizs:CGSizeMake(30, 30)] forState:UIControlStateNormal];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[ZQShopCartCell class] forCellReuseIdentifier:ZQShoppingCartVCCellIdentifier];
        [_tableView registerClass:[ZQShopCartHeaderView class] forHeaderFooterViewReuseIdentifier:ZQShoppingCartVCHeaderIdentifier];
    }
    return _tableView;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.text = @"购物车还没有添加数据，快去购物吧";
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont fontWithName:kZQFontNameBold size:kZQTitleFont];
        _label.hidden = YES;
    }
    return _label;
}

- (UIView *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[UIView alloc] init];
        _toolBar.backgroundColor = [UIColor whiteColor];
    }
    return _toolBar;
}

- (UIButton *)addToOrderRecord
{
    if (!_addToOrderRecord) {
        _addToOrderRecord = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addToOrderRecord setTitle:@"添加到订单模板" forState:UIControlStateNormal];
        [_addToOrderRecord setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _addToOrderRecord.titleLabel.font = [UIFont boldSystemFontOfSize:kZQCellFont];
        [_addToOrderRecord addTarget:self action:@selector(addToOrderRecordBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _addToOrderRecord.backgroundColor = [UIColor whiteColor];
        
        [_addToOrderRecord setImage:[UIImage sizeImageWithImage:[UIImage imageNamed:@"icon_record"] sizs:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    }
    return _addToOrderRecord;
}

- (UILabel *)orderRecordNameLabel
{
    if (!_orderRecordNameLabel) {
        _orderRecordNameLabel = [UILabel new];
        _orderRecordNameLabel.font = [UIFont fontWithName:kZQFontNameBold size:kZQCellFont];
    }
    return _orderRecordNameLabel;
}

- (UIButton *)clearBtn
{
    if (!_clearBtn) {
        _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearBtn setTitle:@"清空" forState:UIControlStateNormal];
        [_clearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_clearBtn addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _clearBtn.layer.masksToBounds = YES;
        _clearBtn.layer.borderWidth = 1;
        _clearBtn.layer.borderColor = [kZQBlackColor CGColor];
        _clearBtn.layer.cornerRadius = 10;
    }
    return _clearBtn;
}
- (UIButton *)downOrderBtn
{
    if (!_downOrderBtn) {
        _downOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downOrderBtn setTitle:@"下单" forState:UIControlStateNormal];
        [_downOrderBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_downOrderBtn addTarget:self action:@selector(downOrderBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _downOrderBtn.backgroundColor = [UIColor redColor];
    }
    return _downOrderBtn;
}
- (UILabel *)totalPriceLabel
{
    if (!_totalPriceLabel) {
        _totalPriceLabel = [[UILabel alloc]init];
        _totalPriceLabel.font = [UIFont fontWithName:kZQFontNameBold size:kZQCellFont];
        _totalPriceLabel.numberOfLines = 2;
        _totalPriceLabel.backgroundColor = [UIColor whiteColor];
        _totalPriceLabel.text = @"总计:¥0.00元";
    }
    return _totalPriceLabel;
}

- (ZYInputAlertView *)alertView
{
    if (!_alertView) {
        _alertView = [ZYInputAlertView alertView];
    }
    return _alertView;
}

- (ZQAddNewOrderRecordV *)addNewOrderRecord
{
    if (!_addNewOrderRecord) {
        _addNewOrderRecord = [[ZQAddNewOrderRecordV alloc] init];
        _addNewOrderRecord.delegate = self;
        _addNewOrderRecord.isNeedDescribe = NO;//设置不需要描述
    }
    return _addNewOrderRecord;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
