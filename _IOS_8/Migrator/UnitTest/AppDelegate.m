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
    
    [self performSelector:@selector(runTest) withObject:nil afterDelay:1.0];
    
    return YES;
}




-(void)runTest
{
    [controller infoText:@""];
    NSString *pathToFile = [NSHomeDirectory() stringByAppendingPathComponent:CORE_FILE_DIR];
    NSString *pathToModels = [NSHomeDirectory() stringByAppendingPathComponent:CORE_MIGR_DIR];
    storeUrl = [[NSURL fileURLWithPath:pathToFile] URLByAppendingPathComponent:CORE_FILE];
    NSLog(@"%@",storeUrl);
    modelUrl = [NSURL fileURLWithPath:pathToModels];
    NSLog(@"%@",modelUrl);
    
//  [self removeStoreAtURL:storeUrl];
    BOOL ok1 = [[NSFileManager defaultManager] removeItemAtPath:pathToFile error:NULL];
    BOOL ok2 = [[NSFileManager defaultManager] removeItemAtPath:pathToModels error:NULL];
   
    [self copyResurce:CORE_FILE toDir:CORE_FILE_DIR withDelete:YES];
    [self copyResurce:@"TestMigrator.momd" toDir:CORE_MIGR_DIR withDelete:YES];
    
    __typeof__(self) __weak weakSelf = self;
    void (^postAction)(BOOL) = ^(BOOL ok){
        if (ok)
        {
            NSLog(@">>>>>>> Migration_was_OK <<<<<<<<<<");
            controller.managedObjectContext = [weakSelf managedObjectContext]; //create Core Date stack
            [controller infoText:@"MIGRATION WAS OK"];
        } else {
            NSLog(@">>>>>>> Migration_was_WRONG <<<<<<<<<<");
            [controller infoText:@"TEST FAILED!!!"];
        }
//        [self removeStoreAtURL:storeUrl];
    };
    
    CDMigrator *migrator = [CDMigrator new];
    
    migrator.initHud = ^{[SVProgressHUD showWithStatus:@"Updating media database..." maskType:SVProgressHUDMaskTypeGradient];};
    migrator.dismissHud = ^{[SVProgressHUD dismiss];};
    migrator.progressHud = ^(float progress){[SVProgressHUD showProgress:progress status:@"Run migration..." maskType:SVProgressHUDMaskTypeClear];};
    
    migrator.models = @[ @{@"name":@"TestMigrator"}, @{@"name":@"TestMigrator 2"}, @{@"name":@"TestMigrator 3"}, @{@"name":@"TestMigrator 4"},];
    migrator.migrationClass = [CDMigrationManager class];
    migrator.modelsUrl = modelUrl;//[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ModelDataDir/"];
    
    
    migrator.checkResult = ^BOOL(NSManagedObjectContext *context) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:context]];
        NSError *error;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        if (error || fetchedObjects.count==0)
            return NO;
        for (NSManagedObject *info in fetchedObjects) {
            NSString *str = [info valueForKey:@"sInfo"];
            NSLog(@"sInfo: (%@)", str); //"migr 0->2 + / migr 3->4"
            if (str.length && [str isEqualToString:@"migr 0->2 + / migr 3->4"])
                return YES;
        }
        return NO;
    };
    
    NSLog(@"%@",storeUrl);
    [migrator migrationFor:storeUrl
                 modelName:CORE_NAME
                completion:[postAction copy]];
        
}



//#define DOCUMENTS [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
-(void)copyResurce:(NSString*)resFile toDir:(NSString*)Dir withDelete:(BOOL)delete
{
    NSString *filePathFfom = [[NSBundle mainBundle] pathForResource:[resFile stringByDeletingPathExtension] ofType:[resFile pathExtension]];
    NSString *dirPathTo = [NSHomeDirectory() stringByAppendingPathComponent:Dir];
    NSString *filePathTo = [dirPathTo stringByAppendingPathComponent:resFile];
    BOOL success;
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:filePathTo])
    {
        [fileManager createDirectoryAtPath:dirPathTo
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
        success = [fileManager copyItemAtPath:filePathFfom toPath:filePathTo error:&error];
        NSLog(@"copy is %d = /%@/ to /%@/",success,filePathFfom,filePathTo);
    } else {
        NSLog(@"EXIST /%@/",filePathTo);
        if (delete) {
            success = [fileManager removeItemAtPath:filePathTo error:&error];
            NSLog(@"remove is %d",success);
            success = [fileManager copyItemAtPath:filePathFfom toPath:filePathTo error:&error];
            NSLog(@"copy is %d = /%@/ to /%@/",success,filePathFfom,filePathTo);
        }
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
