//
//  ZQOrderDetailView.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/20.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQOrderDetailView.h"
#import "Masonry.h"
#import "ZQMyOrderListModel.h"
#import "ZQOrderDetailHeader.h"
#import "ZQOrderDetailCell.h"
#import "ZQOrderDetailFooter.h"
#import "ZQOrderDetailTableFooter.h"


static NSString *const cellIdentifier = @"ZQOrderListDetailVCCellIdentifier";
static NSString *const headerIdentifier = @"ZQOrderListDetailVCHeaderIdentifier";
static NSString *const footerIdentifier = @"ZQOrderListDetailVCFooterIdentifier";

@interface ZQOrderDetailView ()<UITableViewDelegate,UITableViewDataSource>

/** 黑色的背景视图 */
@property (nonatomic) UIView *blackView;
/** 显示订单详情的tableView */
@property (nonatomic) UITableView *detailTableView;

/** 预订单是否展开 */
@property (nonatomic, assign) BOOL detailExpand;
/** 配送单是否展开 */
@property (nonatomic, assign) BOOL postDetailExpande;

/** 订单的数据 */
@property (nonatomic) ZQMyOrderListModel *orderModel;


#pragma mark- UITableView 的tableHeader tableFooter
/** 供应商Name */
@property (nonatomic) UILabel *shopNameLabel;
/** 联系电话 */
@property (nonatomic) UIButton *callPhoneBtn;
/** tableView footer */
@property (nonatomic) ZQOrderDetailTableFooter *tableViewFooter;

@end

@implementation ZQOrderDetailView

/**
 
 2个section块
 第一个section 显示detail 预订单数据
 第二个section 显示post_detail 配送单数据
 
 使用header  footer
 
 显示：
 供应商
 创建时间
 订单号
 订单商品列表
 状态
 总价
 备注：（这个备注可以在购物车section 里面添加一个输入框）
 price
 
 */


- (instancetype)init
{
    if (self = [super init]) {
        
        //可能有安全区域的危险
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self setupUI];
//        [self layoutWithAuto];
        [self layoutWithFrame];
    }
    return self;
}

#pragma mark - Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.detailExpand ? self.orderModel.details.count : 0;
    }
    return self.postDetailExpande ? self.orderModel.post_details.count : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    ZQOrderDetailHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    if (section == 0) {
        header.isExpand = self.detailExpand;
        header.title = @"预订单";
        header.expandClick = ^(BOOL isExpand) {
            strongSelf.detailExpand = isExpand;
        };
    }
    if (section == 1) {
        header.isExpand = self.postDetailExpande;
        header.title = @"配送单";
        header.expandClick = ^(BOOL isExpand) {
            strongSelf.postDetailExpande = isExpand;
        };
    }
    return header;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    ZQOrderDetailFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerIdentifier];
    
    if (section == 0) {
        footer.totalPriceStr = self.orderModel.price;
    } else {
        if (self.orderModel.post_price) {
            footer.totalPriceStr = self.orderModel.post_price;
        }
    }
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZQOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.section == 0) {
        ZQMyOrderListDetailModle *detailModel  = [ZQMyOrderListDetailModle mj_objectWithKeyValues:self.orderModel.details[indexPath.row]];
        cell.detailModel = detailModel;
    } else {
        ZQMyOrderListDetailModle *detailModel  = [ZQMyOrderListDetailModle mj_objectWithKeyValues:self.orderModel.post_details[indexPath.row]];
        cell.detailModel = detailModel;
    }
    return cell;
}


#pragma mark - Event response

/** 黑色背景视图的点击事件 */
- (void)blackViewClick
{
    [self hiddenOrderDetailView];
}

#pragma mark - Private method

- (void)setupUI
{
    [self addSubview:self.blackView];
    [self addSubview:self.detailTableView];
    [self setupTableHeaderView];
}

- (void)layoutWithFrame
{
    self.blackView.frame = self.bounds;
    self.detailTableView.frame = CGRectMake(30, kScreenHeight/8+20, kScreenWidth-60, kScreenHeight*3/4);
}
/** 表头 表尾 */
- (void)setupTableHeaderView
{
    self.shopNameLabel.frame = CGRectMake(0, 0, kScreenWidth-60, 40);
    self.detailTableView.tableHeaderView = self.shopNameLabel;
    self.detailTableView.tableFooterView = self.tableViewFooter;
}

#pragma mark - 订单详情的显示与隐藏
- (void)showOrderDetailViewModel:(ZQMyOrderListModel *)orderModel
{
    self.orderModel = orderModel;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.detailTableView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView animateWithDuration:0.5 animations:^{
        self.detailTableView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
}

- (void)hiddenOrderDetailView
{
    [UIView animateWithDuration:0.4 animations:^{
        self.detailTableView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        [self clearData];
    }];
}
/** 清理数据 */
- (void)clearData
{
    _detailExpand = _postDetailExpande = NO;
    _orderModel = nil;
}

#pragma mark - Dealloc

- (void)dealloc
{
    _detailExpand = _postDetailExpande = NO;
    _orderModel = nil;
}

#pragma mark - Getter and Setter

- (void)setOrderModel:(ZQMyOrderListModel *)orderModel
{
    _orderModel = orderModel;
    self.shopNameLabel.text = _orderModel.shop_name;
    self.tableViewFooter.orderModel = _orderModel;
    [self.detailTableView reloadData];
}

- (void)setDetailExpand:(BOOL)detailExpand
{
    _detailExpand = detailExpand;
    zq_asyncDispatchToMainQueue(^{
        [self.detailTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    });
}
- (void)setPostDetailExpande:(BOOL)postDetailExpande
{
    _postDetailExpande = postDetailExpande;
    zq_asyncDispatchToMainQueue(^{
        [self.detailTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    });
}

- (UIView *)blackView
{
    if (!_blackView) {
        _blackView = [[UIView alloc] init];
        _blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blackViewClick)];
        [_blackView addGestureRecognizer:tap];
    }
    return _blackView;
}

- (UITableView *)detailTableView
{
    if (!_detailTableView) {
        _detailTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _detailTableView.dataSource = self;
        _detailTableView.delegate = self;
        _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _detailTableView.showsVerticalScrollIndicator = NO;
        _detailTableView.showsHorizontalScrollIndicator = NO;

        [_detailTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZQOrderDetailCell class]) bundle:nil] forCellReuseIdentifier:cellIdentifier];
        [_detailTableView registerClass:[ZQOrderDetailHeader class] forHeaderFooterViewReuseIdentifier:headerIdentifier];
        [_detailTableView registerClass:[ZQOrderDetailFooter class] forHeaderFooterViewReuseIdentifier:footerIdentifier];
    }
    return _detailTableView;
}

- (UILabel *)shopNameLabel
{
    if (!_shopNameLabel) {
        _shopNameLabel = [[UILabel alloc] init];
        _shopNameLabel.font = [UIFont fontWithName:kZQFontNameBold size:kZQTitleFont];
    }
    return _shopNameLabel;
}

- (ZQOrderDetailTableFooter *)tableViewFooter
{
    if (!_tableViewFooter) {
        _tableViewFooter  = [[ZQOrderDetailTableFooter alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-60, 180)];
    }
    return _tableViewFooter;
}

@end
