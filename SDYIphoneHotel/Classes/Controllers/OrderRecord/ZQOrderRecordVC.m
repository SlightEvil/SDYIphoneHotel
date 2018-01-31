//
//  ZQOrderRecordVC.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/25.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQOrderRecordVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ZQAddNewOrderRecordV.h"
#import "ZQOrderRecordModel.h"
#import "ZQOrderRecordSkuModel.h"
#import "ZQOrderRecordDetailVC.h"
//#import "ZQOrderRecordAddSkuModel.h"





static NSString *const cellIdentifier = @"ZQOrderRecordVCCellIdentifier";

@interface ZQOrderRecordVC ()<UITableViewDelegate,UITableViewDataSource,ZQAddNewOrderRecordVDelegate>

/** 新增订单模板V */
@property (nonatomic) ZQAddNewOrderRecordV *addNewOrderRecordV;

/** 订单模板列表 */
@property (nonatomic) UITableView *listTableView;

/** 订单模板的DataSource */
@property (nonatomic) NSMutableArray *orderRecordListAry;
/** 重命名  选择的模板index */
@property (nonatomic) NSIndexPath *indexPath;
/** 是否更新模板 */
@property (nonatomic, assign) BOOL isUpdataOrderReocrd;

@end

@implementation ZQOrderRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
  
    [self setupNavigation];
    [self setupUI];
    [self layoutWithAuto];
    [self setupTableViewHeaderRefresh];
    

    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (AppCT.isUserLogin) {
        [self requestOrderRecordList];
    } else {
        [AppCT showLoginVC];
    }
}



#pragma mark -  System Delegate

#pragma mark - UITableViewDelete

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kZQCellHeightOrderRecord;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderRecordListAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    ZQOrderRecordModel *model = self.orderRecordListAry[indexPath.row];
    cell.textLabel.text = model.template_name;
    cell.detailTextLabel.text = model.template_description;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZQOrderRecordModel *orderRecordModel = self.orderRecordListAry[indexPath.row];
//    NSString *templeId = orderRecordModel.template_id;
    
    ZQOrderRecordDetailVC *detailVC = [ZQOrderRecordDetailVC new];
    detailVC.orderRecordModel = orderRecordModel;
    [self.navigationController pushViewController:detailVC animated:YES];
}

/** cell  的 action */
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        ZQOrderRecordModel *model = self.orderRecordListAry[indexPath.row];
    
        self.indexPath = indexPath;
        self.isUpdataOrderReocrd = YES;
        
        self.addNewOrderRecordV.nameString = model.template_name;
        if (model.template_description) {
            self.addNewOrderRecordV.describeString = model.template_description;
        }
        [self rightItemButtonClick];
    }];
    
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        ZQOrderRecordModel *orderRecordModel = self.orderRecordListAry[indexPath.row];
        NSString *templateId = orderRecordModel.template_id;
        [self requestDeleteOrderRecordTemplateID:templateId indexPath:indexPath];
    }];
    return @[action2,action1];
}


#pragma mark - Other Delegate

/** 新增订单模板  更新订单模板 */
- (void)confirmButtonClickAction:(NSString *)nameStr describe:(NSString *)describeStr
{
    if (self.isUpdataOrderReocrd) {
        ZQOrderRecordModel *orderRecord = self.orderRecordListAry[self.indexPath.row];
        [self requestUpdataOrderRecordName:nameStr OrderRecordDescribe:describeStr templateId:orderRecord.template_id];
        
    } else {
        [self requestAddNewOrderRecord:nameStr OrderRecordDescribe:describeStr];
    }
}


#pragma mark - Event response


/** rightitem click */
- (void)rightItemButtonClick
{
    [self.addNewOrderRecordV show];
}
/** 下拉刷新action */
- (void)tableHeaderRefreshAction
{
    [self requestOrderRecordList];
}


#pragma mark - Pribate method
/** 设置导航栏 */
- (void)setupNavigation
{
    self.navigationItem.title = @"订单收藏";
    UIButton *addNewOrderRecord = [UIButton buttonWithType:UIButtonTypeCustom];
    addNewOrderRecord.titleLabel.font = [UIFont fontWithName:kZQFontNameBold size:kZQTitleFont];
    [addNewOrderRecord setTitle:@"添加" forState:UIControlStateNormal];
    [addNewOrderRecord setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addNewOrderRecord addTarget:self action:@selector(rightItemButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:addNewOrderRecord];
    self.navigationItem.rightBarButtonItem = rightItem;
}
/** 设置UI */
- (void)setupUI
{
    [self.view addSubview:self.listTableView];
}
/** 布局 */
- (void)layoutWithAuto
{
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
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
/** 设置下拉刷新 */
- (void)setupTableViewHeaderRefresh
{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(tableHeaderRefreshAction)];
    
    NSArray *idleImageAry = self.idleImageAry;
    NSArray *pullRefreshImageAry = self.pullImageAry;
    [header setImages:idleImageAry forState:MJRefreshStateIdle];
    [header setImages:pullRefreshImageAry forState:MJRefreshStatePulling];
    [header setImages:pullRefreshImageAry forState:MJRefreshStateRefreshing];
    
    self.listTableView.mj_header = header;
}

#pragma mark - 网络请求

/** 请求订单模板列表 */
- (void)requestOrderRecordList
{
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    
    [AppCT.networkServices GET:kAPIURLOrderRecordList parameter:@{} success:^(NSDictionary *dictionary) {
        
        [strongSelf.listTableView.mj_header endRefreshing];
        
        NSInteger requestStatus = [dictionary[status] integerValue];
        if (requestStatus != 0) {
            [SVProgressHUD showErrorWithStatus:dictionary[message]];
            [SVProgressHUD dismissWithDelay:1.0];
            return ;
        }
        
        NSArray *dataSource = dictionary[@"data"];
        NSMutableArray *array = [NSMutableArray array];
        [dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZQOrderRecordModel *model = [ZQOrderRecordModel mj_objectWithKeyValues:obj];
            [array addObject:model];
        }];
        
        strongSelf.orderRecordListAry = array;
    
    } fail:^(NSString *errorDescription) {
         [strongSelf.listTableView.mj_header endRefreshing];
    }];
}


