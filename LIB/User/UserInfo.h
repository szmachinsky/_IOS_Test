//
//  UserInfo.h
//  Test_1
//
//  Created by svp on 03.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject {
@private
    int idd;
    
}
@property (nonatomic,assign) int idd;

+ (UserInfo*)shared;

@end
