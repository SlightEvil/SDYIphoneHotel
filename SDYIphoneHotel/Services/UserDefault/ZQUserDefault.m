//
//  ZQUserDefault.m
//  SDYIphoneHotel
//
//  Created by admin on 2018/1/11.
//  Copyright © 2018年 SanDaoyi. All rights reserved.
//

#import "ZQUserDefault.h"

#define UDF     [NSUserDefaults standardUserDefaults]

@implementation ZQUserDefault

+ (void)saveValue:(id)value forKey:(NSString *)key
{
    [UDF setObject:value forKey:key];
    [UDF synchronize];
}

+ (id)takeValueForKey:(NSString *)key
{
   return  [UDF objectForKey:key];
}



@end
