//
//  SZUtils.m
//  TaxiTest
//
//  Created by Admin on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SZUtils.h"

@implementation SZUtils



+ (void)callToNumber:(NSString*)phoneNumber
{
    if ([UIApplication instancesRespondToSelector:@selector(canOpenURL:)]) {        
//        NSString *phoneNumber = @"1-800-555-1212"; 
        NSString *phoneURLString = [NSString stringWithFormat:@"tel:%@", phoneNumber];
        NSURL *aURL = [NSURL URLWithString:phoneURLString]; 
        if ([[UIApplication sharedApplication] canOpenURL:aURL]) 
        { 
            [[UIApplication sharedApplication] openURL:aURL]; 
        } 
    }    
    
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
    
   // Clean up image context resources 
    UIGraphicsEndImageContext();    
    return imgTo;
}



@end
