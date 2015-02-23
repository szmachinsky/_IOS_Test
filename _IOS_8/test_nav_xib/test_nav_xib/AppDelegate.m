//
//  AppDelegate.m
//  test_nav_xib
//
//  Created by Sergei on 19.10.14.
//  Copyright (c) 2014 Sergei. All rights reserved.
//

#import "AppDelegate.h"

#import "MasterViewController.h"


//#define DOCUMENTS [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

/*

@interface UINavigationController (RotationIOS6)
//@property (nonatomic,retain) id voidVar;
- (BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;
@end


@implementation UINavigationController (RotationIOS6)
//@dynamic voidVar;
-(BOOL)shouldAutorotate
{
    NSLog(@"-2-Main_shouldAutorotate");
    return [self.topViewController shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    NSLog(@"-3-Main_supportedInterfaceOrientations");
    NSUInteger ui = [self.topViewController supportedInterfaceOrientations];
    return ui;
}
@end
*/


@implementation UINavigationController (OrientationSettings_IOS6)

-(BOOL)shouldAutorotate {
    NSLog(@"-1-Main_shouldAutorotate");
    return [[self.viewControllers lastObject] shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations {
    NSLog(@"-2-Main_supportedInterfaceOrientations");
   return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    NSLog(@"-3-Main_preferredInterfaceOrientationForPresentation");
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}
@end



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"---0----");
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    MasterViewController *masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    
    CGRect fr = [[UIScreen mainScreen] bounds];
    NSLog(@"X=%f Y=%f",fr.size.width,fr.size.height);
    
    NSString *s1 = DOCUMENTS; //[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];//NSDocumentDirectory; //DOCUMENTS; //
    NSLog(@"/%@/",s1);
//    NSString *s2 = NSHomeDirectory();
    NSLog(@"app_path=/%@/",NSHomeDirectory());
    
   return YES;
}


//-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    UIViewController *presentedViewController = window.rootViewController.presentedViewController;
//    if (presentedViewController) {
//        NSLog(@"-!!!-Main_supportedInterfaceOrientationsForWindow:%@",NSStringFromClass([presentedViewController class]));
//    }
////    return UIInterfaceOrientationMaskPortrait;
////    return ([presentedViewController supportedInterfaceOrientations]);
//    
////    if (presentedViewController) {
////        if ([presentedViewController isKindOfClass:[UIActivityViewController class]] || [presentedViewController isKindOfClass:[UIAlertController class]]) {
////            return UIInterfaceOrientationMaskPortrait;
////        }
////    }
//    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
//}


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
    NSLog(@"---1----");
//    NSNotification *anote1 = [NSNotification notificationWithName:@"kRefreshAfterBackgroundState" object:nil userInfo:nil];
//    [[NSNotificationCenter defaultCenter] postNotification:anote1];
    
    
//    NSNotification *anote2 = [NSNotification notificationWithName:UIDeviceOrientationDidChangeNotification object:nil userInfo:nil];
//    [[NSNotificationCenter defaultCenter] postNotification:anote2];
    

}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"---2----");
    
    NSNotification *anote1 = [NSNotification notificationWithName:@"kRefreshAfterBackgroundState" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:anote1];
    
    
    for (UIWindow *window in [UIApplication sharedApplication].windows) { //zs
        NSLog(@"-setNeedsLayout-");
        [window setNeedsLayout];
 //       [window setNeedsDisplay];
    }
//    [self performSelector:@selector(action) withObject:nil afterDelay:1.0];
}

-(void)action
{
    for (UIWindow *window in [UIApplication sharedApplication].windows) { //zs
        NSLog(@"-setNeedsLayout-");
        //        [window setNeedsLayout];
        [window setNeedsDisplay];
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
