//
//  MigrationManager_4_5.m
//  Core_Test
//
//  Created by Zmachinsky Sergei on 09.03.15.
//  Copyright (c) 2015 Zmachinsky Sergei. All rights reserved.
//

#import "MigrationManager_4_5.h"

@implementation MigrationManager_4_5


- (NSString*)getNewName:(NSData*)nativeData
{
    @try
    {
        NSDictionary* dict = [NSKeyedUnarchiver unarchiveObjectWithData:nativeData];
        if (![dict isKindOfClass:[NSDictionary class]]) {
            return @"";
        }
        NSLog(@"%@",dict);
        return @"new detail";//[dict youtube_AuthorString];
    }
    @catch(...)
    {
        return @"!err";
    }
}


- (NSString*)emptyString
{
    return @"ччч";
}

- (NSString*)addString:(NSString*)nativeData
{
//    @try
//    {
        NSString *res = [NSString stringWithFormat:@"/%@/+add",nativeData];
        return res;
//    }
//    @catch(...)
//    {
//        return @"";
//    }
}


- (NSString*)getAuthor:(NSData*)nativeData
{
    @try
    {
        NSDictionary* dict = [NSKeyedUnarchiver unarchiveObjectWithData:nativeData];
        if (![dict isKindOfClass:[NSDictionary class]])
            return @"!!!";
        
        return @"???";//[dict youtube_AuthorString];
    }
    @catch(...)
    {
        return @"err";
    }
}


-(void)associateSourceInstance:(NSManagedObject*)sourceInstance withDestinationInstance:(NSManagedObject *)destinationInstance forEntityMapping:(NSEntityMapping *)entityMapping
{
    [super associateSourceInstance:sourceInstance withDestinationInstance:destinationInstance forEntityMapping:entityMapping];
    NSString *name = [entityMapping destinationEntityName];
    
    static int i = 0;
    NSLog(@"--%02d--> migrate Manager_4_5 for = %@",++i,name);
    sleep(1);
    
    if([name compare:@"MigrEvent"] == NSOrderedSame || [name compare:@"MigrEvent"] == NSOrderedSame)
    {
        // Generate UUID
//        CFUUIDRef theUUID = CFUUIDCreate(NULL);
//        CFStringRef string = CFUUIDCreateString(NULL, theUUID); CFRelease(theUUID);
//        NSString *uuid = (__bridge NSString *)string;
        NSString *sss = [sourceInstance valueForKey:@"detail_1"];
        NSLog(@"custom migrate Manager for = %@",sss);
        
        [destinationInstance setValue:@"+Custom1!!!" forKey:@"detail_1"];
//        [destinationInstance setValue:@"+Custom2!!!" forKey:@"detail_2"];
//        [destinationInstance setValue:@"+Cust-field" forKey:@"field"];
    }
}

@end
