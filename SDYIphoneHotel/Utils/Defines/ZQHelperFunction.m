//
//  ZQHelperFunction.m
//  SDYIphoneHotel
//
//  Created by admin on 2017/12/25.
//  Copyright © 2017年 SanDaoyi. All rights reserved.
//

//#import <Foundation/Foundation.h>

#import "ZQHelperFunction.h"


#pragma mark - GCD
//inline
inline void zq_safeSyncDispatchToMainQueue(void (^block)(void)) {
    if ([NSThread mainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

inline void zq_asyncDispatchToMainQueue(void(^block)(void)) {
    dispatch_async(dispatch_get_main_queue(), block);
}

inline void zq_asyncDispatchToGlobalQueue(void(^block)(void)) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

inline void zq_asyncDispatchToBackGroundQueue(void(^block)(void)) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
}

inline void zq_delayeDispatchToMainQueue(NSTimeInterval delta, void(^block)(void)) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delta * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

#pragma mark - Runtime

#import <objc/runtime.h>
static void __swizzleMethodImplementations(Class class, SEL originalSelector, SEL newSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, newSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, newSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

void swapInstanceMethodImplementation(id object, SEL originalSelector, SEL newSelector) {
    __swizzleMethodImplementations([object class], originalSelector, newSelector);
}

void swapClassMethodImplementation(id object, SEL originalSelector, SEL newSelector) {
    __swizzleMethodImplementations(object_getClass(object), originalSelector, newSelector);
}



