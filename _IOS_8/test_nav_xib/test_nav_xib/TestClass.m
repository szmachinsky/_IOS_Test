//
//  TestClass.m
//  test_nav_xib
//
//  Created by Zmachinsky Sergei on 11.12.15.
//  Copyright © 2015 Sergei. All rights reserved.
//

#import "TestClass.h"


static void _swizzleInstanceMethod(Class class, SEL old,  SEL newSelector)
{
    Method oldMethod = class_getInstanceMethod(class, old);
    Method newMethod = class_getInstanceMethod(class, newSelector);
    
    if (class_addMethod(class, old, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
    {
        class_replaceMethod(class, newSelector, method_getImplementation(oldMethod), method_getTypeEncoding(oldMethod));
    }
    else
    {
        method_exchangeImplementations(oldMethod, newMethod);
    }
}


@interface NSMutableArray (Fix)     //use Category
- (void)remove___AllObjects;
@end


@implementation NSMutableArray (Fix)
//+ (void)load
//{
//    [self swizzleInstanceMethod:self oldSelector:@selector(removeAllObjects) newSelector:@selector(remove___AllObjects)];
//}

//+ (void)load
//{
//    _swizzleInstanceMethod([NSMutableArray class], @selector(removeAllObjects), @selector(remove___AllObjects));
//}


- (void)remove___AllObjects
{
    NSLog(@"__remove____AllObjects__from__Category");
    id ob = self[0];
    NSLog(@"%d",self.count);
    [self remove___AllObjects];
    self[0] = ob;
    NSLog(@"%d",self.count);
}
@end



//@interface UIWindowSwizzling : NSObject
//@end
//
//@implementation UIWindowSwizzling
//
//+ (void)load
//{
//    //[self swizzleInstanceMethod:UIWindow.class oldSelector:@selector(sendEvent:) newSelector:@selector(sendEventSwizzle:)];
//    _swizzleInstanceMethod([NSMutableArray class], @selector(removeAllObjects), @selector(remove___AllObjects));
//}
//
//@end




//- (void)removeAllObjects
//{
//    NSLog(@"__removeAllObjects__Category");
//}



//@interface FX_NSArray:NSMutableArray     //use subClass
//- (instancetype)init;
//- (void)removeAllObjects;
//@end
//
//@implementation FX_NSArray
//- (instancetype)init
//{   self = [super init];
//    return self;
//}
//- (void)removeAllObjects
//{
//    NSLog(@"__removeAllObjects__subclass");
//}
//@end




//===============================================================================================

@implementation TestClass

-(instancetype)init
{
    NSLog(@">>TestClass>> init");
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (void)initialize
{
    static int sc = 0;
    NSLog(@">>TestClass>> initialize:%d",++sc);
    if (self == [TestClass self]) {
        NSLog(@">>TestClass>> real_initialize");
    }
    
    return;
}

+ (void)load
{
    NSLog(@">>TestClass>> load");
    return;
}


+ (void)testClassMethod:(NSString*)str
{
    NSLog(@">>TestClass>> testClassMethod:(%@)  ",str);
    
    //NSMutableArray *arr = [[NSMutableArray alloc] init];
    //FX_NSArray *arr = [[FX_NSArray alloc] init];
    
    NSMutableArray *arr = [@[@1,@2,@3] mutableCopy];
    Class cls = [arr class];
    NSLog(@"(%@)",cls);
    //_swizzleInstanceMethod([arr class], @selector(removeAllObjects), @selector(remove___AllObjects));
    _swizzleInstanceMethod([NSMutableArray class], @selector(removeAllObjects), @selector(remove___AllObjects));

    arr[0] = @1;
    arr[1] = @2;
    arr[2] = @3;
    NSLog(@"arr_1=%d",arr.count);
    [arr removeAllObjects];
    //[arr remove___AllObjects];
    NSLog(@"arr_2=%d  %@",arr.count,arr);
    
    
    return;
}

- (void)testRunMethod:(NSString*)str
{
    NSLog(@">>TestClass>> testRunMethod:(%@)",str);
    return;
}



@end

