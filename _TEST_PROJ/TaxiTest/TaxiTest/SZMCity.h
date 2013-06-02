//
//  SZMCity.h
//  TaxiTest
//
//  Created by Admin on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZMCity : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSArray *listTaxi;

+ (SZMCity*)addCity:(NSString*)tname;
+ (SZMCity*)addCity1;

@end
