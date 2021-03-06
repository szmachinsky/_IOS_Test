//
//  AppDelegate.m
//  UnitTestMigrator
//
//  Created by Zmachinsky Sergei on 02.04.15.
//  Copyright (c) 2015 Zmachinsky Sergei. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#import "SVProgressHUD.h"
#import "CDMigrator.h"
#import "CDMigrationManager.h"


//#define CORE_NAME  @"TestMigrator"
//#define CORE_FILE  @"TestMigrator.sqlite"
//#define CORE_FILE_DIR  @"Documents/Data/"


@interface AppDelegate ()

@end

@implementation AppDelegate
{
    ViewController *controller;
    NSURL *storeUrl;
    NSURL *modelUrl;
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    controller = (ViewController *)self.window.rootViewController;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self runTest:0];
    });
    
    
    return YES;
}




-(void)runTest:(int)mode
{
    if (mode>=3)
        return;
#if USE_TEST_MIGRATION_DELAY
    sleep(1);
#endif
    [self applicationDocumentsDirectory];
    [self applicationCacheDirectory];
    
    [controller infoText:[NSString stringWithFormat:@"%d",mode]];
    NSString *pathToFile = [NSHomeDirectory() stringByAppendingPathComponent:CORE_FILE_DIR];
    NSString *pathToModels = [NSHomeDirectory() stringByAppendingPathComponent:CORE_MIGR_DIR];
    storeUrl = [[NSURL fileURLWithPath:pathToFile] URLByAppendingPathComponent:CORE_FILE];
    NSLog(@"%@",storeUrl);
    modelUrl = [NSURL fileURLWithPath:pathToModels];
    NSLog(@"%@",modelUrl);
    
    [[NSFileManager defaultManager] removeItemAtPath:pathToFile error:NULL];
    [[NSFileManager defaultManager] removeItemAtPath:pathToModels error:NULL];
   
//  [self copyResurce:CORE_FILE toDir:CORE_FILE_DIR withDelete:YES];
    [self copyResurce:@"TestMigrator.sqlite" toDir:CORE_FILE_DIR update:YES];
    [self copyResurce:@"TestMigrator.sqlite-shm" toDir:CORE_FILE_DIR update:YES];
    [self copyResurce:@"TestMigrator.sqlite-wal" toDir:CORE_FILE_DIR update:YES];
    if (mode==1) {
        [self copyResurce:@"TestMigrator.momd" toDir:CORE_MIGR_DIR update:YES];
        [self copyResurce:@"Model__0_2.cdm" toDir:CORE_MIGR_DIR update:YES];
        [self copyResurce:@"Model__3_4.cdm" toDir:CORE_MIGR_DIR update:YES];
    }
    
    __typeof__(self) __weak weakSelf = self;
    void (^postAction)(BOOL) = ^(BOOL ok){
        if (ok)
        {
            NSLog(@">>>>>>> Migration_was_OK <<<<<<<<<<");
//  create Core Date stack if migration was OK to check base is right
            controller.managedObjectContext = [weakSelf managedObjectContext];
            [controller infoText:[NSString stringWithFormat:@"MIGRATION %d WAS OK",mode]];
//  run next test iteration
            [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
                [self runTest:mode+1];
            }];
            
        } else {
            NSLog(@">>>>>>> Migration_was_WRONG <<<<<<<<<<");
            [controller infoText:[NSString stringWithFormat:@"MIGRATION %d FAILED!!!!",mode]];
        }
//        [self removeStoreAtURL:storeUrl];
    };
    
    CDMigrator *migrator = [CDMigrator new];
    
    migrator.initHud = ^{[SVProgressHUD showWithStatus:@"Updating media database..." maskType:SVProgressHUDMaskTypeGradient];};
    migrator.dismissHud = ^{[SVProgressHUD dismiss];};
    migrator.progressHud = ^(float progress){[SVProgressHUD showProgress:progress status:@"Run migration..." maskType:SVProgressHUDMaskTypeGradient];};
    
    migrator.checkAfterMigration = ^BOOL(NSManagedObjectContext *context) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"NewEvent" inManagedObjectContext:context]];
        NSError *error;
        NSArray *fetchedObjects;
        @try {
            fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        }
        @catch (NSException *exception) {
            NSLog(@"EXCEPTION CHECK");
            return NO;
        }
        if (error || fetchedObjects.count==0) {
            NSLog(@"ERROR CHECK");
           return NO;
        }
        for (NSManagedObject *info in fetchedObjects) {
            NSString *str = [info valueForKey:@"sInfo"];
            NSLog(@"sInfo: (%@)", str); //"migr 0->2 + / migr 3->4" (0,1) "" (2)
            if (str.length && [str isEqualToString:@"migr 0->2 + / migr 3->4"])
                return YES;
            if (str.length && (mode == 2)) {
                if ([str hasSuffix:@"?\""])
                    return YES;
            }
        }
        return NO;
    };
    
    
    switch (mode) {
        case 0:
            migrator.modelsList = @[ @{@"name":@"TestMigrator"}, @{@"name":@"TestMigrator 2"}, @{@"name":@"TestMigrator 3"}, @{@"name":@"TestMigrator 4"}];
            migrator.migrationClass = [CDMigrationManager class];
//          migrator.modelsUrl = modelUrl;//[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ModelDataDir/"];
    
            break;
            
        case 1:
//          migrator.models = @[ @{@"name":@"TestMigrator"}, @{@"name":@"TestMigrator 2"}, @{@"name":@"TestMigrator 3"}, @{@"name":@"TestMigrator 4"},];
            migrator.migrationClass = [CDMigrationManager class];
            migrator.modelsUrl = modelUrl;
            
            break;

        case 2:
            migrator.useOnlyDirectLightMigration = YES; // try directly: version 0 -> version 4
                        
            break;
            
        default:
            return;
    }
    
    [migrator migrationFor:storeUrl
                 modelName:CORE_NAME
                completion:[postAction copy]];
        
}



