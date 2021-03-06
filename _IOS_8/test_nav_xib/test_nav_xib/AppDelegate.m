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

#include <mach/mach.h>
#include <mach/mach_time.h>


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



//@implementation UINavigationController (OrientationSettings_IOS6)
//
//-(BOOL)shouldAutorotate {
//    NSLog(@"-1-Main_shouldAutorotate");
//    return [[self.viewControllers lastObject] shouldAutorotate];
//}
//
//-(NSUInteger)supportedInterfaceOrientations {
//    NSLog(@"-2-Main_supportedInterfaceOrientations");
//   return [[self.viewControllers lastObject] supportedInterfaceOrientations];
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    NSLog(@"-3-Main_preferredInterfaceOrientationForPresentation");
//    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
//}
//@end


uint64_t getTickCount(void)
{
    static mach_timebase_info_data_t sTimebaseInfo;
    uint64_t machTime = mach_absolute_time();
    
    // Convert to nanoseconds - if this is the first time we've run, get the timebase.
    if (sTimebaseInfo.denom == 0 )
    {
        (void) mach_timebase_info(&sTimebaseInfo);
    }
    
    // Convert the mach time to milliseconds
    uint64_t millis = ((machTime / 1000000) * sTimebaseInfo.numer) / sTimebaseInfo.denom;
    return millis;
}


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"\n\n---didFinishLaunchingWithOptions--0--\n\n");
    uint64_t t1 = getTickCount();
    
    
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
    
    { // exclude dir from backup
        NSURL* rootPathURL = [NSURL fileURLWithPath:NSTemporaryDirectory()];
        [rootPathURL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:NULL];
    }
    
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
 
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    }
    
    
    uint64_t t2 = getTickCount();
    NSLog(@">-time to start app = (%llu)ms",(t2-t1));
    
    [[UIApplication sharedApplication] keyWindow].tintColor = [UIColor orangeColor];
    
    NSArray *arr = [[UIApplication sharedApplication] shortcutItems];
    NSLog(@"\n\n arr=(%@) \n\n",arr);
    
    
    if([[UIApplicationShortcutItem class] respondsToSelector:@selector(new)]){
        
        [self configDynamicShortcutItems];
    }
    
    if ( (launchOptions) && ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) )
    {        
        NSLog(@"\n\n launchOptions(%@)",launchOptions);
        UIApplicationShortcutItem *shortcutItem =launchOptions[@"UIApplicationLaunchOptionsShortcutItemKey"];
        if ([shortcutItem  isKindOfClass:[UIApplicationShortcutItem class]]) 
        {
            NSLog(@"\n shortcutItem:(%@) (%@)\n\n",shortcutItem.localizedTitle,shortcutItem.type);
            [self handleShortcutItem:shortcutItem];
            return NO;
        }
    }

    NSLog(@"\n\n---0--end--\n\n");
    
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
    NSLog(@"+++++++++++++++0-- Will_Resign_Active --");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"+++++++++++++++1-- Will_Enter_Background --");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"+++++++++++++++2-- Will_Enter_Foreground --");
//    NSNotification *anote1 = [NSNotification notificationWithName:@"kRefreshAfterBackgroundState" object:nil userInfo:nil];
//    [[NSNotificationCenter defaultCenter] postNotification:anote1];
    
    
//    NSNotification *anote2 = [NSNotification notificationWithName:UIDeviceOrientationDidChangeNotification object:nil userInfo:nil];
//    [[NSNotificationCenter defaultCenter] postNotification:anote2];
    

}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"+++++++++++++++3-- Did___Become_Active --");
    
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



/**
 *  @brief config dynamic shortcutItems
 *  @discussion after first launch, users can see dynamic shortcutItems
 */
- (void)configDynamicShortcutItems 
{
    
    NSLog(@"\n\n configDynamicShortcutItems \n\n");
    
    
    // config image shortcut items
    // if you want to use custom image in app bundles, use iconWithTemplateImageName method
    UIApplicationShortcutIcon *shortcutSearchIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];
    UIApplicationShortcutIcon *shortcutFavoriteIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeLove];
    
    UIApplicationShortcutItem *shortcutSearch = [[UIApplicationShortcutItem alloc]
                                                 initWithType:@".Search"
                                                 localizedTitle:@"Item Search"
                                                 localizedSubtitle:nil
                                                 icon:shortcutSearchIcon
                                                 userInfo:nil];
    
    UIApplicationShortcutItem *shortcutFavorite = [[UIApplicationShortcutItem alloc]
                                                   initWithType:@".Favorite"
                                                   localizedTitle:@"Item Favorite"
                                                   localizedSubtitle:nil
                                                   icon:shortcutFavoriteIcon
                                                   userInfo:nil];
    
    
    // add all items to an array
    NSArray *items = @[shortcutSearch, shortcutFavorite];
    
    // add the array to our app
    [UIApplication sharedApplication].shortcutItems = items;
}


- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
                                                            completionHandler:(void (^)(BOOL succeeded))completionHandler
{
    NSLog(@"\n\n 3D TOUCH:(%@) (%@)\n\n",shortcutItem.localizedTitle,shortcutItem.type);
    [self handleShortcutItem:shortcutItem];
//    if (completionHandler) {
//        completionHandler(NO);
//    }
    
}


- (void)handleShortcutItem:(UIApplicationShortcutItem *)shortcutItem
{
    NSLog(@"\n\n HANDLE (%@) \n\n",shortcutItem);
}


@end
