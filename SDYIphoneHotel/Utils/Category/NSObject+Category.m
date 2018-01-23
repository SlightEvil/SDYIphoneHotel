//
//  NSObject+Category.m
//  SDYHotel
//
//  Created by admin on 2017/12/13.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "NSObject+Category.h"
#import <objc/runtime.h>


@implementation NSObject (Category)

//所有字典转模型框架 核心算法
+ (instancetype)cz_objWithDict:(NSDictionary *)dict
{
    id object = [[self alloc]init];
    //使用字典 设置对象信息
    //1> 获得 self 的属性列表
    NSArray *proList = [self cz_objProperties];
    
    //遍历字典
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        //2> 判断key 是否包含在proList 里面
        if ([proList containsObject:key]) {
            
            //说明属性存在 可以使用 KVC 设置数值
            [object setValue:obj forKey:key];
        }
    }];
    return object;
}

/*
 动态获取属性名称
 
 获取类的属性列表class_copyPropertyList
 遍历列表 获取 属性名称  property_getName
 添加到 OC数组
 */
+ (NSArray *)cz_objProperties
{
    //调用运行时方法 调用类的属性列表
    // IvarList    成员变量
    // MethodList   方法列表
    // PropertyList   属性
    // ProtocolList    协议
    
    /**
     *  参数：
     *      1、要获取的类
     *      2、类属性的个数指针
     *  返回：
     *      所有属性的数组，  C语言中，数组的名字 就是指向第一个元素的地址
     retain/create/copy 需要 release  最好option + click（点击）
     */
    
    unsigned int count = 0;  //下面为数组
    objc_property_t *proList =  class_copyPropertyList([self class], &count);
    
    //创建数组
    NSMutableArray *array = [NSMutableArray array];
    
    //遍历所有的属性
    for (unsigned int i = 0; i < count; i++) {
        
        //1、从数组中获取属性
        /**
         C语言 的结构体指针 通常不需要 ”*“
         */
        objc_property_t pty = proList[i];   //这个为指针
        
        //2、从 pty 中获取属性的名称
        const char *cName =  property_getName(pty);//这个是C的字符串 使用 %s
        
        //使用OC 的字符串  需要把C的字符串转化一下
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        
        //将属性名称添加到数组
        [array addObject:name];
    }
    //释放数组
    free(proList);
    
    return array.copy;  //把数组的copy 返回过去
}

@end
