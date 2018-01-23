//
//  ZQHelperFunction.h
//  SDYIphoneHotel
//
//  Created by admin on 2017/12/25.
//  Copyright © 2017年 SanDaoyi. All rights reserved.
//

#ifndef ZQHelperFunction_h
#define ZQHelperFunction_h


//GCD

void zq_safeSyncDispatchToMainQueue(void(^block)(void));

void zq_asyncDispatchToMainQueue(void(^block)(void));

void zq_asyncDispatchToGlobalQueue(void(^block)(void));

void zq_asyncDispatchToBackGroundQueue(void(^block)(void));

void zq_delayeDispatchToMainQueue(NSTimeInterval, void(^block)(void));


// Method swizzling

#define ZQSwapInstanceMethodImplementation(selectorName) \
swapInstanceMethodImplementation(self, @selector(selectorName), @selector(swiz_ ## selectorName))
#define ZQSwapClassMethodImplementation(selectorName) \
swapClassMethodImplementation(self, @selector(selectorName), @selector(swiz_ ## selectorName))

/// Swap implementation of existing instance method with a new instance method implementation. Should only be called in the class' +load method.
void swapInstanceMethodImplementation(id object, SEL originalSelector, SEL newSelector);

/// Swap implementation of existing class method with a new class method implementation. Should only be called in the class' +load method.
void swapClassMethodImplementation(id object, SEL originalSelector, SEL newSelector);





#endif /* ZQHelperFunction_h */
