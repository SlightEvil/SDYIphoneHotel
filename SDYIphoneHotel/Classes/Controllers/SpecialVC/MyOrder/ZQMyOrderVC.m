//
//  ZQMyOrderVC.m
//  SDYIphoneHotel
//
//  Created by admin on 2017/12/25.
//  Copyright © 2017年 SanDaoyi. All rights reserved.
//

#import "ZQMyOrderVC.h"
#import "ZQMyOrderListModel.h"
#import "ZQOrderListCell.h"
#import "ZQOrderDetailView.h"


static NSString *const cellIdentifier  = @"ZQMyOrderVCCellIdentifier";

@interface ZQMyOrderVC ()<UITableViewDelegate,UITableViewDataSource,ZQOrderListCellDelegate>

/** 分段控制器 选择 */
@property (nonatomic) UISegmentedControl *segmentedControl;
/** 订单列表 */
@property (nonatomic) UITableView *orderTableView;
/** 订单列表 DataSource */
@property (nonatomic) NSArray *listDataSource;

/** 显示订单状态显示订单列表的个数   目前5个  同时为分段控制器的个数 */
@property (nonatomic) NSArray *segmentedControlListOrderDataSource;


@end

@implementation ZQMyOrderVC
{
    /**
     请求订单的状态
     0 订单已提交
     1订单待配送   已取消
     2 订单待确认收货
     3订单已完成
     */
    NSString *_orderType;
    
    /** 当前的订单页 */
    NSInteger _currentPageNumber;
    
    CGFloat _width;
    CGFloat _height;
    /** 每页的行数 */
    NSString *_pageLine;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _width = self.view.bounds.size.width;
    _height = self.view.bounds.size.height;
    self.navigationItem.title = @"我的订单";
    
    _pageLine = @"15";
    
    [self setupUI];
    [self layoutWithAuto];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!AppCT.isUserLogin) {
        [AppCT showLoginVC];
        return;
    }
    [self requestOrderListWithPage:@"1" line:_pageLine status:_orderType];
}



#pragma mark - Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZQOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    ZQMyOrderListModel *model = self.listDataSource[indexPath.row];
    cell.orderListModel = model;
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZQMyOrderListModel *orderModel = self.listDataSource[indexPath.row];
    ZQOrderDetailView *detailView = [ZQOrderDetailView new];
    [detailView showOrderDetailViewModel:orderModel];
}
#pragma mark - cell 确认收货的代理实现
- (void)orderListCellReceiveClick:(NSIndexPath *)indexPath
{
    ZQMyOrderListModel *orderModel = self.listDataSource[indexPath.row];
    NSString *orderId = orderModel.order_id;
    [self requestUpdataOrderStatusOrderId:orderId statusNumber:@"3" indexPath:indexPath];
}


#pragma mark - Event response

/** 分段控制器的 点击事件 */
- (void)segmentedControlClick:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        self.type = ZQMyOrderSelectTypeAllOrder;
    }
    if (sender.selectedSegmentIndex == 1) {
        self.type = ZQMyOrderSelectTYpeCommit;
    }
    if (sender.selectedSegmentIndex == 2) {
        self.type = ZQMyOrderSelectTypeReceive;
    }
    if (sender.selectedSegmentIndex == 3) {
        self.type = ZQMyOrderSelectTypeComplete;
    }
//    if (sender.selectedSegmentIndex == 4) {
//        self.type = ZQMyOrderSelectTypeComplete;
//    }

    [self requestOrderListWithPage:@"1" line:_pageLine status:_orderType];
}

/** 下拉刷新动作 */
- (void)headerRefreshAction
{
    [self requestOrderListWithPage:@"1" line:_pageLine status:_orderType];
}

/** 上拉加载动作 */
- (void)footerRefreshAction
{
    [self requestOrderListWithPage:[NSString stringWithFormat:@"%zd",(_currentPageNumber + 1)] line:_pageLine status:_orderType];

    NSLog(@"执行一次  %zd",_currentPageNumber);
}

