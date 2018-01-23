//
//  ZQProductCategoryVC.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/9.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQProductCategoryVC.h"
#import "ZQProductCategoryModel.h"
#import "ZQProductListVC.h"
#import "UIImage+Cagegory.h"
#import "ZQProductCategoryCell.h"


static NSString *const ZQProductCategoryVCClassCategoryCellIdentifier = @"ZQProductCategoryVCClassCategoryCellIdentifier";
static NSString *const ZQProductCategoryVCClassCellIdentifier = @"ZQProductCategoryVCClassCellIdentifier";


@interface ZQProductCategoryVC ()<UITableViewDelegate,UITableViewDataSource>

/** classCategory tableview */
@property (nonatomic) UITableView *classCategoryTableView;
/** class tableView */
@property (nonatomic) UITableView *classTableView;
/** 选择总分类的cellIndex  默认为0 */
@property (nonatomic, assign) NSInteger currentCellIndex;

@end

@implementation ZQProductCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    [self layoutWithAuto];
    [self setupSearchBarItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!AppCT.isUserLogin) {
        [AppCT showLoginVC];
        return;
    }
    if (ViewModel.productCategoryDataSource.count == 0) {
        self.currentCellIndex = 0;
        [self requestProductListWithPid:nil];
    }
}



#pragma mark - Delegate
#pragma mark - UITableView 的代理事件
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 49;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 49;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2;
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:kZQFontNameBold size:kZQTitleFont];
    
    if (tableView.tag == kZQProductCategoryVCClassCategoryTableViewTag) {
        label.text = @"总分类";
    }
    if (tableView.tag == kZQProductCategoryVCClassTableViewTag) {
        label.text = @"小分类";
    }
    return label;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (ViewModel.productCategoryDataSource.count > 0) {
        if (tableView.tag == kZQProductCategoryVCClassCategoryTableViewTag) {
            return  ViewModel.productCategoryDataSource.count;
        }
        if (tableView.tag == kZQProductCategoryVCClassTableViewTag) {
            ZQProductCategoryModel *categoryModel = ViewModel.productCategoryDataSource[self.currentCellIndex];
            return categoryModel.children.count;
        }
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kZQProductCategoryVCClassCategoryTableViewTag) {
        
        ZQProductCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ZQProductCategoryVCClassCategoryCellIdentifier forIndexPath:indexPath];
        UIView *selectBackView = [[UIView alloc]initWithFrame:cell.contentView.bounds];
        selectBackView.backgroundColor = kZQTabbarTintColor;
        cell.selectedBackgroundView =  selectBackView;
        ZQProductCategoryModel *categoryModel = ViewModel.productCategoryDataSource[indexPath.row];
        cell.categoryName = categoryModel.category_name;
        return cell;
    }
//    if (tableView.tag == kZQProductCategoryVCClassTableViewTag) {
        ZQProductCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ZQProductCategoryVCClassCellIdentifier forIndexPath:indexPath];
        UIView *selectBackView = [[UIView alloc]initWithFrame:cell.contentView.bounds];
        selectBackView.backgroundColor = kZQTabbarTintColor;
        cell.selectedBackgroundView =  selectBackView;
        ZQProductCategoryModel *categoryModel = ViewModel.productCategoryDataSource[self.currentCellIndex];
        ZQProductCategoryModel *childenCategoryModel = categoryModel.children[indexPath.row];
        cell.categoryName = childenCategoryModel.category_name;
        return cell;
//    }
//    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (ViewModel.productCategoryDataSource.count == 0) {
        return;
    }
    if (tableView.tag == kZQProductCategoryVCClassCategoryTableViewTag) {
        self.currentCellIndex = indexPath.row;
        [self.classTableView reloadData];
    }
    if (tableView.tag == kZQProductCategoryVCClassTableViewTag) {
        
        ZQProductCategoryModel *categoryModel = ViewModel.productCategoryDataSource[self.currentCellIndex];
        ZQProductCategoryModel *categotyModelChildren = categoryModel.children[indexPath.row];
        //push到商品列表界面
        [self pushProductListVCwithProductCategoryID:categotyModelChildren.category_id title:categotyModelChildren.category_name];
    }
}


