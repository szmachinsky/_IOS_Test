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

- (NSString*)ensureNotEmptyString:(NSString*)s
{
    if (s)
        return s;
    return [self emptyString];
}

- (NSString*)emptyString
{
    return @"";
}

- (NSString*)getAuthor:(NSData*)nativeData
{
    @try
    {
        NSDictionary* dict = [NSKeyedUnarchiver unarchiveObjectWithData:nativeData];
        if (![dict isKindOfClass:[NSDictionary class]])
            return @"";
        
        return nil;//[dict youtube_AuthorString];
    }
    @catch(...)
    {
        return @"";
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


@end



