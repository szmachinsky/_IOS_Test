//
//  MyOperation.m
//  Test_1
//
//  Created by svp on 30.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyOperation.h"

@implementation MyOperation
@synthesize val = val_;

- (id)initWithInt:(int)val
{
    self = [super init];
    if (self) {
        val_=val;

    }
    return self;
}

- (void)dealloc {
    [super dealloc];
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


- (void)main {
    @try {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
 /*     BOOL isDone = NO;        
        while (![self isCancelled] && !isDone) {
            // Do some work and set isDone to YES when finished
            
        }
*/    
        if ([self isCancelled]) 
            return; 
        
        val_ = [self calc:val_];
        
        if (![self isCancelled]) 
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MyOperationFinished" object:self];         
        
        [pool release];
    }
    @catch(...) {
        // Do not rethrow exceptions.
    }
}

@end
