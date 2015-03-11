//
//  MigrationManager_4_5.m
//  Core_Test
//
//  Created by Zmachinsky Sergei on 09.03.15.
//  Copyright (c) 2015 Zmachinsky Sergei. All rights reserved.
//

#import "MigrationManager_4_5.h"

@implementation MigrationManager_4_5

-(void)associateSourceInstance:(NSManagedObject*)sourceInstance withDestinationInstance:(NSManagedObject *)destinationInstance forEntityMapping:(NSEntityMapping *)entityMapping
{
    [super associateSourceInstance:sourceInstance withDestinationInstance:destinationInstance forEntityMapping:entityMapping];
    NSString *name = [entityMapping destinationEntityName];
    
    if([name compare:@"MigrEvent"] == NSOrderedSame || [name compare:@"MigrEvent"] == NSOrderedSame)
    {
        // Generate UUID
//        CFUUIDRef theUUID = CFUUIDCreate(NULL);
//        CFStringRef string = CFUUIDCreateString(NULL, theUUID); CFRelease(theUUID);
//        NSString *uuid = (__bridge NSString *)string;
        NSString *sss = [sourceInstance valueForKey:@"detail_1"];
        NSLog(@"migrate for = %@",sss);
        
        [destinationInstance setValue:@"+Custom1!!!" forKey:@"detail_1"];
        [destinationInstance setValue:@"+Custom2!!!" forKey:@"detail_2"];
        [destinationInstance setValue:@"+Cust-field" forKey:@"field"];
    }
}

@end
