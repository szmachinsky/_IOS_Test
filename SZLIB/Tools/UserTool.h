//
//  UserTool.h
//  Test_1
//
//  Created by svp on 03.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserTool : NSObject
{
    
}

+ (void) netActivityON; 
+ (void) netActivityOFF; 
+ (void) netActivityStop;

+ (void) shiftRandom:(int)shift;
+ (NSString*)UUIDString;

//+ (UIImage *)thumbnailFromImage:(UIImage *)imageFrom forSize:(float)sz;
+ (UIImage *)thumbnailFromImage:(UIImage *)imageFrom forSize:(float)sz radius:(float)rad;

@end
