//
//  Defines.h
//
//  Created by Zmachinsky Sergei on 31.08.15.
//  Copyright (c) 2015 Sergei. All rights reserved.
//

#ifndef test_nav_xib_Defines_h
#define test_nav_xib_Defines_h

#include <Availability.h>

#define DEVICE_SCREEN_HAS_LENGTH(_frame, _length)           (fabsf( MAX(CGRectGetHeight(_frame), CGRectGetWidth(_frame)) - _length) < FLT_EPSILON)
#define DEVICE_IS_IPHONE_5()                                (DEVICE_SCREEN_HAS_LENGTH([UIScreen mainScreen].bounds, 568.f))
#define DEVICE_IS_IPHONE_6()                                (DEVICE_SCREEN_HAS_LENGTH([UIScreen mainScreen].bounds, 667.f))
#define DEVICE_IS_IPHONE_6_PLUS()                           (DEVICE_SCREEN_HAS_LENGTH([UIScreen mainScreen].bounds, 736.f))
#define DEVICE_IS_IPHONE()                                  (UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM())
#define DEVICE_IS_IPAD()                                    (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())

/** Example: STR_SYSTEM_VERSION_EQUAL_TO(@"7.0") */
#define STR_SYSTEM_VERSION_EQUAL_TO(v)                      ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

/** Example: STR_SYSTEM_VERSION_GREATER_THAN(@"7.0") */
#define STR_SYSTEM_VERSION_GREATER_THAN(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

/** Example: STR_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") */
#define STR_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)      ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

/** Example: STR_SYSTEM_VERSION_LESS_THAN(@"7.0") */
#define STR_SYSTEM_VERSION_LESS_THAN(v)                     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

/** Example: STR_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"7.0") */
#define STR_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)         ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/** Example: SYSTEM_VERSION_EQUAL_TO(NSFoundationVersionNumber_iOS_7_0) */
#define SYSTEM_VERSION_EQUAL_TO(_gVersion)                  ( fabsf(NSFoundationVersionNumber - (_gVersion)) < DBL_EPSILON )

/** Example: SYSTEM_VERSION_GREATER_THAN(NSFoundationVersionNumber_iOS_7_0) */
#define SYSTEM_VERSION_GREATER_THAN(_gVersion)              ( NSFoundationVersionNumber >  (_gVersion) )

/** Example: SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(NSFoundationVersionNumber_iOS_7_0) */
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(_gVersion)  ( NSFoundationVersionNumber > (_gVersion) || SYSTEM_VERSION_EQUAL_TO(_gVersion) )

/** Example: SYSTEM_VERSION_LESS_THAN(NSFoundationVersionNumber_iOS_7_0) */
#define SYSTEM_VERSION_LESS_THAN(_gVersion)                 ( NSFoundationVersionNumber <  (_gVersion) )

/** Example: SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(NSFoundationVersionNumber_iOS_7_0) */
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(_gVersion)     ( NSFoundationVersionNumber < (_gVersion) || SYSTEM_VERSION_EQUAL_TO(_gVersion)  )

#define FLOAT_IS_EQUAL_TO_FLOAT(_first, _second)            (fabsf( (_first) - (_second) ) < FLT_EPSILON)

#define DOUBLE_IS_EQUAL_TO_DOUBLE(_first, _second)          (fabsf( (_first) - (_second) ) < FLT_EPSILON)


#endif
