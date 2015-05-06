//
//  AppDelegate.m
//  test_nav_xib
//
//  Created by Sergei on 19.10.14.
//  Copyright (c) 2014 Sergei. All rights reserved.
//

#import "AppDelegate.h"

#import "MasterViewController.h"

#import "NSObject+Dealloc.h"
#import "Test1_VC.h"

#ifdef use_FIC_Cache
    #import "FICImageCache.h"
    //#import "FICDPhoto.h"
#endif

#ifdef use_SDW_Cache
//    #import "SDImageCache.h"
//    #import "UIImageView+WebCache.h"
#endif

#ifdef use_Haneke_Cache
    #import "Haneke.h"
#endif



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


@interface AppDelegate () <FICImageCacheDelegate>

@end



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
    NSLog(@"documents=%@",s1);
//    NSString *s2 = NSHomeDirectory();
    NSLog(@"Home_path=%@",NSHomeDirectory());
    
    [Test1_VC RP_toggleSwizzDealloc]; //set custom dealloc!!!
    
#ifdef use_FIC_Cache
    [self initFCCache];
#endif
    
#ifdef use_SDW_Cache
 //   [self initSDWCache];
#endif
  
#ifdef use_Haneke_Cache
//    [self initHanekeCache];
#endif
 
    return YES;
}

-(void)initHanekeCache
{
    return;
    
    NSDictionary *dic = [HNKCache sharedCache].formats;
    
    HNKCacheFormat *format = [[HNKCacheFormat alloc] initWithName:@"thumbnail_110"];

    long long size1 = [format diskCapacity];
    long long size2 = [format diskSize];
    
    format.compressionQuality = 0.5;
    // UIImageView category default: 0.75, -[HNKCacheFormat initWithName:] default: 1.
    
    format.allowUpscaling = YES;
    // UIImageView category default: YES, -[HNKCacheFormat initWithName:] default: NO.
    
    format.diskCapacity = 0.5 * 1024 * 1024;
    // UIImageView category default: 10 * 1024 * 1024 (10MB), -[HNKCacheFormat initWithName:] default: 0 (no disk cache).
    
    format.preloadPolicy = HNKPreloadPolicyAll;
    // Default: HNKPreloadPolicyNone.
    
    format.scaleMode = HNKScaleModeAspectFill;
    // UIImageView category default: -[UIImageView contentMode], -[HNKCacheFormat initWithName:] default: HNKScaleModeFill.
    
    format.size = CGSizeMake(110, 110);
    // UIImageView category default: -[UIImageView bounds].size, -[HNKCacheFormat initWithName:] default: CGSizeZero.
    

    [[HNKCache sharedCache] registerFormat:format];
    
    
    format = [[HNKCacheFormat alloc] initWithName:@"thumbnail_150"];
    
//    long long size1 = [format diskCapacity];
//    long long size2 = [format diskSize];
    
    format.compressionQuality = 0.5;
    // UIImageView category default: 0.75, -[HNKCacheFormat initWithName:] default: 1.
    
    format.allowUpscaling = YES;
    // UIImageView category default: YES, -[HNKCacheFormat initWithName:] default: NO.
    
    format.diskCapacity = 0.5 * 1024 * 1024;
    // UIImageView category default: 10 * 1024 * 1024 (10MB), -[HNKCacheFormat initWithName:] default: 0 (no disk cache).
    
    format.preloadPolicy = HNKPreloadPolicyLastSession;
    // Default: HNKPreloadPolicyNone.
    
    format.scaleMode = HNKScaleModeAspectFill;
    // UIImageView category default: -[UIImageView contentMode], -[HNKCacheFormat initWithName:] default: HNKScaleModeFill.
    
    format.size = CGSizeMake(150, 150);
    // UIImageView category default: -[UIImageView bounds].size, -[HNKCacheFormat initWithName:] default: CGSizeZero.
    
    
    [[HNKCache sharedCache] registerFormat:format];
    
    dic = [HNKCache sharedCache].formats;
}


-(void)initSDWCache
{
    //Add a custom read-only cache path
//    NSString *bundledPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Custom_Path_Images"];
//    [[SDImageCache sharedImageCache] addReadOnlyCachePath:bundledPath];
//    NSLog(@"SDWCache_path=/%@/",bundledPath); //zs
    
    
    static dispatch_once_t wb_cache;
    dispatch_once(&wb_cache, ^{
        NSUInteger m1 = [SDImageCache sharedImageCache].maxCacheSize;
        NSUInteger m2 = [SDImageCache sharedImageCache].maxCacheAge;
        NSLog(@"cache1=%u max size / %u max age",m1,m2);
        [SDImageCache sharedImageCache].maxCacheSize = (1024*1024) * 50; //50 mb
        [SDImageCache sharedImageCache].maxCacheAge = (60*60*24*14); //14 days
        m1 = [SDImageCache sharedImageCache].maxCacheSize;
        m2 = [SDImageCache sharedImageCache].maxCacheAge;
        NSLog(@"cache2=%u max size / %u max days",m1,m2 / (60*60*24));
        
        m1 = [[SDImageCache sharedImageCache] getDiskCount];
        m2 = [[SDImageCache sharedImageCache] getSize];
        NSLog(@"cache=%u files /  %u bytes",m1,m2);
        
        [[SDImageCache sharedImageCache] cleanDiskWithCompletionBlock:^{}];
        m1 = [[SDImageCache sharedImageCache] getDiskCount];
        m2 = [[SDImageCache sharedImageCache] getSize];
        NSLog(@"clean=%u files /  %u bytes",m1,m2);
        m1=0;
    });
    
}

