//
//  SZAppInfo.h
//  TaxiTest
//
//  Created by Admin on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SZMCountry;

@interface SZAppInfo : NSObject


@property (nonatomic, strong)  SZMCountry *model;
@property (nonatomic, assign) BOOL autoDetection;
@property (nonatomic, strong) NSString *regionName;
@property (nonatomic, strong) NSString *cityName;

+ (SZAppInfo*)sharedInstance;

@end
