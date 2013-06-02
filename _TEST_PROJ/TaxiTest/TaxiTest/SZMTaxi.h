//
//  SZMTaxi.h
//  TaxiTest
//
//  Created by Admin on 11.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZMTaxi : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *shortNumber;           
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) NSString *tarifs;
@property (nonatomic,strong) NSArray *operators;
@property (nonatomic,strong) NSDictionary *numbers;

+ (SZMTaxi*)addTaxi:(NSString*)tname shortNumber:(NSString*)snum;
+ (SZMTaxi*)addTaxi1;
+ (SZMTaxi*)addTaxi2;
+ (SZMTaxi*)addTaxi3;

@end
