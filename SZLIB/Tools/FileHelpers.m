//
//  FileHelpers.m
//  Test_1
//
//  Created by svp on 13.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//#include <stdio.h>
#import "FileHelpers.h"


NSString *pathWithDocDir(NSString *fileName) 
{ 
    // Get list of document directories in sandbox 
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);     
    // Get one and only document directory from that list 
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];     
    // Append passed in file name to that directory, return it 
    return [documentDirectory stringByAppendingPathComponent:fileName]; 
} 



NSString *pathInDocDir(NSString	*fileName) 
{ 
    NSString *sandboxPath = NSHomeDirectory(); //full sandbox path 
    NSString *documentPath = [sandboxPath stringByAppendingPathComponent:@"Documents"]; 
    return [documentPath stringByAppendingPathComponent:fileName];     
}

NSString *pathInCachesDir(NSString	*fileName) 
{ 
    NSString *sandboxPath = NSHomeDirectory(); //full sandbox path 
    NSString *documentPath = [sandboxPath stringByAppendingPathComponent:@"Caches"]; 
    return [documentPath stringByAppendingPathComponent:fileName];     
}

NSString *pathInTmpDir(NSString	*fileName) 
{ 
    NSString *sandboxPath = NSHomeDirectory(); //full sandbox path 
    NSString *documentPath = [sandboxPath stringByAppendingPathComponent:@"Tmp"]; 
    return [documentPath stringByAppendingPathComponent:fileName];
}

NSString *pathInTmp2Dir(NSString *fileName) 
{ 
    return [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
}
