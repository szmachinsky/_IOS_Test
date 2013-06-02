//
//  UserInfo.m
//  Test_1
//
//  Created by svp on 03.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserInfo.h"

static UserInfo *_sharedUserInfoInstance = nil;

@implementation UserInfo
@synthesize idd;

- (id)init
{
    self = [super init];
    if (self) {
        idd=1;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}


+ (UserInfo*)shared
{
//  static UserInfo *_sharedUserInfoInstance = nil;
    @synchronized(self)
    {
        if(_sharedUserInfoInstance == nil) {
            _sharedUserInfoInstance = [[UserInfo alloc] init];
        }
    }    
    return _sharedUserInfoInstance;    
}

+ (void)initialize
{
    NSLog(@"-initialize- User Info");
    if(_sharedUserInfoInstance == nil) {
        _sharedUserInfoInstance = [[UserInfo alloc] init];
    }    
}



@end
