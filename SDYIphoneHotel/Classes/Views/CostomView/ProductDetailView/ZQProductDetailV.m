//
//  ZQProductDetailV.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/14.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQProductDetailV.h"
#import "ZQProductDetailView.h"



@interface ZQProductDetailV ()<ZQProductDetailViewDelegate>

/** 黑色背景 */
@property (nonatomic) UIView *blackView;
/** 商品详情View */
@property (nonatomic) ZQProductDetailView *productDetailView;


@end


@implementation ZQProductDetailV

- (instancetype)init
{
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self addSubview:self.blackView];
        [self addSubview:self.productDetailView];
    }
    return self;
}

#pragma mark - Delagete  商品详情view 的代理事件   添加新商品到购物车 和收藏商品

- (void)productDetailViewAddNewProduct:(ZQAddNewProductModel *)newProductModel
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(productAddNewProduct:)]) {
        [self.delegate productAddNewProduct:newProductModel];
    }
}
//
//- (void)productDetailViewRecordProductID:(NSString *)productID isRecord:(BOOL)isRecord
//{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(productRecordProduct:isRecord:)]) {
//        [self.delegate productRecordProduct:productID isRecord:isRecord];
//    }
//}

//收藏按钮   成功  是否为取消收藏
- (void)productDetailViewRecordSuccessForIsCancelRecord:(BOOL)isCancelRecord
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(productRecordSuccessForIsCancelRecord:)]) {
        [self.delegate productRecordSuccessForIsCancelRecord:isCancelRecord];
    }
}


#pragma mark - Event response

- (void)blakcViewClick:(UITapGestureRecognizer *)sender
{
    [self hiddenDetailView];
}

#pragma mark - Private method
#pragma mark - 隐藏和显示商品详情View
- (void)showDetailView:(NSDictionary *)productDic
{
    zq_asyncDispatchToMainQueue(^{
        self.productDetailView.productDetailDic = productDic;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [UIView animateWithDuration:0.5 animations:^{
            self.productDetailView.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(self.productDetailView.bounds));
            
        } completion:^(BOOL finished) {
            
        }];
    });
}
- (void)hiddenDetailView
{
    zq_asyncDispatchToMainQueue(^{
        [UIView animateWithDuration:0.5 animations:^{
            self.productDetailView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.productDetailView.bounds));
        } completion:^(BOOL finished) {
            
            [self.productDetailView clearData];
            [self removeFromSuperview];
        }];
    });
}

#pragma mark - Getter and Setter

- (UIView *)blackView
{
    if (!_blackView) {
        _blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blakcViewClick:)];
        [_blackView addGestureRecognizer:tap];
    }
    return _blackView;
}

- (ZQProductDetailView *)productDetailView
{
    if (!_productDetailView) {
        _productDetailView = [[ZQProductDetailView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight*3/4)];
        _productDetailView.delegate = self;
    }
    return _productDetailView;
}

@end
