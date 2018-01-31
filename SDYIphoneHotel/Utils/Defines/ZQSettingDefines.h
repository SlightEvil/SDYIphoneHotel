//
//  ZQSettingDefines.h
//  SDYIphoneHotel
//
//  Created by admin on 2017/12/25.
//  Copyright © 2017年 SanDaoyi. All rights reserved.
//

#ifndef ZQSettingDefines_h
#define ZQSettingDefines_h

#pragma mark - Setting
/** 加粗字体 */
#define kZQFontNameBold           @"Arial Rounded MT Bold"
/** 常规字体 */
#define kZQFontNameSystem             @"ArialMT"


#pragma mark - View tag
#define kZQProductCategoryVCClassCategoryTableViewTag    1000
#define kZQProductCategoryVCClassTableViewTag            1001


#define kZQIsIphone [[UIDevice currentDevice].model isEqualToString:@"iPhone"]
#define kZQTitleFont      (kZQIsIphone ? 16 : 18)
#define kZQCellFont       (kZQIsIphone ? 15 : 17)
#define kZQDetailFont     (kZQIsIphone ? 12 : 14)
#define kZQCellDetailFont (kZQIsIphone ? 13 : 15)

#define kZQTextFieldHeight (kZQIsIphone ? 40 : 45)

#pragma mark - UITableViewCell
/** 订单模板高度 */
#define kZQCellHeightOrderRecord   (kZQIsIphone ? 49 : 69)
#define kZQCellHeithtOrderRecordDetail  (kZQIsIphone ? 60 : 80)


#define kScreenWidth    CGRectGetWidth([UIScreen mainScreen].bounds)
#define kScreenHeight   CGRectGetHeight([UIScreen mainScreen].bounds)


#define TopWindow [UIApplication sharedApplication].keyWindow


#pragma mark - Notification

#define Add_Observer(NtfName,SEL) [[NSNotificationCenter defaultCenter] addObserver:self selector:SEL name:NtfName object:nil]

#define Remove_Observer(NtfName) [[NSNotificationCenter defaultCenter] removeObserver:self name:NtfName object:nil]

#define Post_Observer(NtfName,message,dictionary) [[NSNotificationCenter defaultCenter] postNotificationName:NtfName object:message userInfo:dictionary]


#pragma mark - Color 颜色设置

#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kRGBColor(red,green,blue) [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:1]
/** tabbar 的barColor */
#define kZQTabbarBarTintColor         kUIColorFromRGB(0xf9f9f9)
/** tabbar 的选中后图标颜色 */
#define kZQTabbarTintColor            kUIColorFromRGB(0x1add19)
/** view 的背景 的颜色 */
#define kZQViewBgColor                kUIColorFromRGB(0xefeff4)
/** 商品详情的textColor */
#define kZQDetailViewTextColor        kUIColorFromRGB(0x999999)
/** 黑色颜色 */
#define kZQBlackColor                 kUIColorFromRGB(0x333333)
/** 收藏按钮的背景颜色 */
#define kZQRecordColor                kUIColorFromRGB(0x73dec4)
/** 商品详情选择attribute Color */
#define kSDYAttributeSelectColor         [UIColor colorWithRed:(244/255.0) green:(164/255.0) blue:(96/255.0) alpha:1]

/** 拼接2个字符串字符串 */
#define kStrAppendStr(string,appendString) [string stringByAppendingString:appendString]


#pragma mark - Single

// .h
#define single_interface(class) + (class *) shared##class;
// .m
// \ 代表下一行也属于宏
// ## 是分隔符

#define single_implementation(class) \
static class *_instance; \
\
+(class *)shared##class \
{ \
if (_instance == nil){ \
_instance = [[self alloc] init]; \
} \
return _instance; \
} \
\
+(id)allocWithZone:(NSZone *)zone \
{  \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
\
+(id) copyWithZone:(NSZone *)zone \
{ \
return self; \
}


#endif /* ZQSettingDefines_h */
