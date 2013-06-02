//
//  SZMCountry.h
//  TaxiTest
//
//  Created by Admin on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZMCountry : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSArray *listRegion;

+ (SZMCountry*)addCountry1;

@end
