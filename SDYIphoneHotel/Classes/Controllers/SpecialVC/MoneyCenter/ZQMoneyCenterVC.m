//
//  ZQMoneyCenterVC.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/17.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQMoneyCenterVC.h"
#import "ZQAccountModel.h"
#import "ZQAccountLogModel.h"
#import "ZQAccountLogCell.h"


static NSString *const cellIdentifier = @"ZQMoneyCenterVCCellIdentifier";

@interface ZQMoneyCenterVC ()<UITableViewDelegate,UITableViewDataSource>

/** 资金流水记录 */
@property (nonatomic) UITableView *accountTableView;
/** 背景 */
@property (nonatomic) UIImageView *backgroundImageView;
/** 账户 */
@property (nonatomic) UILabel *accountLabel;
/** 余额 */
@property (nonatomic) UILabel *balanceLabel;
/** 可用余额 */
@property (nonatomic) UILabel *vaildBalanceLabel;
/** 冻结基金 */
@property (nonatomic) UILabel *frozenFundLabel;
/** 可提现基金 */
@property (nonatomic) UILabel *cashFundLabel;

/** 账户信息  使用Setter更新数据 */
@property (nonatomic) ZQAccountModel *accountModel;
/** 交易流水数据  ZQAccountLogModel  使用Setter更新数据  */
@property (nonatomic) NSArray *accountLogAry;


@end

@implementation ZQMoneyCenterVC
{
    //当前的页  刷新的时候用
    NSUInteger _currentPageNumber;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"财务中心";
    
    [self setupUI];
    [self layoutWithAuto];
    [self setupHeaderFooterRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!AppCT.isUserLogin) {
        [AppCT showLoginVC];
        return;
    }
    
    [self requestAccountMoneyShow];
    
}

#pragma mark - Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.accountLogAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZQAccountLogCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    ZQAccountLogModel *logModel = self.accountLogAry[indexPath.row];
    cell.accountLogModel = logModel;
    
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    return cell;
}


#pragma mark - Event response
/** 下拉刷新 */
- (void)mjRefreshHeaderAction
{
    [self requestAccountMoneyShow];
}
/** 下拉加载 */
- (void)mjRefreshFooterAction
{
    [self requestAccountLogPageNumber:[NSString stringWithFormat:@"%zd",(_currentPageNumber+1)] pageLine:@"20"];
}


#pragma mark - Private method
/** 设置UI */
- (void)setupUI
{
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.balanceLabel];
    [self.view addSubview:self.vaildBalanceLabel];
    [self.view addSubview:self.frozenFundLabel];
    [self.view addSubview:self.cashFundLabel];
    [self.view addSubview:self.accountTableView];
    
}

/** 使用自动布局 */
- (void)layoutWithAuto
{
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        } else {
            make.top.left.right.equalTo(self.view);
        }
        make.height.mas_equalTo(150);
    }];
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).mas_offset(20);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).mas_offset(20);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).mas_offset(-20);
        } else {
            make.top.left.equalTo(self.view).mas_offset(20);
            make.right.equalTo(self.view).mas_offset(-20);
        }
    }];
    [self.vaildBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.balanceLabel.mas_bottom);
        make.left.right.height.equalTo(self.balanceLabel);
    }];
    [self.frozenFundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.vaildBalanceLabel.mas_bottom);
        make.left.right.height.equalTo(self.vaildBalanceLabel);
    }];
    [self.cashFundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.frozenFundLabel.mas_bottom);
        make.left.right.height.equalTo(self.frozenFundLabel);
        make.bottom.equalTo(self.backgroundImageView.mas_bottom).mas_offset(-10);
    }];
    [self.balanceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.cashFundLabel);
    }];
    
    [self.accountTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundImageView.mas_bottom);
        make.left.right.equalTo(self.backgroundImageView);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
}

/**
 请求账户资金预览
 */
- (void)requestAccountMoneyShow
{
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    _currentPageNumber = 1;
    
    [AppCT.networkServices GET:kAPIURLAccountMoney parameter:@{page:@"1",line:@"15"} success:^(NSDictionary *dictionary) {
        
        [strongSelf.accountTableView.mj_header endRefreshing];
        [strongSelf.accountTableView.mj_footer endRefreshing];
        
        NSInteger requestStatus = [dictionary[status] integerValue];
        if (requestStatus != 0) {
            [SVProgressHUD showErrorWithStatus:dictionary[message]];
            [SVProgressHUD dismissWithDelay:1.0];
            return ;
        }
        
        NSDictionary *dic = dictionary[@"data"];
        
        NSMutableArray *array = dic[@"account_logs"];
        NSMutableArray *accountLogAry = [NSMutableArray array];
        
        @autoreleasepool {
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ZQAccountLogModel *accountLogModel = [ZQAccountLogModel mj_objectWithKeyValues:obj];
                [accountLogAry addObject:accountLogModel];
            }];
        }
        zq_asyncDispatchToMainQueue(^{
            strongSelf.accountLogAry = accountLogAry;
            strongSelf.accountModel = [ZQAccountModel mj_objectWithKeyValues:dic[@"account"]];
        });
        
    } fail:^(NSString *errorDescription) {
        [strongSelf.accountTableView.mj_header endRefreshing];
        [strongSelf.accountTableView.mj_footer endRefreshing];
    }];
}

