//
//  AppDelegate.m
//  TaxiTest
//
//  Created by Admin on 05.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "SZCallListViewController.h"
#import "SZOnlineViewController.h"
#import "SZOptionsViewController.h"
#import "SZAboutViewController.h"

#import "TMapViewController.h"

#import "SZMCountry.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    [SZAppInfo sharedInstance].model = [SZMCountry addCountry1]; //generate model
    [SZAppInfo sharedInstance].regionName = @"Минская область";
    [SZAppInfo sharedInstance].cityName = @"Минск";
    
        
    SZCallListViewController *callListViewController = [[SZCallListViewController alloc] initWithNibName:@"SZCallListViewController" bundle:nil];    
    UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:callListViewController];    
    navigationController1.tabBarItem.title = @"Вызов такси";
    navigationController1.tabBarItem.image = [UIImage imageNamed:@"icon_list_numbers"];
//    [navigationController1.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"icon_list_numbers"] withFinishedUnselectedImage:[UIImage imageNamed:@"icon_list_bullets"]];
//    navigationController1.navigationBar.tintColor = [UIColor blackColor];
//    navigationController1.navigationBar.tintColor = [SZColor colorTaxiListCellBack];
    navigationController1.navigationBar.tintColor = [SZColor colordarkGrayBack];

    
    
///    SZOnlineViewController *onlineViewController = [[SZOnlineViewController alloc] initWithNibName:@"SZOnlineViewController" bundle:nil];
    
    TMapViewController *onlineViewController = [[TMapViewController alloc] initWithNibName:@"TMapViewController" bundle:nil];
    
    
    UINavigationController *navigationController2 = [[UINavigationController alloc] initWithRootViewController:onlineViewController];    
    navigationController2.tabBarItem.title = @"Онлайн вызов";
    navigationController2.tabBarItem.image = [UIImage imageNamed:@"scanner"];
//    [navigationController2.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"scanner"] withFinishedUnselectedImage:[UIImage imageNamed:@"scanner"]];
//    navigationController2.navigationBar.tintColor = [UIColor blackColor];
    navigationController2.navigationBar.tintColor = [SZColor colordarkGrayBack];
    
    
    
    SZOptionsViewController *optionsViewController = [[SZOptionsViewController alloc] initWithNibName:@"SZOptionsViewController" bundle:nil];    
    UINavigationController *navigationController3 = [[UINavigationController alloc] initWithRootViewController:optionsViewController];    
    navigationController3.tabBarItem.title = @"Настройки";
    navigationController3.tabBarItem.image = [UIImage imageNamed:@"icon_settings"];
//    [navigationController3.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"icon_settings"] withFinishedUnselectedImage:[UIImage imageNamed:@"icon_settings"]];
//    navigationController3.navigationBar.tintColor = [UIColor blackColor];
    navigationController3.navigationBar.tintColor = [SZColor colordarkGrayBack];
    
    
    SZAboutViewController *aboutViewController = [[SZAboutViewController alloc] initWithNibName:@"SZAboutViewController" bundle:nil];    
    aboutViewController.tabBarItem.title = @"О программе";
    aboutViewController.tabBarItem.image = [UIImage imageNamed:@"icon_information"];
//    [aboutViewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"icon_information"] withFinishedUnselectedImage:[UIImage imageNamed:@"icon_information"]];
    
        
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:navigationController1, navigationController2, navigationController3, aboutViewController, nil];
//  self.tabBarController.tabBar.tintColor = [UIColor greenColor];
    
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}




- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
