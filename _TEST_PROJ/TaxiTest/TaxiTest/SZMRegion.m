//
//  SZMRegion.m
//  TaxiTest
//
//  Created by Admin on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SZMRegion.h"
#import "SZMCity.h"

@implementation SZMRegion
{
    NSString *name_;
    NSArray *listCity_;
}
@synthesize name = name_;
@synthesize listCity = listCity_;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
//------------------------------------------------------------------------------


+ (SZMRegion*)addRegion1 
{
    SZMRegion *res = [[SZMRegion alloc] init];
    res.name = @"Минская область";
    
    SZMCity *city1 = [SZMCity addCity1];
    SZMCity *city2 = [SZMCity addCity:@"Молодечно"];
    SZMCity *city3 = [SZMCity addCity:@"Борисов"];
    
    NSArray *list = [NSArray arrayWithObjects:city1, city2, city3, nil];
    res.listCity = list;
    return res;
    
}


+ (SZMRegion*)addRegion2
{
    SZMRegion *res = [[SZMRegion alloc] init];
    res.name = @"Брестская область";
    
    SZMCity *city1 = [SZMCity addCity:@"Брест"];
    
    NSArray *list = [NSArray arrayWithObjects:city1, nil];
    res.listCity = list;
    return res;
    
}


@end
