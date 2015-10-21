//  Created by Sergey Ladeiko on 10/4/13.
//  Copyright (c) 2013 Sergey Ladeiko. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSObject(Swizzling)
+ (void)swizzleInstanceMethod:(Class)class oldSelector:(SEL)old newSelector:(SEL)newSelector;
+ (void)swizzleClassMethod:(Class)class oldSelector:(SEL)old newSelector:(SEL)newSelector;
@end
