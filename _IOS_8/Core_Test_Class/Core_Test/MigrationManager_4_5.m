//
//  MigrationManager_4_5.m
//  Core_Test
//
//  Created by Zmachinsky Sergei on 09.03.15.
//  Copyright (c) 2015 Zmachinsky Sergei. All rights reserved.
//

#import "MigrationManager_4_5.h"


@implementation MigrationManager_4_5

- (NSString*)emptyString
{
    return @"";
}

- (NSString*)addString:(NSString*)nativeData
{
//    @try
//    {
        static int i = 0;
        
        NSString *res = [NSString stringWithFormat:@"/%@/+add",nativeData];
        
//        NSLog(@"--%03d)--> addString %@",i,res);
        
        return res;
//    }
//    @catch(...)
//    {
//        return @"";
//    }
}



-(void)associateSourceInstance:(NSManagedObject*)sourceInstance withDestinationInstance:(NSManagedObject *)destinationInstance forEntityMapping:(NSEntityMapping *)entityMapping
{
    [super associateSourceInstance:sourceInstance withDestinationInstance:destinationInstance forEntityMapping:entityMapping];
    NSString *name = [entityMapping destinationEntityName];
    
    static int i = 0;
    NSLog(@"--%02d--> migrate Manager_4_5 for = %@",++i,name);
//    sleep(1);
    
    if([name compare:@"MigrEvent"] == NSOrderedSame || [name compare:@"MigrEvent"] == NSOrderedSame)
    {
        NSString *sss = [sourceInstance valueForKey:@"detail_1"];
        NSLog(@"-->custom for = %@",sss);
        
        [destinationInstance setValue:@"+Custom1!!!" forKey:@"detail_1"];
//        [destinationInstance setValue:@"+Custom2!!!" forKey:@"detail_2"];
//        [destinationInstance setValue:@"+Cust-field" forKey:@"field"];
    }
    
    if([name compare:@"Person"] == NSOrderedSame)
    {
//        NSLog(@"-->custom for Person");
        
        NSString *name = [sourceInstance valueForKey:@"sName"];
        name = [NSString stringWithFormat:@"%@ + XX",name];
        [destinationInstance setValue:name forKey:@"sName"];
        
        [destinationInstance setValue:@"+Custom1!!!" forKey:@"newField"];
    }
    
    if([name compare:@"Sex"] == NSOrderedSame)
    {
//        NSLog(@"--custom for Sex");
        
        NSString *name = [sourceInstance valueForKey:@"descr"];
        name = [NSString stringWithFormat:@"%@ + YY",name];
        [destinationInstance setValue:name forKey:@"descr"];
        
        [destinationInstance setValue:@"+Custom2!!!" forKey:@"newField"];
    }
}

@end


