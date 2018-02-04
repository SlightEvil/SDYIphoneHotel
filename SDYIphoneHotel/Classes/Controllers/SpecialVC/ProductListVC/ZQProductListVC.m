//
//  ZQProductListVC.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/9.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQProductListVC.h"
#import "ZQProductDetailModel.h"
#import "ZQProductListCell.h"
#import "ZQProductDetailV.h"


static NSString *cellIdentifier = @"ZQProductListVCCellIdentifier";

@interface ZQProductListVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,ZQProductDetailVDeleagte>

/** 列表的DataSource */
@property (nonatomic) NSMutableArray *listDataSource;
/** 收藏商品列表  搜索藏品的时候代替上面 显示数据的数组  */
@property (nonatomic) NSMutableArray *listDataSourceWithRecord;
/** 判断是否是收藏商品列表在搜索商品  默认为NO */
@property (nonatomic, assign) BOOL isRecordSearch;

/** 点击的cell index */
@property (nonatomic, assign) NSInteger index;

/** 商品列表 */
@property (nonatomic) UITableView *productTableView;
/** 显示商品详情View */
@property (nonatomic) ZQProductDetailV *productView;
/** 搜索框 */
@property (nonatomic) UISearchBar *searchBar;


@end

@implementation ZQProductListVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.productListType) {
        self.productListType = ZQProductListTypeCategory;
    }
    self.isRecordSearch = NO;
    [self setupUI];
    [self layoutWithAuto];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (AppCT.isUserLogin) {
        [self typeChangeWithType:self.productListType];
    } else {
        [AppCT showLoginVC];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hideProductDetailView];
    [self.navigationController.navigationBar endEditing:YES];
}


#pragma mark - Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //是否为搜索藏品
    return self.isRecordSearch ? self.listDataSourceWithRecord.count : self.listDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZQProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.productModel = self.isRecordSearch ? self.listDataSourceWithRecord[indexPath.row] : self.listDataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar endEditing:YES];
    [self.view endEditing:YES];
    
    self.index = indexPath.row;
    ZQProductDetailModel *model = self.listDataSource[indexPath.row];
    [self requestProductDetailWithProductID:model.product_id];
}

#pragma mark - UISearchBarDelegate

/**
 实现搜索的代理
 2、搜索藏品，开始输入，就开始在收藏品 中进行搜索。
 */

/**
 return NO to not become first responder
 */
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    //开始搜索的时候 重新赋值搜索数据
    if (self.productListType == ZQProductListTypeRecord) {
        self.isRecordSearch = YES;
        self.listDataSourceWithRecord = [NSMutableArray arrayWithArray:self.listDataSource];
    }
    return YES;
}

/**
  called when text ends editing
 */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if (searchBar.isFirstResponder) {
        [searchBar resignFirstResponder];
    }
}

/**
 called when text changes (including clear)
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.productListType == ZQProductListTypeRecord) {
        
        //搜索框里面的文字为空的时候 重新赋值
        if ([searchText isEqualToString:@""]) {
            self.listDataSourceWithRecord = [NSMutableArray arrayWithArray:self.listDataSource];
        } else {
            //每次搜索框里面的文字开始改变的时候 都从原来藏品列表从新获取数据
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.listDataSource];
            
            [self.listDataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ZQProductDetailModel *detailModel = obj;
                
                // 商品name 是否包含搜索框里面的文字  不包含怎过滤掉
                BOOL isContain =  [detailModel.product_name containsString:searchText];
                if (!isContain) {
                    [array removeObject:detailModel];
                }
            }];
            self.listDataSourceWithRecord  = array;
        }
    }
}

/**
 called when keyboard search button pressed
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    if (self.productListType == ZQProductListTypeSearchResult) {
        [self requestProductWithCat:nil name:searchBar.text page:nil line:nil];
    }
    if (self.productListType == ZQProductListTypeRecord) {
        
    }
}

/**
 called when cancel button pressed
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - ZQProductDetailVDeleagte  商品详情的代理事件  添加新商品 收藏商品

- (void)productAddNewProduct:(ZQAddNewProductModel *)newProduct
{
    zq_asyncDispatchToGlobalQueue(^{
        [ViewModel addNewProductToShopCart:newProduct];
    });
    [SVProgressHUD showSuccessWithStatus:@"商品已添加到购物车"];
    [SVProgressHUD dismissWithDelay:1.0];
    
    [self hideProductDetailView];
}

- (void)productRecordSuccessForIsCancelRecord:(BOOL)isCancelRecord
{
#pragma mark - 如果是取消收藏  则删除该收藏商品   dismiss  商品详情界面。防止商品界面一直显示，一直删除商品的index
    //如果当前界面为我的收藏
    if (self.productListType == ZQProductListTypeRecord) {
        /*如果是取消收藏  则删除该收藏商品   dismiss  商品详情界面。
         防止商品界面一直显示，一直删除商品的index
         */
        if (isCancelRecord) {
            zq_asyncDispatchToMainQueue(^{
                [self.productView hiddenDetailView];
                [self.listDataSource removeObjectAtIndex:self.index];
                [self.productTableView reloadData];
            });
        }
    }
}