#pragma mark - Private medthod

- (void)setupUI
{
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.orderTableView];
    [self setupTableViewHeaderFooterRefresh];
}

- (void)layoutWithAuto
{
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        } else {
            make.top.left.right.equalTo(self.view);
        }
        make.height.mas_equalTo(40);

    }];
    [self.orderTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentedControl.mas_bottom);
        make.left.right.equalTo(self.segmentedControl);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
    }];
}

/** 设置下拉刷新和上拉加载 */
- (void)setupTableViewHeaderFooterRefresh
{
    MJRefreshGifHeader *gitHeader = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshAction)];
    
    NSArray *idleImageAry = self.idleImageAry;
    NSArray *pullRefreshImageAry = self.pullImageAry;
    
    [gitHeader setImages:idleImageAry forState:MJRefreshStateIdle];
    [gitHeader setImages:pullRefreshImageAry forState:MJRefreshStatePulling];
    [gitHeader setImages:pullRefreshImageAry forState:MJRefreshStateRefreshing];
    self.orderTableView.mj_header = gitHeader;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshAction)];
    self.orderTableView.mj_footer = footer;
}
//
///**  设置普通状态的动画图片 */
//- (NSArray *)IdleImageArray
//{
//    NSMutableArray *idleImages = [NSMutableArray array];
//    for (NSUInteger i = 1; i<=60; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
//        [idleImages addObject:image];
//    }
//    
//    return idleImages;
//}
///** 设置即将刷新状态的动画图片（一松开就会刷新的状态)  设置正在刷新状态的动画图片 */
//- (NSArray *)PullRefreshingImageAry
//{
//    NSMutableArray *refreshingImages = [NSMutableArray array];
//    for (NSUInteger i = 1; i<=3; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
//        [refreshingImages addObject:image];
//    }
//    return refreshingImages;
//}

/**
 请求订单信息 parameter pageNumber 请求的第几页 lineNumber 一页有几行  statusNumber 指定状态的订单

 @param pageNumber 请求的第几页
 @param lineNumber 一页有几行
 @param statusNumber 指定状态的订单
 */
- (void)requestOrderListWithPage:(NSString *)pageNumber line:(NSString *)lineNumber status:(NSString *)statusNumber
{
    _currentPageNumber = [pageNumber integerValue];
    
    if ([pageNumber isEqualToString:@"1"]) {
        [self.orderTableView setContentOffset:CGPointZero animated:NO];
    }
    
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;

    [AppCT.networkServices GET:kAPIURLOrderList parameter:@{page:pageNumber,line:lineNumber,status:statusNumber} success:^(NSDictionary *dictionary) {
        
        [strongSelf.orderTableView.mj_header endRefreshing];
        [strongSelf.orderTableView.mj_footer endRefreshing];
        
        //设置data数组 停止刷新， 如果是上拉加载 则添加之前的数据
        NSMutableArray *dataSourceArray = [NSMutableArray array];
        if ([pageNumber isEqualToString:@"1"]) {
        } else {
            //上拉加载
            [dataSourceArray addObjectsFromArray:strongSelf.listDataSource];
        }
        //错误代码
        NSInteger requestStatus = [dictionary[status]  integerValue];
        if (requestStatus != 0) {
            [SVProgressHUD showErrorWithStatus:dictionary[message]];
            [SVProgressHUD dismissWithDelay:1.0];
            return ;
        }
        //枚举
        NSArray *array = dictionary[@"data"];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZQMyOrderListModel *model = [ZQMyOrderListModel mj_objectWithKeyValues:obj];
            [dataSourceArray addObject:model];
        }];
        //DataSource重新赋值
        zq_asyncDispatchToMainQueue(^{
            strongSelf.listDataSource = dataSourceArray;
        });
    } fail:^(NSString *errorDescription) {
        [strongSelf.orderTableView.mj_header endRefreshing];
        [strongSelf.orderTableView.mj_footer endRefreshing];
    }];
}

