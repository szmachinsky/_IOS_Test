//
//  BPMigrationManager.m
//  Core_Test
//
//  Created by Zmachinsky Sergei on 17.03.15.
//  Copyright (c) 2015 Zmachinsky Sergei. All rights reserved.
//

#import "BPMigrationManager.h"
#import <CoreData/CoreData.h>


@interface BPMigrationManager ()

@end


@implementation BPMigrationManager

- (NSDate*)defaultDate{
    static NSDate* def = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDateComponents* components = [[NSDateComponents alloc] init];
        components.year = 1970;
        components.month = 1;
        components.day = 1;
        def = [[NSCalendar autoupdatingCurrentCalendar] dateFromComponents:components];
    });
    return def;
}


- (NSString*)emptyString
{
    return @"";
}


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

- (NSString*)getDescription:(NSData*)nativeData
{
    @try
    {
        NSDictionary* dict = [NSKeyedUnarchiver unarchiveObjectWithData:nativeData];
        if (![dict isKindOfClass:[NSDictionary class]])
            return @"";
        
        return nil;//[dict youtube_DescriptionString];
    }
    @catch(...)
    {
        return @"";
    }
}



- (NSNumber*)getDislikeCount:(NSData*)nativeData
{
    @try
    {
        NSDictionary* dict = [NSKeyedUnarchiver unarchiveObjectWithData:nativeData];
        if (![dict isKindOfClass:[NSDictionary class]])
            return @(0);
        
        return @(0);//([[dict youtube_DislikesCountString] integerValue]);
    }
    @catch(...)
    {
        return @(0);
    }
}


- (NSString*)getHRTURL:(NSData*)nativeData{
    @try
    {
        NSDictionary* dict = [NSKeyedUnarchiver unarchiveObjectWithData:nativeData];
        if (![dict isKindOfClass:[NSDictionary class]])
            return @"";
        
        return nil;//[[dict youtube_HighResolutionThumbmailURL] absoluteString];
    }
    @catch(...)
    {
        return @"";
    }
}



-(void)associateSourceInstance:(NSManagedObject*)sourceInstance withDestinationInstance:(NSManagedObject *)destinationInstance forEntityMapping:(NSEntityMapping *)entityMapping
{
    [super associateSourceInstance:sourceInstance withDestinationInstance:destinationInstance forEntityMapping:entityMapping];
    NSString *name = [entityMapping destinationEntityName];
    static int i = 0;
    NSLog(@"--%02d--> migrate Manager for = %@",++i,name);
   
//    if([name compare:@"MigrEvent"] == NSOrderedSame || [name compare:@"MigrEvent"] == NSOrderedSame)
//    {
//        // Generate UUID
//        //        CFUUIDRef theUUID = CFUUIDCreate(NULL);
//        //        CFStringRef string = CFUUIDCreateString(NULL, theUUID); CFRelease(theUUID);
//        //        NSString *uuid = (__bridge NSString *)string;
//        NSString *sss = [sourceInstance valueForKey:@"detail_1"];
//        NSLog(@"custom migrate Manager for = %@",sss);
//        
//        [destinationInstance setValue:@"+Custom1!!!" forKey:@"detail_1"];
//        //        [destinationInstance setValue:@"+Custom2!!!" forKey:@"detail_2"];
//        //        [destinationInstance setValue:@"+Cust-field" forKey:@"field"];
//    }
}


@end



