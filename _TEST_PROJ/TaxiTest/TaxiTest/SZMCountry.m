//
//  SZMCountry.m
//  TaxiTest
//
//  Created by Admin on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SZMCountry.h"
#import "SZMRegion.h"


@implementation SZMCountry
{
    NSString *name_;
    NSArray *listRegion_;
}
@synthesize name = name_;
@synthesize listRegion = listRegion_;

- (id)init
{
    self = [super init];
    if (self) {
        name_ = @"Беларусь";
    }
    return self;
}
//------------------------------------------------------------------------------


+ (SZMCountry*)addCountry1 
{
    SZMCountry *res = [[SZMCountry alloc] init];
    res.name = @"Беларусь";
    
    SZMRegion *reg1 = [SZMRegion addRegion1];
    SZMRegion *reg2 = [SZMRegion addRegion2];
    
    NSArray *list = [NSArray arrayWithObjects:reg1, reg2, nil];
    res.listRegion = list;
    return res;
    
}


@end
