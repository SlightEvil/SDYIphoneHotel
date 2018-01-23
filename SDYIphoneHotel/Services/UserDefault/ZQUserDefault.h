//
//  ZQUserDefault.h
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/11.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>



/**
 NSUserDefault  
 */
@interface ZQUserDefault : NSObject

/**
 Userdefault 存值 value key

 @param value value
 @param key key
 */
+ (void)saveValue:(id)value forKey:(NSString *)key;

/**
 Userdefault 取值 key

 @param key key
 */
+ (id)takeValueForKey:(NSString *)key;

@end
