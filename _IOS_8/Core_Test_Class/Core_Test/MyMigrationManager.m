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
    static int i1 = 0;
    NSString *res = [NSString stringWithFormat:@"%@ +%@",str,addStr];
    if (++i1 % 500 == 2) {
        NSLog(@"_%02d) (%@)->(%@)",i1,str,res);
    }
    return res;
}

- (NSString*)fillWithString:(NSString*)addStr
{
    static int i2 = 0;
    NSString *res = [NSString stringWithFormat:@"+%@",addStr];
    if (++i2 % 500 == 1) {
        NSLog(@"_%02d) (%@)",i2,res);
    }
    return res;
}

- (NSString*)fillWithStr:(NSString*)addStr
{
    static int i3 = 0;
    NSString *res = [NSString stringWithFormat:@"+%@",addStr];
    if (++i3 % 500 == 1) {
        NSLog(@"_%02d) (%@)",i3,res);
    }
    return res;
}




-(void)associateSourceInstance:(NSManagedObject*)sourceInstance withDestinationInstance:(NSManagedObject *)destinationInstance forEntityMapping:(NSEntityMapping *)entityMapping
{
    [super associateSourceInstance:sourceInstance withDestinationInstance:destinationInstance forEntityMapping:entityMapping];
    NSString *name = [entityMapping destinationEntityName];
    
    static int i = 0;
    if (++i % 500 == 0) {
        NSLog(@"--%02d--> migration Manager for = %@",i,name);
    //    sleep(1);
    }
    
    
    if([name compare:@"Person"] == NSOrderedSame)
    {
        //        NSLog(@"-->custom for Person");
        
        NSString *name = [sourceInstance valueForKey:@"sName"];
        name = [NSString stringWithFormat:@"%@ .",name];
        [destinationInstance setValue:name forKey:@"sName"];
        
//        if ([name hasSuffix:@". . ."]) {
//            name = [sourceInstance valueForKey:@"newField3"];
//            if (name.length) {
//                [destinationInstance setValue:nil forKey:@"newField3"];
//            }
//        }
        
        
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
    
    
    if([name compare:@"VideoItem"] == NSOrderedSame)
    {
        //        NSLog(@"--custom for Sex");
        
        NSString *name = [sourceInstance valueForKey:@"db_channelTitle"];
        name = [NSString stringWithFormat:@"%@ .",name];
        [destinationInstance setValue:name forKey:@"db_channelTitle"];
        
 //       [destinationInstance setValue:@"+Custom2!!!" forKey:@"newField"];
    }
    
    
}

@end
