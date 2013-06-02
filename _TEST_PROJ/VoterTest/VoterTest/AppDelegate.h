//
//  AppDelegate.h
//  VoterTest
//
//  Created by User on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MasterViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    MasterViewController *masterViewController;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@end