/**
 更行订单状态  一般为确认收货 orderId 订单的Id  statusNumber 状态码 一般为3 indexPath index    

 @param orderId 订单的id
 @param statusNumber 状态码0 提交，1待配送，2带收货，3已完成
 @param indexPath cell 所在的index
 */
- (void)requestUpdataOrderStatusOrderId:(NSString *)orderId statusNumber:(NSString *)statusNumber indexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    
    [AppCT.networkServices GET:kAPIURLUpdateOrderStatus parameter:@{@"id":orderId,status:statusNumber} success:^(NSDictionary *dictionary) {
        
        NSInteger requestStatus = [dictionary[status] integerValue];
        if (requestStatus != 0) {
            [SVProgressHUD showErrorWithStatus:dictionary[message]];
            [SVProgressHUD dismissWithDelay:1.0];
            return ;
        }
        
        [SVProgressHUD showSuccessWithStatus:dictionary[message]];
        [SVProgressHUD dismissWithDelay:1.0];
        
        zq_asyncDispatchToMainQueue(^{
            NSMutableArray *array = [NSMutableArray arrayWithArray:strongSelf.listDataSource];
            [array removeObjectAtIndex:indexPath.row];
            strongSelf.listDataSource = array;
        });
        
    } fail:^(NSString *errorDescription) {
        
    }];
}

#pragma mark - Dealloc
- (void)dealloc
{
    _listDataSource = nil;
}


#pragma mark - Getter and Setter

/** 使用setter 修改请求订单的状态 */
- (void)setType:(ZQMyOrderSelectType)type
{
    _type = type;
    
    switch (_type) {
        case ZQMyOrderSelectTypeAllOrder:
        {
            self.segmentedControl.selectedSegmentIndex = 0;
            _orderType = @"";
        }
            break;
        case ZQMyOrderSelectTYpeCommit:
        {
            self.segmentedControl.selectedSegmentIndex = 1;
            _orderType = @"0";
        }
            break;
        case ZQMyOrderSelectTypeReceive:
        {
            self.segmentedControl.selectedSegmentIndex = 2;
            _orderType = @"2";
        }
            break;
        case ZQMyOrderSelectTypeComplete:
        {
            self.segmentedControl.selectedSegmentIndex = 3;
            _orderType = @"3";
        }
            break;
        default:
            break;
    }
}

- (void)setListDataSource:(NSArray *)listDataSource
{
    _listDataSource = listDataSource;
//    zq_asyncDispatchToMainQueue(^{
         [self.orderTableView reloadData];
//    });
}

- (UITableView *)orderTableView
{
    if (!_orderTableView) {
        _orderTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _orderTableView.delegate = self;
        _orderTableView.dataSource = self;
        [_orderTableView registerClass:[ZQOrderListCell class] forCellReuseIdentifier:cellIdentifier];
    }
    return _orderTableView;
}

- (NSArray *)segmentedControlListOrderDataSource
{
    if (!_segmentedControlListOrderDataSource) {
        _segmentedControlListOrderDataSource = @[@"全部",@"已提交",@"待收货",@"已完成"];
    }
    return _segmentedControlListOrderDataSource;
}

- (UISegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:self.segmentedControlListOrderDataSource];
        
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName : kZQTabbarTintColor} forState:UIControlStateSelected];
        _segmentedControl.tintColor = self.view.backgroundColor;
        
        [_segmentedControl setDividerImage:[UIImage imageNamed:@"icon_unSelectLine"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [_segmentedControl setDividerImage:[UIImage imageNamed:@"icon_selectLine"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [_segmentedControl setDividerImage:[UIImage imageNamed:@"icon_selectLine"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        
        [_segmentedControl addTarget:self action:@selector(segmentedControlClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
