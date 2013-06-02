//
//  SZMCity.m
//  TaxiTest
//
//  Created by Admin on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SZMCity.h"
#import "SZMTaxi.h"

@implementation SZMCity
{
    NSString *name_;
    NSArray *listTaxi_;
}
@synthesize name = name_;
@synthesize listTaxi = listTaxi_;

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
//------------------------------------------------------------------------------

+ (SZMCity*)addCity:(NSString*)tname 
{
    SZMCity *res = [[SZMCity alloc] init];
    res.name = tname;
    SZMTaxi *taxi1 = [SZMTaxi addTaxi:@"Такси 'Антилопа гну'" shortNumber:@"135"];
    SZMTaxi *taxi2 = [SZMTaxi addTaxi:@"Такси 'Эх, прокачу'" shortNumber:@"1234"];
    NSArray *list = [NSArray arrayWithObjects:taxi1, taxi2, nil];
    res.listTaxi = list;
    return res;
    
}


+ (SZMCity*)addCity1
{
    SZMCity *res = [[SZMCity alloc] init];
    res.name = @"Минск";
    SZMTaxi *taxi1 = [SZMTaxi addTaxi1];
    SZMTaxi *taxi2 = [SZMTaxi addTaxi2];
    SZMTaxi *taxi3 = [SZMTaxi addTaxi3];
    
    NSArray *list = [NSArray arrayWithObjects:taxi1, taxi2, taxi3, nil];
    res.listTaxi = list;
    return res;
    
}


@end
