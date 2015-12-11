//
//  TestClass.m
//  test_nav_xib
//
//  Created by Zmachinsky Sergei on 11.12.15.
//  Copyright © 2015 Sergei. All rights reserved.
//

#import "TestClass.h"

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
    NSLog(@">>TestClass>> testClassMethod:(%@)",str);
    return;
}

- (void)testRunMethod:(NSString*)str
{
    NSLog(@">>TestClass>> testRunMethod:(%@)",str);
    return;
}



@end

