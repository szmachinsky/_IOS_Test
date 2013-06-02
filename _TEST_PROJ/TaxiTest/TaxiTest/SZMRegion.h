//
//  SZMRegion.h
//  TaxiTest
//
//  Created by Admin on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZMRegion : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSArray *listCity;

+ (SZMRegion*)addRegion1;
+ (SZMRegion*)addRegion2;

@end
