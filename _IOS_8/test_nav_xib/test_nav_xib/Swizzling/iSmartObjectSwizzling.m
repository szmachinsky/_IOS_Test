//  Created by Sergey Ladeiko on 10/4/13.
//  Copyright (c) 2013 Sergey Ladeiko. All rights reserved.

#import "iSmartObjectSwizzling.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject (Swizzling)

+ (void)swizzleInstanceMethod:(Class)class oldSelector:(SEL)old newSelector:(SEL)newSelector
{
    Method oldMethod = class_getInstanceMethod(class, old);
    Method newMethod = class_getInstanceMethod(class, newSelector);
    
    if(class_addMethod(class, old, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
    {
        class_replaceMethod(class, newSelector, method_getImplementation(oldMethod), method_getTypeEncoding(oldMethod));
    }
    else
    {
        method_exchangeImplementations(oldMethod, newMethod);
    }
}

+ (void) swizzleClassMethod:(Class)class oldSelector:(SEL)old newSelector:(SEL)newSelector
{
    Method oldMethod = class_getClassMethod(class, old);
    Method newMethod = class_getClassMethod(class, newSelector);
    
    id metaClass = objc_getMetaClass(class_getName(class));
    
    class_addMethod(metaClass,
                    old,
                    class_getMethodImplementation(metaClass, old),
                    method_getTypeEncoding(oldMethod));
    class_addMethod(metaClass,
                    newSelector,
                    class_getMethodImplementation(metaClass, newSelector),
                    method_getTypeEncoding(newMethod));
    
    method_exchangeImplementations(class_getClassMethod(class, old), class_getClassMethod(class, newSelector));
}

@end