/**
 添加 新的订单模板

 @param nameStr 名称
 @param describeStr 模板描述
 */
- (void)requestAddNewOrderRecord:(NSString *)nameStr OrderRecordDescribe:(NSString *)describeStr
{
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (nameStr) {
        [dic setObject:nameStr forKey:name];
    }
    if (describeStr && (describeStr.length != 0)) {
        [dic setObject:describeStr forKey:@"description"];
    }

    /* @{@"name":nameStr,@"description":describeStr} */

    [AppCT.networkServices POST:kAPIURLAddNewOrderRecord parameter:dic success:^(NSDictionary *dictionary) {
        
        NSInteger requestStatus = [dictionary[status] integerValue];
        if (requestStatus != 0) {
            [SVProgressHUD showErrorWithStatus:dictionary[message]];
            [SVProgressHUD dismissWithDelay:1.0];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:dictionary[message]];
        [SVProgressHUD dismissWithDelay:1.0];
        
        [strongSelf requestOrderRecordList];
        
    } fail:^(NSString *errorDescription) {
        
    }];
}

/**
 删除订单模板 templateID 模板id indexPath indexPath
 
 @param templateID 模板id
 @param indexPath indexPath
 */
- (void)requestDeleteOrderRecordTemplateID:(NSString *)templateID indexPath:(NSIndexPath *)indexPath
{
    NSAssert1((templateID != nil) && (templateID.length != 0), @"模板id 为nil或者为空字符串. 模板id = %@",templateID);
    if (!templateID) {
        return;
    }
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    [AppCT.networkServices GET:kAPIURLDeleteOrderRecord parameter:@{@"tid":templateID} success:^(NSDictionary *dictionary) {
        
        NSInteger requestStatus = [dictionary[status] integerValue];
        if (requestStatus != 0) {
            [SVProgressHUD showErrorWithStatus:dictionary[message]];
            [SVProgressHUD dismissWithDelay:1.0];
            return ;
        }
        [strongSelf.orderRecordListAry removeObjectAtIndex:indexPath.row];
        [strongSelf.listTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } fail:^(NSString *errorDescription) {
        
    }];
}

/**
 更新订单模板

 @param nameStr 名称
 @param describeStr 描述
 @param templateID 模板id
 */
- (void)requestUpdataOrderRecordName:(NSString *)nameStr OrderRecordDescribe:(NSString *)describeStr templateId:(NSString *)templateID
{
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    
    [AppCT.networkServices POST:kAPIURLUpdateOrderRecord parameter:@{@"tid":templateID,@"name":nameStr,@"description":describeStr} success:^(NSDictionary *dictionary) {
        
        NSInteger requestStatus = [dictionary[status] integerValue];
        if (requestStatus != 0) {
            [SVProgressHUD showErrorWithStatus:dictionary[message]];
            [SVProgressHUD dismissWithDelay:1.0];
            return ;
        }
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@",dictionary[message]]];
        [SVProgressHUD dismissWithDelay:1.0];
        /** 刷新订单为NO */
        strongSelf.isUpdataOrderReocrd = NO;
        
        /** 0.5秒后刷新界面 */
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [strongSelf requestOrderRecordList];
        });

        
    } fail:^(NSString *errorDescription) {
        
    }];
}

- (void)dealloc
{
    _isUpdataOrderReocrd = NO;
}

#pragma mark - Getter and Setter

- (void)setOrderRecordListAry:(NSMutableArray *)orderRecordListAry
{
    _orderRecordListAry = orderRecordListAry;
    [self.listTableView reloadData];
}

- (ZQAddNewOrderRecordV *)addNewOrderRecordV
{
    if (!_addNewOrderRecordV) {
        _addNewOrderRecordV = [[ZQAddNewOrderRecordV alloc] init];
        _addNewOrderRecordV.delegate = self;
        _addNewOrderRecordV.isNeedDescribe = YES;
    }
    return _addNewOrderRecordV;
}

- (UITableView *)listTableView
{
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] initWithFrame:CGRectZero];
        
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.showsVerticalScrollIndicator = NO;
        _listTableView.showsHorizontalScrollIndicator = NO;
        
//        [_listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    }
    return _listTableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
