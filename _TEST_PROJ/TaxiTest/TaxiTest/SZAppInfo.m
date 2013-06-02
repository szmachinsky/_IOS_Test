//
//  SZAppInfo.m
//  TaxiTest
//
//  Created by Admin on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SZAppInfo.h"
#import "SZMCountry.h"

static SZAppInfo *_sharedAppInfo=nil;


@interface SZAppInfo ()
@end

//------------------------------------------------------------------------------
@implementation SZAppInfo
{
    BOOL autoDetection_;
    SZMCountry *model_;
    NSString *regionName_;
    NSString *cityName_;
}

@synthesize autoDetection = autoDetection_;
@synthesize model = model_;
@synthesize regionName = regionName_;
@synthesize cityName = cityName_;



- (id)init
{
    self = [super init];
    if (self) {
        autoDetection_ = NO;
    }
    return self;
}


+ (SZAppInfo*)sharedInstance
{// static AppInfo *_sharedAppInfo=nil;
    @synchronized(self) {
        if(_sharedAppInfo == nil) {
            _NSLog(@"-initialize_Shared- AppInfo");
            _sharedAppInfo = [[SZAppInfo alloc] init];
        }
    }    
    return _sharedAppInfo;    
}


+ (void)initialize
{
    _NSLog(@"-initialize_Initialize- AppInfo");
    if(_sharedAppInfo == nil) {
        _sharedAppInfo = [[SZAppInfo alloc] init];
    }    
}
//------------------------------------------------------------------------------


@end
