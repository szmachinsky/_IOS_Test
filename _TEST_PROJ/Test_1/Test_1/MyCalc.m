//
//  MyCalc.m
//  Test_1
//
//  Created by svp on 29.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyCalc.h"

@implementation MyCalc

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (int)calc1:(int)var
{
    sleep(5);
    return (var * 100);  
}

- (int)calc:(int)var
{
    int res = [self calc1:var] + 1;
    return res;
}



@end
