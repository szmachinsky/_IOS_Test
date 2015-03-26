//
//  MyMigrationManager.m
//  Core_Test
//
//  Created by Zmachinsky Sergei on 23.03.15.
//  Copyright (c) 2015 Zmachinsky Sergei. All rights reserved.
//

#import "MyMigrationManager.h"

@implementation MyMigrationManager


- (NSString*)emptyString
{
    return @"";
}

- (NSString*)addString:(NSString*)addStr to:(NSString*)str
{
    static int i = 0;
    NSString *res = [NSString stringWithFormat:@"%@ +%@",str,addStr];
    if (++i % 1000 == 0) {
        NSLog(@"%02d) (%@)->(%@)",i,str,res);
    }
    return res;
}



-(void)associateSourceInstance:(NSManagedObject*)sourceInstance withDestinationInstance:(NSManagedObject *)destinationInstance forEntityMapping:(NSEntityMapping *)entityMapping
{
    [super associateSourceInstance:sourceInstance withDestinationInstance:destinationInstance forEntityMapping:entityMapping];
    NSString *name = [entityMapping destinationEntityName];
    
    static int i = 0;
    if (++i % 1000 == 0) {
        NSLog(@"--%02d--> migrate Manager_4_5 for = %@",i,name);
    //    sleep(1);
    }
    
    
    if([name compare:@"Person"] == NSOrderedSame)
    {
        //        NSLog(@"-->custom for Person");
        
        NSString *name = [sourceInstance valueForKey:@"sName"];
        name = [NSString stringWithFormat:@"%@ .",name];
        [destinationInstance setValue:name forKey:@"sName"];
        
//        [destinationInstance setValue:@"+Custom1!!!" forKey:@"newField"];
    }
    
    if([name compare:@"Sex"] == NSOrderedSame)
    {
        //        NSLog(@"--custom for Sex");
   
        NSString *name = [sourceInstance valueForKey:@"descr"];
        name = [NSString stringWithFormat:@"%@ .",name];
        [destinationInstance setValue:name forKey:@"descr"];
        
        [destinationInstance setValue:@"+Custom2!!!" forKey:@"newField"];
    }
}

@end