//#define DOCUMENTS [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
-(NSString*)copyResurce:(NSString*)resFile toDir:(NSString*)toDir update:(BOOL)update
{
    BOOL ok = NO;
//  NSString *filePathFrom = [[NSBundle mainBundle] pathForResource:[resFile stringByDeletingPathExtension] ofType:[resFile pathExtension]];
    NSString *filePathFrom = [[NSBundle mainBundle] pathForResource:resFile ofType:nil];
    NSString *dirPathTo = [NSHomeDirectory() stringByAppendingPathComponent:toDir];
    NSString *filePathTo = [dirPathTo stringByAppendingPathComponent:resFile];
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePathTo])
    {
        [fileManager createDirectoryAtPath:dirPathTo withIntermediateDirectories:YES attributes:nil error:nil];
        ok = [fileManager copyItemAtPath:filePathFrom toPath:filePathTo error:&error];
        NSLog(@"copy is %d = /%@/ to /%@/",ok,filePathFrom,filePathTo);
    } else {
        NSLog(@"file already exists /%@/",filePathTo);
        if (update) {
            ok = [fileManager removeItemAtPath:filePathTo error:&error];
            ok = [fileManager copyItemAtPath:filePathFrom toPath:filePathTo error:&error];
            NSLog(@"copy is %d = /%@/ to /%@/",ok,filePathFrom,filePathTo);
        } else {
            ok = YES;
        }
    }
    if (ok) {
        return filePathTo;
    } else {
        return nil;
    }
}


- (void)removeStoreAtURL:(NSURL *)storeURL
{
    NSString * storePath = [storeURL path];
    NSLog(@"remove files at %@",storePath);
    
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:NULL];
    [[NSFileManager defaultManager] removeItemAtPath:[storePath stringByAppendingString:@"-shm"] error:NULL];
    [[NSFileManager defaultManager] removeItemAtPath:[storePath stringByAppendingString:@"-wal"] error:NULL];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "minsk.UnitTestMigrator" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (NSURL *)applicationCacheDirectory {
    NSURL *cachesUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
//    NSLog(@"cachesDir=%@",[cachesUrl path]);    
//    [[NSFileManager defaultManager] removeItemAtPath:[[cachesUrl path] stringByAppendingPathComponent:@"com.hackemist.SDWebImageCache.default"] error:NULL];
    return cachesUrl;
}


- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:CORE_NAME withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = storeUrl; //[[self applicationDocumentsDirectory] URLByAppendingPathComponent:CORE_FILE];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
