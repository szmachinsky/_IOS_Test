//
//  AppDelegate.h
//  Test_1
//
//  Created by svp on 25.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    MasterViewController    *masterViewController_;
    UINavigationController  *navigationController_;
}

@property (strong, nonatomic) UIWindow *window;

@end
