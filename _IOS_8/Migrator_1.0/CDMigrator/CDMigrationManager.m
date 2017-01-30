//
//  MyMigrationManager.m
//  
//
//  Created by Zmachinsky Sergei on 23.03.15.
//  Copyright (c) 2015 Zmachinsky Sergei. All rights reserved.
//

#import "CDMigrationManager.h"


@implementation CDMigrationManager


- (NSString*)emptyString
{
    return @"";
}

- (NSString*)addString:(NSString*)addStr to:(NSString*)str
{
    NSString *res = [NSString stringWithFormat:@"%@ +%@",str,addStr];
    NSLog(@"(%@)-->(%@)",str,res);
    return res;
}

- (NSString*)fillWithString:(NSString*)string
{
    NSString *res = [NSString stringWithFormat:@"%@",string];
    NSLog(@"-->(%@)",res);
    return res;
}




-(void)associateSourceInstance:(NSManagedObject*)sourceInstance withDestinationInstance:(NSManagedObject *)destinationInstance forEntityMapping:(NSEntityMapping *)entityMapping
{
    [super associateSourceInstance:sourceInstance withDestinationInstance:destinationInstance forEntityMapping:entityMapping];
    
    NSString *name1 = [entityMapping sourceEntityName];
    NSString *name2 = [entityMapping destinationEntityName];
    
    NSLog(@"--> migration Manager for (%@) (%@) Tables",name1,name2);
    
    if([name2 compare:@"Event"] == NSOrderedSame)
    {        
    }
    
}

@end
