//
//  ZQOrderRecordDetailVC.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/27.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQOrderRecordDetailVC.h"
#import "ZQOrderRecordDetailModel.h"
#import "ZQOrderRecordSkuModel.h"
#import "ZQOrderRecordModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ZQOrderRecordDetailCell.h"


static NSString *const cellIdentifier = @"ZQOrderRecordDetailVCCellIdentifier";

@interface ZQOrderRecordDetailVC ()<UITableViewDelegate,UITableViewDataSource>

/** 模板订单商品列表 */
@property (nonatomic) UITableView *tableView;
/** 列表的数据 */
@property (nonatomic) NSMutableArray *listDataSourceAry;

/** 订单模板详情model */
@property (nonatomic) ZQOrderRecordDetailModel *detailModel;


@end

@implementation ZQOrderRecordDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_listDataSourceAry) {
        _listDataSourceAry = [NSMutableArray array];
    }
    [self setupUI];
    [self layoutWithAuto];
   
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (AppCT.isUserLogin) {
        
        NSAssert(self.orderRecordModel != nil, @"所选的模板数据为空");
        if (!self.orderRecordModel) {
            return;
        }
        self.navigationItem.title = self.orderRecordModel.template_name;
        
        [self requestOrderReocrdDetailTemplate:self.orderRecordModel.template_id];
    } else {
        [AppCT showLoginVC];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kZQCellHeithtOrderRecordDetail;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listDataSourceAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZQOrderRecordDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    ZQOrderRecordSkuModel *skuModel = self.listDataSourceAry[indexPath.row];
    cell.skuModel = skuModel;
    return cell;
}

/** cell 的侧滑按钮 */
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        ZQOrderRecordSkuModel *skuModel = self.detailModel.template_details[indexPath.row];
        [self requestCellDeleteSkuWithTemplateID:self.orderRecordModel.template_id SkuID:skuModel.sku_id indexPath:indexPath];;
    }];
    return @[action];
}

#pragma mark - Event response

/** 添加订单模板数据到购物车 */
- (void)addOrderRecordToShopCart
{
    [ViewModel clearShopCartProduct];
    ViewModel.shopCartDataSource = [NSMutableArray arrayWithArray:self.detailModel.direct_order_template_details];
    
    ZQBaseViewController *viewCon = [self.navigationController.viewControllers firstObject];
    [self.navigationController popToViewController:viewCon animated:YES];
    zq_delayeDispatchToMainQueue(0.2, ^{
        viewCon.tabBarController.selectedIndex = 2;
    });
}


/** list  下拉刷新action */
- (void)tableViewHeaderRefreshAction
{
    [self requestOrderReocrdDetailTemplate:self.orderRecordModel.template_id];
}

#pragma mark - Private method

/**
 请求模板详情  template  订单模版名称或 id 或 编号
 
 @param template 订单模版名称或 id 或 编号
 */
- (void)requestOrderReocrdDetailTemplate:(NSString *)template
{
    NSAssert1((template != nil) && template.length != 0, @"订单模板订单模版名称或 id 或 编号 为空或者为空字符串",template);
    if (!template) {
        return;
    }
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    
    [AppCT.networkServices GET:kAPIURLOrderRecordDetailList parameter:@{@"template":template} success:^(NSDictionary *dictionary) {
        
        [strongSelf.tableView.mj_header endRefreshing];
        
        NSInteger requestStatus = [dictionary[status] integerValue];
        if (requestStatus != 0) {
            [SVProgressHUD showErrorWithStatus:dictionary[message]];
            [SVProgressHUD dismissWithDelay:1.0];
            return ;
        }
        
        NSDictionary *dic = dictionary[@"data"];
        strongSelf.detailModel = [ZQOrderRecordDetailModel mj_objectWithKeyValues:dic];
        
    } fail:^(NSString *errorDescription) {
        
    }];
}

/**
 模板删除单品 templateID 模板id skuID 单品id

 @param templateID 模板id
 @param skuID 单品id
 */
- (void)requestCellDeleteSkuWithTemplateID:(NSString *)templateID SkuID:(NSString *)skuID indexPath:(NSIndexPath *)indexPath
{
    
    NSAssert2((templateID != nil) && (skuID != nil), @"模板id 或者单品id 为空.模板id  =%@,单品id = %@", templateID, skuID);
    
    if (templateID == nil || skuID == nil) {
        return;
    }
    
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    
    [AppCT.networkServices GET:kAPIURLDeleteSKUIDToOrderRecord parameter:@{@"sid":skuID,@"tid":templateID} success:^(NSDictionary *dictionary) {
        
        NSInteger requestStatus = [dictionary[status] integerValue];
        if (requestStatus != 0) {
            [SVProgressHUD showErrorWithStatus:dictionary[message]];
            [SVProgressHUD dismissWithDelay:1.0];
            return;
        }

        [strongSelf requestOrderReocrdDetailTemplate:strongSelf.orderRecordModel.template_name];
        
    } fail:^(NSString *errorDescription) {
        
    }];
}


#pragma mark - Public method

- (void)setupUI
{
    [self.view addSubview:self.tableView];
    [self setupNavigationBarRightItem];
    [self setupTableViewHeaderFooterRefresh];
}

- (void)setupNavigationBarRightItem
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"加入购物车" style:UIBarButtonItemStylePlain target:self action:@selector(addOrderRecordToShopCart)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)layoutWithAuto
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        } else {
            make.top.left.bottom.right.equalTo(self.view);
        }
    }];
}
/** 设置list  下拉刷新 上拉加载 */
- (void)setupTableViewHeaderFooterRefresh
{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableViewHeaderRefreshAction)];
    [header setImages:self.idleImageAry forState:MJRefreshStateIdle];
    [header setImages:self.pullImageAry forState:MJRefreshStatePulling];
    [header setImages:self.pullImageAry forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
}


#pragma mark - Getter and Setter

- (void)setDetailModel:(ZQOrderRecordDetailModel *)detailModel
{
    _detailModel = detailModel;
    self.listDataSourceAry = [NSMutableArray arrayWithArray:_detailModel.template_details];
}

- (void)setListDataSourceAry:(NSMutableArray *)listDataSourceAry
{
    _listDataSourceAry = listDataSourceAry;
    [self.tableView reloadData];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[ZQOrderRecordDetailCell class] forCellReuseIdentifier:cellIdentifier];
    }
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
