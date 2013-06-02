//
//  MyOperation.h
//  Test_1
//
//  Created by svp on 30.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOperation : NSOperation
{
    int val_;
}
@property (nonatomic) int val;

- (id)initWithInt:(int)val;
- (void)main;

@end