#pragma mark - Event response

/** DataSource来源为 分类 */
- (void)productListTypeCategoryAction
{
    //设置下拉刷新
    [self setupHeaderFooterRefresh];
    [self requestProductWithCat:self.productCategoryID name:nil page:nil line:nil];
}
/** DataSource 来源为 我的收藏 */
- (void)productListTypeRecordAction
{
    //设置下拉刷新
     [self setupHeaderFooterRefresh];
    self.navigationItem.titleView = self.searchBar;
    [self requestRecordProductList];
}
/** DataSource 来源为 搜索结果 */
- (void)productListTypeSearchResultAction
{
    self.navigationItem.titleView = self.searchBar;
}
/** 下拉刷新 */
- (void)mjRefreshHeaderAction
{
    switch (self.productListType) {
        case ZQProductListTypeCategory:
            [self requestProductWithCat:self.productCategoryID name:nil page:nil line:nil];
            break;
        case ZQProductListTypeRecord:
            [self requestRecordProductList];
            break;
        case ZQProductListTypeSearchResult:
            
            break;
            
        default:
            break;
    }
}
///** 上拉加载 */
//- (void)mjRefreshFooterAction
//{
//
//}

#pragma mark - Private medthod

/** 添加UI */
- (void)setupUI
{
    [self.view addSubview:self.productTableView];
}
/** 布局 */
- (void)layoutWithAuto
{
    [self.productTableView  mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        } else {
            make.bottom.equalTo(self.view);
            make.top.left.right.equalTo(self.view);
        }
    }];
}

/** 请求收藏列表 */
- (void)requestRecordProductList
{
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    
    [AppCT.networkServices GET:kAPIURLReocrdProductList parameter:@{@"uid":AppCT.loginUser.user_id} success:^(NSDictionary *dictionary) {
        
        [strongSelf.productTableView.mj_header endRefreshing];
        if ([dictionary[status] integerValue] != 0) {
            [AppCT showError:dictionary[message] dismiss:1.0];
            return ;
        }
    
        NSArray *array = dictionary[@"data"];
        NSMutableArray *dataSourceAry = [NSMutableArray array];
        //存放到userdefault
        NSMutableArray *userDefaultAry = [NSMutableArray array];
        
        @autoreleasepool {
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ZQProductDetailModel *model = [ZQProductDetailModel mj_objectWithKeyValues:obj];
                [dataSourceAry addObject:model];
                [userDefaultAry addObject:model.product_id];
            }];
        }
        strongSelf.listDataSource = dataSourceAry;
        //保存商品id到userDefault
        [ZQUserDefault saveValue:userDefaultAry forKey:UDKRecordProductID];
        
    } fail:^(NSString *errorDescription) {
         [strongSelf.productTableView.mj_header endRefreshing];
    }];
}

/**
 请求商品列表 cat 商品分类id  name 商品名称 page 当前页码  line 每页的行数
 
 @param cat 商品分类id
 @param name 商品名称
 @param page 当前页码
 @param line 每页的行数
 */
