//
//  ZQHomeVC.m
//  SDYIphoneHotel
//
//  Created by admin on 2017/12/25.
//  Copyright © 2017年 SanDaoyi. All rights reserved.
//

#import "ZQHomeVC.h"
#import "ZQProductListVC.h"
#import "ZQHomeMyOrderCell.h"
#import "ZQMyOrderVC.h"
#import "ZQOrderRecordVC.h"



static NSString *const ZQHomeVCSelectProductCellIdentifier = @"ZQHomeVCSelectProductCellIdentifier";
static NSString *const ZQHomeVCOrderCellIdentifier = @"ZQHomeVCOrderCellIdentifier";


@interface ZQHomeVC () <UITableViewDelegate,UITableViewDataSource>

/** button tableview */
@property (nonatomic) UITableView *tableView;


@property (nonatomic) NSArray *dataSourceAry;

@end

/*
 1、选择商品
 2、查看订单
 3、我的收藏
 */

@implementation ZQHomeVC
{
    CGFloat _viewWidth; //view 的宽度
    CGFloat _viewHeight;//view 的高度
    CGFloat _cellHeight;//cell的高度
    CGFloat _tableViewHeaderHeight; //tableviewHeader的高度
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _viewWidth = self.view.bounds.size.width;
    _viewHeight = self.view.bounds.size.height;
    _cellHeight = 49;
    _tableViewHeaderHeight = 100;
    
    CGFloat tableHeight = 0;
    
    for (NSArray *ary in self.dataSourceAry) {
        tableHeight += ary.count * _cellHeight;
    }
    
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Delegate
#pragma mark - UITableView 代理和DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100;
    }
    return 49;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 20)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSourceAry.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.dataSourceAry[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        __weak typeof(self)weakSelf = self;
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        ZQHomeMyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:ZQHomeVCOrderCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.CellSelectIndex = ^(NSUInteger index) {
            zq_asyncDispatchToMainQueue(^{
                //根据tag 设置的
                [strongSelf cellSelectMyOrderIndex:index];
            });
        };
        
        return cell;
    }
    
     NSArray *array = self.dataSourceAry[indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZQHomeVCSelectProductCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = array[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self cellSelectCategoty];
        }
        if (indexPath.row == 1) {
            [self cellSelectRecord];
        }
    }
}


#pragma mark - Event response

/** 我的订单 */
- (void)cellSelectMyOrderIndex:(NSInteger)index
{
    ZQMyOrderVC *orderVC = [[ZQMyOrderVC alloc]init];
    orderVC.type = [self orderTypeWithIndex:index];
    orderVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderVC animated:YES];

}
/** 根据点击的imageView 的tag 返回订单的类型 */
- (ZQMyOrderSelectType)orderTypeWithIndex:(NSInteger)index
{
    /**
     全部 “”
     1 已提交 已提交  取消待配送
     2 待接收
     3 已完成
     4  全部
     */
    switch (index) {
        case 1:
            return ZQMyOrderSelectTYpeCommit;
            break;
        case 2:
            return ZQMyOrderSelectTypeReceive;
            break;
        case 3:
            return ZQMyOrderSelectTypeComplete;
            break;
        case 4:
            return ZQMyOrderSelectTypeAllOrder;
            break;
        default:
            return ZQMyOrderSelectTypeAllOrder;
            break;
    }
}

/** 选择商品分类 */
- (void)cellSelectCategoty
{
//    self.tabBarController.selectedIndex = 1;
    ZQOrderRecordVC *orderRecordVC = [ZQOrderRecordVC new];
    orderRecordVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderRecordVC animated:YES];
}
/** 我的收藏 */
- (void)cellSelectRecord
{
    ZQProductListVC *listVC = [[ZQProductListVC alloc] init];
    listVC.productListType = ZQProductListTypeRecord;
    listVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listVC animated:YES];
}
///** 订单收藏 */
//- (void)cellOrderRecord
//{
//    ZQOrderRecordVC *orderRecordVC = [ZQOrderRecordVC new];
//    orderRecordVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:orderRecordVC animated:YES];
//}

#pragma mark - Private medthod




#pragma mark - Getter and Setter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = self.view.backgroundColor;
        //cell 间隔样式 为none
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ZQHomeVCSelectProductCellIdentifier];
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ZQHomeVCOrderCellIdentifier];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZQHomeMyOrderCell class]) bundle:nil] forCellReuseIdentifier:ZQHomeVCOrderCellIdentifier];
    }
    return _tableView;
}

- (NSArray *)dataSourceAry
{
    if (!_dataSourceAry) {
        _dataSourceAry = @[@[ZQHomeVCSelectProductCellIdentifier],@[@"立即下单",@"我的收藏"]];
    }
    return _dataSourceAry;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