/** 请求账户流水 pageNumber 下一页  下一页行数 */
- (void)requestAccountLogPageNumber:(NSString *)pageNumber pageLine:(NSString *)pageLine
{
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    _currentPageNumber = [pageNumber integerValue];
    
    [AppCT.networkServices GET:kAPIURLAccountMoney parameter:@{page:pageNumber,line:pageLine} success:^(NSDictionary *dictionary) {
        
        [strongSelf.accountTableView.mj_header endRefreshing];
        [strongSelf.accountTableView.mj_footer endRefreshing];
        
        NSInteger requestStatus = [dictionary[status] integerValue];
        if (requestStatus != 0) {
            [SVProgressHUD showErrorWithStatus:dictionary[message]];
            [SVProgressHUD dismissWithDelay:1.0];
            return ;
        }
        
        NSDictionary *dic = dictionary[@"data"];
        
        NSMutableArray *array = dic[@"account_logs"];
        NSMutableArray *accountLogAry = [NSMutableArray arrayWithArray:self.accountLogAry];
        
        @autoreleasepool {
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ZQAccountLogModel *accountLogModel = [ZQAccountLogModel mj_objectWithKeyValues:obj];
                [accountLogAry addObject:accountLogModel];
            }];
        }
        zq_asyncDispatchToMainQueue(^{
            strongSelf.accountLogAry = accountLogAry;
            strongSelf.accountModel = [ZQAccountModel mj_objectWithKeyValues:dic[@"account"]];
        });
        
    } fail:^(NSString *errorDescription) {
        [strongSelf.accountTableView.mj_header endRefreshing];
        [strongSelf.accountTableView.mj_footer endRefreshing];
    }];
}


/** 设置下拉刷新，上拉加载 */
- (void)setupHeaderFooterRefresh
{
    MJRefreshGifHeader *gitHeader = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(mjRefreshHeaderAction)];

    [gitHeader setImages:self.idleImageAry forState:MJRefreshStateIdle];
    [gitHeader setImages:self.pullImageAry forState:MJRefreshStatePulling];
    [gitHeader setImages:self.pullImageAry forState:MJRefreshStateRefreshing];
    self.accountTableView.mj_header = gitHeader;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(mjRefreshFooterAction)];
    self.accountTableView.mj_footer = footer;
}

#pragma mark - 网络请求

- (UILabel *)labelWithTextColor:(UIColor *)textColor
{
    UILabel *label = [UILabel new];
    label.textColor = textColor ? textColor : [UIColor whiteColor];
    label.font = [UIFont fontWithName:kZQFontNameBold size:kZQTitleFont];
    label.textAlignment = NSTextAlignmentCenter;
    
    return label;
}

#pragma makr - Getter and Setter

- (void)setAccountModel:(ZQAccountModel *)accountModel
{
    _accountModel = accountModel;

    self.balanceLabel.text = [NSString stringWithFormat:@"余额:¥  %@",_accountModel.balance];
    self.vaildBalanceLabel.text = [NSString stringWithFormat:@"可用余额:¥  %@",_accountModel.valid_balance];
    self.cashFundLabel.text  = [NSString stringWithFormat:@"可提现金额:¥  %@",_accountModel.cash_fund];
    self.frozenFundLabel.text = [NSString stringWithFormat:@"冻结金额:¥  %@",_accountModel.frozen_fund];
}

- (void)setAccountLogAry:(NSArray *)accountLogAry
{
    _accountLogAry = accountLogAry;
    [self.accountTableView reloadData];
}

- (UITableView *)accountTableView
{
    if (!_accountTableView) {
        _accountTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _accountTableView.delegate = self;
        _accountTableView.dataSource = self;
//        [_accountTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
        [_accountTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZQAccountLogCell class]) bundle:nil] forCellReuseIdentifier:cellIdentifier];
    }
    return _accountTableView;
}

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.image = [UIImage imageNamed:@"background_black"];
    }
    return _backgroundImageView;
}

- (UILabel *)balanceLabel
{
    if (!_balanceLabel) {
        _balanceLabel = [self labelWithTextColor:[UIColor redColor]];
        _balanceLabel.text = @"余额:¥0.00";
    }
    return _balanceLabel;
}
- (UILabel *)vaildBalanceLabel
{
    if (!_vaildBalanceLabel) {
        _vaildBalanceLabel = [self labelWithTextColor:nil];
        _vaildBalanceLabel.text = @"可用余额:¥0.00";
    }
    return _vaildBalanceLabel;
}
- (UILabel *)frozenFundLabel
{
    if (!_frozenFundLabel) {
        _frozenFundLabel = [self labelWithTextColor:nil];
        _frozenFundLabel.text = @"冻结金额:¥0.00";
    }
    return _frozenFundLabel;
}
- (UILabel *)cashFundLabel
{
    if (!_cashFundLabel) {
        _cashFundLabel = [self labelWithTextColor:nil];
        _cashFundLabel.text  = @"可提现金额:¥0.00";
    }
    return _cashFundLabel;
}

#pragma mark - Dealloc

- (void)dealloc
{
    _accountLogAry = nil;
    _accountModel = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
