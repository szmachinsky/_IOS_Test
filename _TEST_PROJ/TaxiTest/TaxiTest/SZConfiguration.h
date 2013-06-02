//
//  SZConfiguration.h
//  TaxiTest
//
//  Created by Admin on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define _DEBUG_MSG
#define _DEBUG_MSG0
#define _DEBUG_MSG1
#define _DEBUG_MSG2

#ifdef _DEBUG_MSG
#define _NSLog(...)  NSLog(__VA_ARGS__)
#else
#define _NSLog(...)
#endif

#ifdef _DEBUG_MSG0
#define _NSLog0(...)  NSLog(__VA_ARGS__)
#else
#define _NSLog0(...)
#endif

#ifdef _DEBUG_MSG1
#define _NSLog1(...)  NSLog(__VA_ARGS__)
#else
#define _NSLog1(...)
#endif

#ifdef _DEBUG_MSG2
#define _NSLog2(...)  NSLog(__VA_ARGS__)
#else
#define _NSLog2(...)
#endif