- (void)requestProductWithCat:(NSString *)cat name:(NSString *)name page:(NSString *)page line:(NSString *)line
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (cat) {
        [parameters setObject:cat forKey:@"cat"];
    }
    if (name) {
        [parameters setObject:name forKey:@"name"];
    }
    if (page) {
        [parameters setObject:page forKey:@"p"];
    }
    if (line) {
        [parameters setObject:line forKey:@"len"];
    }
    __weak typeof(self)WeakSelf = self;
    __strong typeof(WeakSelf)strongSelf = WeakSelf;
    
    [AppCT.networkServices GET:kAPIURLProductList parameter:parameters success:^(NSDictionary *dictionary) {
        
        [strongSelf.productTableView.mj_header endRefreshing];
        
        NSInteger requestStatus = [dictionary[status] integerValue];
        if (requestStatus != 0) {
            [SVProgressHUD showErrorWithStatus:dictionary[message]];
            [SVProgressHUD dismissWithDelay:1.0];
            return ;
        }
        
        NSArray *dataAry = dictionary[@"data"];
        
        if (dataAry.count == 0) {
            [SVProgressHUD showErrorWithStatus:@"没有搜索到相关的商品"];
            [SVProgressHUD dismissWithDelay:1.5];
            return;
        }
        
        NSMutableArray *array = [NSMutableArray array];
        @autoreleasepool {
            [dataAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ZQProductDetailModel *detailModel = [ZQProductDetailModel mj_objectWithKeyValues:obj];
                [array addObject:detailModel];
            }];
        }
        strongSelf.listDataSource = array;
        
    } fail:^(NSString *errorDescription) {
        [strongSelf.productTableView.mj_header endRefreshing];
    }];
}

/**
 请求商品详情  parameter product_id

 @param productID sh
 */
- (void)requestProductDetailWithProductID:(NSString *)productID
{
    if (!productID) {
        return;
    }
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    
    [AppCT.networkServices GET:kAPIURLProductDetail parameter:@{@"id":productID} success:^(NSDictionary *dictionary) {
        NSInteger requestStatus = [dictionary[status] integerValue];
        if (requestStatus != 0) {
            [SVProgressHUD showErrorWithStatus:dictionary[message]];
            [SVProgressHUD dismissWithDelay:1.0];
            return;
        }
        NSDictionary *dic = dictionary[@"data"];
        [strongSelf showProductDetailView:dic];
    
    } fail:nil];
}


/** 设置下拉刷新，上拉加载 */
- (void)setupHeaderFooterRefresh
{
    MJRefreshGifHeader *gitHeader = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(mjRefreshHeaderAction)];
    
    NSArray *idleImageAry = self.idleImageAry;
    NSArray *pullRefreshImageAry = self.pullImageAry;
    
    [gitHeader setImages:idleImageAry forState:MJRefreshStateIdle];
    [gitHeader setImages:pullRefreshImageAry forState:MJRefreshStatePulling];
    [gitHeader setImages:pullRefreshImageAry forState:MJRefreshStateRefreshing];
    self.productTableView.mj_header = gitHeader;
    
//    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(mjRefreshFooterAction)];
//    self.productTableView.mj_footer = footer;
}



/** 根据来源类型设置数据 */
- (void)typeChangeWithType:(ZQProductListType)type
{
    switch (type) {
        case ZQProductListTypeCategory:
            [self productListTypeCategoryAction];
            break;
        case ZQProductListTypeRecord:
            [self productListTypeRecordAction];
            break;
        case ZQProductListTypeSearchResult:
            [self productListTypeSearchResultAction];
            break;
        default:
            break;
    }
}
/** 添加blackView  detailView */
- (void)showProductDetailView:(NSDictionary *)dic
{
    [self.productView showDetailView:dic];
}
/** 隐藏blackView  detailView */
- (void)hideProductDetailView
{
    [self.productView hiddenDetailView];
}

#pragma mark - Getter and Setter

- (void)setListDataSource:(NSMutableArray *)listDataSource
{
    _listDataSource = listDataSource;
    
    zq_asyncDispatchToMainQueue(^{
        [self.productTableView reloadData];
    });
}

- (void)setListDataSourceWithRecord:(NSMutableArray *)listDataSourceWithRecord
{
    _listDataSourceWithRecord = listDataSourceWithRecord;
    zq_asyncDispatchToMainQueue(^{
        [self.productTableView reloadData];
    });
}

- (UITableView *)productTableView
{
    if (!_productTableView) {
        _productTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _productTableView.delegate = self;
        _productTableView.dataSource = self;
        [_productTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZQProductListCell class]) bundle:nil] forCellReuseIdentifier:cellIdentifier];
    }
    return _productTableView;
}

- (ZQProductDetailV *)productView
{
    if (!_productView) {
        _productView = [[ZQProductDetailV alloc] init];
        _productView.delegate = self;
    }
    return _productView;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"搜索商品";
        _searchBar.delegate = self;
        _searchBar.showsCancelButton = YES;
        _searchBar.tintColor = [UIColor blackColor];
    }
    return _searchBar;
}

- (void)dealloc
{
    //使用成员变量 而不是 self. 防止self.不存在 或者Setter 执行
    _isRecordSearch = NO;
    _listDataSource = nil;
    _listDataSourceWithRecord = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