#pragma mark - Event response

/**
 push 到商品列表界面  parameter categoryID商品分类id  title 商品列表的title

 @param categoryID 商品分类id
 @param title  title
 */
- (void)pushProductListVCwithProductCategoryID:(NSString *)categoryID title:(NSString *)title
{
    ZQProductListVC *listVC  = [[ZQProductListVC alloc] init];
    listVC.hidesBottomBarWhenPushed = YES;
    listVC.productListType = ZQProductListTypeCategory;
    listVC.navigationItem.title = title;
    listVC.productCategoryID = categoryID;//商品分类的id
    [self.navigationController pushViewController:listVC animated:YES];
}

/** 点击搜索按钮动作  跳转到搜索界面（商品列表） */
- (void)searchBarItemClick
{
    ZQProductListVC *listVC = [[ZQProductListVC alloc] init];
    listVC.productListType = ZQProductListTypeSearchResult;
    listVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listVC animated:YES];
}


#pragma mark - Private methods

- (void)setupUI
{
    [self.view addSubview:self.classCategoryTableView];
    [self.view addSubview:self.classTableView];
}

/** 设置导航栏rightItem 搜索按钮 */
- (void)setupSearchBarItem
{
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage sizeImageWithImage:[UIImage imageNamed:@"icon_search"] sizs:CGSizeMake(30, 30)] style:UIBarButtonItemStylePlain target:self action:@selector(searchBarItemClick)];
    self.navigationItem.rightBarButtonItem = searchItem;
}

- (void)layoutWithAuto
{
    [self.classCategoryTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        } else {
            make.top.bottom.left.equalTo(self.view);
        }
    }];
    [self.classTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.height.width.equalTo(self.classCategoryTableView);
        if (@available(iOS 11.0, *)) {
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        } else {
            make.right.equalTo(self.view);
        }
        make.left.equalTo(self.classCategoryTableView.mas_right).mas_offset(1);
    }];
}

/** 请求商品分类 */
- (void)requestProductListWithPid:(NSString *)pid
{
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    
    NSMutableArray *array = [NSMutableArray array];
    
    [AppCT.networkServices GET:kAPIURLProductCategory parameter:@{} success:^(NSDictionary *dictionary) {
                
        NSArray *dataAry = dictionary[@"data"];
        [dataAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZQProductCategoryModel *categoryModel = [ZQProductCategoryModel mj_objectWithKeyValues:obj];
            [array addObject:categoryModel];
        }];
        
        ViewModel.productCategoryDataSource = array;
        [strongSelf.classCategoryTableView reloadData];
        [strongSelf.classTableView reloadData];
          
        //默认选中第一行
        [strongSelf.classCategoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
 
    } fail:^(NSString *errorDescription) {
        
    }];
}

#pragma mark - Getter and Setter

- (UITableView *)classCategoryTableView
{
    if (!_classCategoryTableView) {
        _classCategoryTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _classCategoryTableView.delegate = self;
        _classCategoryTableView.dataSource = self;
        _classCategoryTableView.showsVerticalScrollIndicator = NO;
        _classCategoryTableView.showsHorizontalScrollIndicator = NO;
        _classCategoryTableView.tag = kZQProductCategoryVCClassCategoryTableViewTag;
        [_classCategoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZQProductCategoryCell class]) bundle:nil] forCellReuseIdentifier:ZQProductCategoryVCClassCategoryCellIdentifier];
        
//        [_classCategoryTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ZQProductCategoryVCClassCategoryCellIdentifier];
    }
    return _classCategoryTableView;
}

- (UITableView *)classTableView
{
    if (!_classTableView) {
        _classTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _classTableView.delegate = self;
        _classTableView.dataSource = self;
        _classTableView.showsVerticalScrollIndicator = NO;
        _classTableView.showsHorizontalScrollIndicator = NO;
        _classTableView.tag = kZQProductCategoryVCClassTableViewTag;
        [_classTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZQProductCategoryCell class]) bundle:nil] forCellReuseIdentifier:ZQProductCategoryVCClassCellIdentifier];
//        [_classTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ZQProductCategoryVCClassCellIdentifier];
    }
    return _classTableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
