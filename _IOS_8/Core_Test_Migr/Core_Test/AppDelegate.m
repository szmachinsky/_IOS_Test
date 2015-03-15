//
//  AppDelegate.m
//  Core_Test
//
//  Created by Zmachinsky Sergei on 05.03.15.
//  Copyright (c) 2015 Zmachinsky Sergei. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"

#import "MigrationManager_4_5.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    MasterViewController *controller = (MasterViewController *)navigationController.topViewController;
    controller.managedObjectContext = self.managedObjectContext;
    return YES;
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
    // The directory the application uses to store the Core Data store file. This code uses a directory named "minsk.Core_Test" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Core_Test" withExtension:@"momd"];
//  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:CORE_NAME withExtension:@"momd"]; //@"Core_Test"
    NSLog(@"URL=%@",modelURL);
    
    if (!modelURL) {
        NSLog(@"WRONG URL");
        abort();
    }
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//  _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
//    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil forStoreMetadata:nil];
    if (!_managedObjectModel) {
        NSLog(@"WRONG MODEL");
        abort();
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Core_Test.sqlite"];
    NSLog(@"storeURL=%@",storeURL);
    NSError *error = nil;
    NSDictionary *options = nil;
    
    
    NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:storeURL error:&error];
    NSManagedObjectModel *destinationModel = [_persistentStoreCoordinator managedObjectModel];
//    NSManagedObjectModel *destinationModel = [self managedObjectModel];
    BOOL pscCompatible = (sourceMetadata == nil) || [destinationModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];
    
#if _CORE_VERSION == 4
    if(!pscCompatible) // Migration is needed
    {
#if _CORE_VERSION <= 3
        options = @{NSInferMappingModelAutomaticallyOption: @YES, NSMigratePersistentStoresAutomaticallyOption: @YES};
//      NSDictionary *options = @{
//                               NSMigratePersistentStoresAutomaticallyOption:@YES
//                               ,NSInferMappingModelAutomaticallyOption:@YES
//                               ,NSSQLitePragmasOption: @{@"journal_mode": @"WAL"} //"DELETE"
//                               };
        
#endif
        
        
#if _CORE_VERSION == 4
//        options = @{NSInferMappingModelAutomaticallyOption: @YES, NSMigratePersistentStoresAutomaticallyOption: @YES};
        options = @{NSMigratePersistentStoresAutomaticallyOption: @YES}; //with Migration policy
#endif
     }
#endif
    

#if _CORE_VERSION == 5
    if(!pscCompatible) // Custom Migration is needed
    {
        NSURL *newStoreURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Core_Test-Temp.sqlite"];
        
        NSLog(@"Migration is needed"); // Migration is needed
        
        NSManagedObjectModel *sourceModel = [NSManagedObjectModel mergedModelFromBundles:nil forStoreMetadata:sourceMetadata];
        
//        NSURL *modelURL1 = [[NSBundle mainBundle]
//                            URLForResource:@"Core_Test 4"
//                            withExtension:@"mom"  subdirectory:@"Core_Test.momd"];
//        sourceModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL1];
//        
//        NSURL *modelURL2 = [[NSBundle mainBundle]
//                            URLForResource:@"Core_Test 5"
//                            withExtension:@"mom"  subdirectory:@"Core_Test.momd"];
//        destinationModel:destinationModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL2];
       
        
        NSMappingModel *mappingModel1 = [NSMappingModel inferredMappingModelForSourceModel:sourceModel destinationModel:destinationModel error:&error];
        
//        NSMappingModel *mappingModel11 = [NSMappingModel ModelFromBundles:nil SourceModel:sourceModel Model:destinationModel];
        NSMappingModel *mappingModel11 = [NSMappingModel mappingModelFromBundles:nil forSourceModel:sourceModel destinationModel:destinationModel];
        
        
        if(mappingModel1 == nil) {
            NSLog(@"Could not find a mapping model");
            abort();
        }
        
        NSURL *migrationModelUrl = [[NSBundle mainBundle] URLForResource:@"Model_3_5" withExtension:@"cdm"];
        NSMappingModel *mappingModel2 = [[NSMappingModel alloc] initWithContentsOfURL:migrationModelUrl];
        
        MigrationManager_4_5 *myMigrationManager = [[MigrationManager_4_5 alloc] initWithSourceModel:sourceModel destinationModel:destinationModel];
        
//        NSMigrationManager *migrationManager = [[NSMigrationManager alloc] initWithSourceModel:sourceModel destinationModel:destinationModel];
        
        
        BOOL ok = [myMigrationManager migrateStoreFromURL:storeURL
                                                   type:NSSQLiteStoreType
                                                options:nil
                                       withMappingModel:mappingModel1
                                       toDestinationURL:newStoreURL
                                        destinationType:NSSQLiteStoreType
                                     destinationOptions:nil
                                                  error:&error];
        if(!ok)
        {
            // Deal with error
            NSLog(@"Error migrating %@, %@", error, [error userInfo]);
            abort();
        }
        // Replace the old store with the new one now that it's migrated
        NSFileManager *fm = [NSFileManager defaultManager];
        NSURL *backupURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Core_Test-old.sqlite"];
        if(![fm moveItemAtURL:storeURL toURL:backupURL error:&error])
        {
            NSLog(@"Error backing up the store");
            abort();
        }
        else if(![fm moveItemAtURL:newStoreURL toURL:storeURL error:&error])
        {
            NSLog(@"Error putting the new store in place");
            abort();
        }
        else if(![fm removeItemAtURL:backupURL error:&error])
                {
                    NSLog(@"Error getting rid of the old store");
                }
    }
#endif

    

//  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:destinationModel]; //for 5

    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:destinationModel]; //for 5

     NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    id ok = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
    if (!ok) {
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
