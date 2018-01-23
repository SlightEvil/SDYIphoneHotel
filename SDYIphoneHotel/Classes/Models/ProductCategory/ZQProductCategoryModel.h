//
//  ZQProductCotegory.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/15.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

@interface ZQProductCategoryModel : NSObject

/** 分类名称 */
@property (nonatomic) NSString *category_name;
/** 分类id  */
@property (nonatomic) NSString *category_id;
/** 分类的图标  没用到 */
@property (nonatomic) NSString *category_logo;
/** 分类里面的分类数组 */
@property (nonatomic) NSArray *children;




@end
