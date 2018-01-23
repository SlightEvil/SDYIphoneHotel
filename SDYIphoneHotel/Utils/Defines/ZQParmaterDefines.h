//
//  ZQParmaterDefines.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/10.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#ifndef ZQParmaterDefines_h
#define ZQParmaterDefines_h

/** userdefault user_name key */
static NSString *const UDKUserName = @"UserDefaultKeyUserName";
/** userdefault 收藏的商品id key */
static NSString *const UDKRecordProductID = @"USKRecordProductID";


/**  用户 */
static NSString *const user_name =          @"user_name";
/**  密码 */
static NSString *const user_password =      @"user_password";
/**  用户ID */
static NSString *const user_id =            @"user_id";

/**  内容 */
static NSString *const content =            @"content";
/**  订单ID */
static NSString *const orderId =            @"id";

/**  当前页码 */
static NSString *const page =               @"p";
/**  每页行数 */
static NSString *const line =               @"len";

//商品列表
/**  商品分类ID */
static NSString *const cat =                @"cat";
/**  商品名称 */
static NSString *const name =               @"name";
/**  父级分类ID */
static NSString *const pid =                @"pid";
/**  商品id */
static NSString *const productID =          @"id";

/**  此shop_id为当前用户（供应商）所属的店铺id */
static NSString *const shop_id =            @"shop_id";
/**  此order_id正式从订单列表接口拿到的order_id */
static NSString *const order_id =           @"order_id";
/** 供应商name  */
static NSString *const shop_name =          @"shop_name";
//供应商号码 */
static NSString *const shop_phone =         @"shop_phone";

/**     */
static NSString *const detail_id =          @"detail_id";
/**  单品id */
static NSString *const sku_id =             @"sku_id";
/** 商品id */
static NSString *const product_id =         @"product_id";
/** 规格  */
static NSString *const attributes =         @"attributes";

static NSString *const attribute_names =    @"attribute_names";

/** 规格名称 */
static NSString *const attributesNameKey =  @"attribute_name";
/** 规格id */
static NSString *const attributesIdKey =    @"attribute_id";
/** 数量  */
static NSString *const quantity =           @"quantity";

/** 状态码  */
static NSString *const status =             @"status";
/** 请求信息反馈  */
static NSString *const message =            @"message";
/** 单价 */
static NSString *const unit =               @"unit";
/** 商场价格 */
static NSString *const mall_price =         @"mall_price";
/** 市场价格 */
static NSString *const market_price =       @"market_price";


#endif /* ZQParmaterDefines_h */
