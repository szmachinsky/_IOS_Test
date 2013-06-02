//
//  SZUtils.h
//  TaxiTest
//
//  Created by Admin on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZUtils : NSObject

+ (void)callToNumber:(NSString*)phoneNumber;

+ (UIImage *)thumbnailFromImage:(UIImage *)imageFrom forSize:(float)sz radius:(float)rad;

@end
