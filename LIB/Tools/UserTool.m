//
//  UserTool.m
//  Test_1
//
//  Created by svp on 03.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserTool.h"


static int netActivityReqs_ = 0;


@implementation UserTool

//========================NetworcActivityIndicator===================================
#pragma mark NetworcActivityIndicator
+ (void) netActivityON 
{
  @synchronized(self)
  {
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES;    
	netActivityReqs_++;
  }    
}

+ (void) netActivityOFF 
{    
  @synchronized(self)
  {
	if(--netActivityReqs_ <= 0)
	{
        [self netActivityStop];
	} 
  }    
}

+ (void) netActivityStop 
{
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
    netActivityReqs_ = 0;    
}

//========================shiftRandom===================================
#pragma mark shiftRandom
+ (void) shiftRandom:(int)shift
{   if (shift <= 0) return;
    long rnd0 = (shift / 10) + 1;
    long rnd1 = (time(NULL) % shift);
    long rnd2 = (clock()%shift);
    long rnd = rnd0 + rnd1 + rnd2;
//  NSLog(@" shift Random %ld = %ld + %ld + %ld",rnd,rnd0,rnd1,rnd2);
    for(long id=0; id<=(rnd); id++) {
        rand();   //shift random int
        random(); //shift random long
    }    
}

//========================UUIDString===================================
#pragma mark UUIDString
+ (NSString*)UUIDString //universally	unique	identifiers	(UUIDs)
{
    NSString *uuid = nil;
    // Create a CFUUID object - it knows how to create unique identifiers
    CFUUIDRef newUniqueID = CFUUIDCreate (kCFAllocatorDefault);    
    // Create a string from unique identifier 
    CFStringRef newUniqueIDString = CFUUIDCreateString (kCFAllocatorDefault, newUniqueID);     
    uuid = (NSString *)newUniqueIDString; 
    [[uuid retain] autorelease];
    // We used "Create" in the functions to make objects, we need to release them 
    CFRelease(newUniqueID);  
    CFRelease(newUniqueIDString); 
    return uuid;
}


//========================thumbnailFromImage===================================
#pragma mark Image's methods
+ (UIImage *)thumbnailFromImage:(UIImage *)imageFrom forSize:(float)sz radius:(float)rad
{
    float mx = sz;
    float my = sz;
    float x = imageFrom.size.width;
    float y = imageFrom.size.height;
    float d = x / y;
    if (d >= 1) {
        my = my / d;
    } else {
        mx = mx * d;
    }    
    CGRect imageRect = CGRectMake(0, 0, roundf(mx),roundf(my)); 
    UIGraphicsBeginImageContext(imageRect.size);    
    
    if (rad > 0.0) {
        UIBezierPath *bez = [UIBezierPath bezierPathWithRoundedRect:imageRect cornerRadius:rad];
        [bez addClip];
    }
    
    // Render the big image onto the image context 
    [imageFrom drawInRect:imageRect];    
    // Make a new one from the image contextpickerCell_.cellImage.image    
    UIImage *imgTo = UIGraphicsGetImageFromCurrentImageContext();
    
//  NSData *data1 = UIImageJPEGRepresentation(imageFrom, 0.75);
//  NSData *data2 = UIImageJPEGRepresentation(imgTo, 0.75);
//    NSData *data1 = UIImagePNGRepresentation(imageFrom);
//    NSData *data2 = UIImagePNGRepresentation(imgTo);    
//    int i1 = data1.length;
//    int i2 = data2.length;
//    NSLog(@" image from %d to %d",i1,i2);
    
    // Clean up image context resources 
    UIGraphicsEndImageContext();    
    return imgTo;
}



//========================xxxxxxxxxxxxxxxxxxxxxxxx===================================
//========================xxxxxxxxxxxxxxxxxxxxxxxx===================================
//========================xxxxxxxxxxxxxxxxxxxxxxxx===================================
//========================xxxxxxxxxxxxxxxxxxxxxxxx===================================

@end