-(void)initFCCache
{
    static NSString *XXImageFormatNameUserThumbnailSmall =  @"com.mycompany.myapp.XXImageFormatNameUserThumbnail_Small";
    static NSString *XXImageFormatNameUserThumbnailMedium = @"com.mycompany.myapp.XXImageFormatNameUserThumbnail_Medium";
    static NSString *XXImageFormatFamilyUserThumbnails =    @"com.mycompany.myapp.XXImageFormatFamilyUserThumbnails";
    
    FICImageFormat *smallUserThumbnailImageFormat = [[FICImageFormat alloc] init];
    smallUserThumbnailImageFormat.name = XXImageFormatNameUserThumbnailSmall;
    smallUserThumbnailImageFormat.family = XXImageFormatFamilyUserThumbnails;
    smallUserThumbnailImageFormat.style = FICImageFormatStyle16BitBGR;
    smallUserThumbnailImageFormat.imageSize = CGSizeMake(50, 50);
    smallUserThumbnailImageFormat.maximumCount = 250;
    smallUserThumbnailImageFormat.devices = FICImageFormatDevicePhone;
    smallUserThumbnailImageFormat.protectionMode = FICImageFormatProtectionModeNone;
    
    FICImageFormat *mediumUserThumbnailImageFormat = [[FICImageFormat alloc] init];
    mediumUserThumbnailImageFormat.name = XXImageFormatNameUserThumbnailMedium;
    mediumUserThumbnailImageFormat.family = XXImageFormatFamilyUserThumbnails;
    mediumUserThumbnailImageFormat.style = FICImageFormatStyle32BitBGRA;
    mediumUserThumbnailImageFormat.imageSize = CGSizeMake(100, 100);
    mediumUserThumbnailImageFormat.maximumCount = 250;
    mediumUserThumbnailImageFormat.devices = FICImageFormatDevicePhone;
    mediumUserThumbnailImageFormat.protectionMode = FICImageFormatProtectionModeNone;
    
    NSArray *imageFormats = @[smallUserThumbnailImageFormat, mediumUserThumbnailImageFormat];
    
    // Configure the image cache
    FICImageCache *sharedImageCache = [FICImageCache sharedImageCache];
    [sharedImageCache setDelegate:self];
    [sharedImageCache setFormats:imageFormats];
    
}


//-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    NSString *viewControllerClassName = [NSString stringWithUTF8String:object_getClassName(window.rootViewController)];
//    if ([viewControllerClassName isEqualToString:@"UINavigationController"])   {
//        return UIInterfaceOrientationMaskPortrait;
//    }
//    else {
//        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
//    }
//}


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
    
//    NSNotification *anote1 = [NSNotification notificationWithName:@"kRefreshAfterBackgroundState" object:nil userInfo:nil];
//    [[NSNotificationCenter defaultCenter] postNotification:anote1];
    
/*
    for (UIWindow *window in [UIApplication sharedApplication].windows) { //zs
        NSLog(@"-setNeedsLayout1-");
        [window setNeedsLayout];
 //     [window setNeedsDisplay];
    }
    
    NSLog(@"-setNeedsLayout2-");
    [self.window.rootViewController.view setNeedsLayout];
*/
    
//    [self performSelector:@selector(action) withObject:nil afterDelay:1.0];
}

-(void)action
{
    for (UIWindow *window in [UIApplication sharedApplication].windows) { //zs
        NSLog(@"-setNeedsLayout2-");
        //        [window setNeedsLayout];
        [window setNeedsDisplay];
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



#pragma mark - FICImageCacheDelegate

//- (void)imageCache:(FICImageCache *)imageCache wantsSourceImageForEntity:(id<FICEntity>)entity withFormatName:(NSString *)formatName completionBlock:(FICImageRequestCompletionBlock)completionBlock {
//    // Images typically come from the Internet rather than from the app bundle directly, so this would be the place to fire off a network request to download the image.
//    // For the purposes of this demo app, we'll just access images stored locally on disk.
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        UIImage *sourceImage = [(FICDPhoto *)entity sourceImage];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            completionBlock(sourceImage);
//        });
//    });
//}

- (BOOL)imageCache:(FICImageCache *)imageCache shouldProcessAllFormatsInFamily:(NSString *)formatFamily forEntity:(id<FICEntity>)entity {
    return NO;
}

- (void)imageCache:(FICImageCache *)imageCache errorDidOccurWithMessage:(NSString *)errorMessage {
    NSLog(@"%@", errorMessage);
}



@end
