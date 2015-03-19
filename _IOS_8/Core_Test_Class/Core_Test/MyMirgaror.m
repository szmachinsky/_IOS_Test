//
//  MyMirgaror.m
//  Core_Test
//
//  Created by Zmachinsky Sergei on 18.03.15.
//  Copyright (c) 2015 Zmachinsky Sergei. All rights reserved.
//

#import "MyMirgaror.h"
#import <CoreData/CoreData.h>


#import "UIViewController+Hud.h"
#import "SVProgressHUD.h"

#import "MigrationManager_4_5.h"
#import "BPMigrationManager.h"

static volatile float _progressOffset = 0.f;
static volatile float _progressRange = 0.f;



@implementation MyMirgaror
    
+(instancetype) sharedMigrator {
    static MyMirgaror *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (_sharedInstance == nil){
            _sharedInstance = [[super allocWithZone:NULL] init];
        }
    });
    
    return _sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedMigrator];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}



-(BOOL)checkMigrationFor:(NSURL *)storeURL
               modelName:(NSString *)modelName
                  ofType:(NSString *)sourceStoreType
          lightMigration:(BOOL)lightMigration
              completion:(void (^)(BOOL ok))completion
                 initHud:(void (^)())initHud
             progressHud:(void (^)(float, NSString*))progressHud
{
    BOOL result = NO;
    NSManagedObjectModel *_managedObjectModel;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    
@try
    {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"]; //modelName @"BPModel"
        NSLog(@"URL=%@",modelURL);
        if (!modelURL) {
            NSLog(@"WRONG MODEL URL");
            return result;
        }
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    //  _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
        if (!_managedObjectModel) {
            NSLog(@"WRONG MODEL");
            return result;
        }
        
        
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    //  NSURL *storeURL = sourceStoreURL;//[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Core_Test.sqlite"];
        NSLog(@"storeURL=%@",storeURL);
        NSError *error = nil;
        NSDictionary *options = nil;
        
        NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:storeURL error:&error];
        NSManagedObjectModel *destinationModel = [_persistentStoreCoordinator managedObjectModel];
        BOOL pscCompatible = (sourceMetadata == nil) || [destinationModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];
       
        if(!pscCompatible) //Migration is needed
        {
            NSLog(@"Migration is needed"); // Migration is needed
            if (lightMigration) {
                NSLog(@"Light Migration"); // Try Light Migration
                options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
            } else {
    //          NSURL *newStoreURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Core_Test-Temp.sqlite"];
                NSManagedObjectModel *sourceModel = [NSManagedObjectModel mergedModelFromBundles:nil forStoreMetadata:sourceMetadata];
                
                NSMappingModel *mappingModel =[NSMappingModel mappingModelFromBundles:nil forSourceModel:sourceModel destinationModel:destinationModel];
                
                if(mappingModel == nil) {
                    NSLog(@"Could not find a mapping model");
                    return result;
                }
                
    //          MigrationManager_4_5 *myMigrationManager = [[MigrationManager_4_5 alloc] initWithSourceModel:sourceModel destinationModel:destinationModel];
    //          NSMigrationManager *myMigrationManager = [[NSMigrationManager alloc] initWithSourceModel:sourceModel destinationModel:destinationModel];
                
    //          NSError *error;
                float off = 0.;
                float ran = 1.0;
                
                BOOL ok = [self migrateURL:storeURL
    //                      migrationManager:myMigrationManager
                            migrationClass:[MigrationManager_4_5 class] //[NSMigrationManager class]
                                    ofType:sourceStoreType
                                 fromModel:sourceModel
                                   toModel:destinationModel
                              mappingModel:mappingModel
                                    offset:off
                                     range:ran
                                   initHud:initHud
                                progressHud:progressHud];
                if (!ok) {
                    return result;
                }
                
            }
        } else {
            result = YES;
            return result;
        }
        
        id ok = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
        if (!ok) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            return result;
        }
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]])
        {
            NSLog(@"STORE FILE IS NOT EXIST!!!");
         } else {
            result = YES;
        }

    } //@try
    
@finally
    {
        if (completion)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"run_complition_block woth result=%d",result);
                completion(result);
            });
        }
        
    } //@finally
    
    
    return result;
}


- (BOOL)migrateURL:(NSURL *)storeURL
//migrationManager:(NSMigrationManager*)migrationManager
    migrationClass:(Class)migrationClass
            ofType:(NSString *)sourceStoreType
         fromModel:(NSManagedObjectModel *)sourceModel
           toModel:(NSManagedObjectModel *)destinationModel
      mappingModel:(NSMappingModel *)mappingModel
 //            error:(NSError **)err
            offset:(float)offset
             range:(float)range
           initHud:(void (^)())initHud
       progressHud:(void (^)(float, NSString*))progressHud;
{
    BOOL result = NO;
    
    _progressOffset = offset;
    _progressRange = range;
    
    
    if (!migrationClass) {
        migrationClass = [NSMigrationManager class];
    }
    if (![migrationClass isSubclassOfClass:[NSMigrationManager class]]) {
        return result;
    }
    
    NSMigrationManager *migrationManager = [[migrationClass alloc] initWithSourceModel:sourceModel destinationModel:destinationModel];

    if (!migrationManager)
    {
        return result;
    }
    
    NSError *error;
    NSURL *newStoreURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Core_Test-Temp.sqlite"];
    
    // Build a temporary path to write the migrated store.
    NSURL * tempDestinationStoreURL = [NSURL fileURLWithPath:[[storeURL path] stringByAppendingPathExtension:@"tmp"]];
    
    NSURL * sourceStoreURL_SHM = [NSURL fileURLWithPath:[[storeURL path] stringByAppendingString:@"-shm"]];
    NSURL * sourceStoreURL_WAL = [NSURL fileURLWithPath:[[storeURL path] stringByAppendingString:@"-wal"]];
    
    [self removeStoreAtURL:tempDestinationStoreURL];
    
    newStoreURL = tempDestinationStoreURL;
    
    NSDictionary *options =   @{
                               NSMigratePersistentStoresAutomaticallyOption:@YES
                               ,NSInferMappingModelAutomaticallyOption:@YES
                               ,NSSQLitePragmasOption: @{@"journal_mode": @"DELETE"} //"DELETE" "WAL"
                               };
    if (initHud) {
        if ([NSThread isMainThread])
        {
            initHud();
            //while (kCFRunLoopRunHandledSource == CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.001, YES)) ;
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                initHud();
            });
        }
    }
//    self.progress_Hud = progressHud;
//    self->progressHud = progressHud;
    [migrationManager addObserver:(id)self forKeyPath:@"migrationProgress" options:0 context:@"context"];
    sleep(2);
    
    
    BOOL ok = [migrationManager migrateStoreFromURL:storeURL
                                                 type:sourceStoreType
                                              options:nil
                                     withMappingModel:mappingModel
                                     toDestinationURL:newStoreURL
                                      destinationType:sourceStoreType
                                   destinationOptions:options
                                                error:&error];
    if(!ok)
    {
        NSLog(@"Error migrating %@, %@", error, [error userInfo]);
        [migrationManager removeObserver:(id)self forKeyPath:@"migrationProgress"];
        
        if ([NSThread isMainThread])
        {
            [UIViewController dismissHud];
            //while (kCFRunLoopRunHandledSource == CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.001, YES));
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIViewController dismissHud];
            });
        }
        
        [self removeStoreAtURL:tempDestinationStoreURL];
        
        return result;
    } else {
        NSLog(@"OK migrating");
        [migrationManager removeObserver:(id)self forKeyPath:@"migrationProgress"];
        
        if ([NSThread isMainThread])
        {
            [UIViewController dismissHud];
            //while (kCFRunLoopRunHandledSource == CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.001, YES));
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIViewController dismissHud];
            });
        }
        
    }
    
    result = ok;
    
    NSURL *sourceStoreURL = storeURL;
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    // Move the original source store to a backup location.
    NSString * backupPath = [[sourceStoreURL path] stringByAppendingPathExtension:@"bak"];
    
    if (![fileManager moveItemAtPath:[sourceStoreURL path]
                              toPath:backupPath
                               error:&error])
    {
        [self removeStoreAtURL:tempDestinationStoreURL];
        // If the move fails, delete the migrated destination store.
        [fileManager moveItemAtPath:[tempDestinationStoreURL path]
                             toPath:[sourceStoreURL path]
                              error:NULL];
        return NO;
    }
    
    
    // Move the destination store to the original source location.
    if ([fileManager moveItemAtPath:[tempDestinationStoreURL path]
                             toPath:[sourceStoreURL path]
                              error:&error])
    {
        // If the move succeeds, delete the backup of the original store.
        [fileManager removeItemAtPath:backupPath error:NULL];
    }
    else
    {
        // If the move fails, restore the original store to its original location.
        [fileManager moveItemAtPath:backupPath
                             toPath:[sourceStoreURL path]
                              error:NULL];
        return NO;
    }
    
 
    [[NSFileManager defaultManager] removeItemAtURL:sourceStoreURL_SHM error:NULL];
    [[NSFileManager defaultManager] removeItemAtURL:sourceStoreURL_WAL error:NULL];
    
    return result;
}


+ (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSMigrationManager * migrator = object;
    void (^progressHud)(float, NSString*);
    if (context) {
        progressHud = (__bridge void (^)(float, NSString *))(context);
    }
    
    if (progressHud) {
        if ([NSThread isMainThread])
        {
            progressHud(_progressOffset + migrator.migrationProgress * _progressRange, NSLocalizedString(@"Updating media database...",));
    //        [UIViewController showProgressHud:_progressOffset + migrator.migrationProgress * _progressRange text:NSLocalizedString(@"Updating media database...",)];
            while (kCFRunLoopRunHandledSource == CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.001, YES));
        }
        else{
            NSLog(@"NOT MAIN THREAD");
            const float off = _progressOffset;
            const float ran = _progressRange;
            dispatch_async(dispatch_get_main_queue(), ^{
                progressHud(off + migrator.migrationProgress * ran, NSLocalizedString(@"Updating media database...",));
    //          [UIViewController showProgressHud:off + migrator.migrationProgress * ran text:NSLocalizedString(@"Updating media database...",)];
            });
        }
    }
    
    NSLog(@"migrationProgress = %f",migrator.migrationProgress);
}


+ (void)removeStoreAtURL:(NSURL *)storeURL
{
    NSString * storePath = [storeURL path];
    NSLog(@"remove files at %@",storePath);
    
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:NULL];
    [[NSFileManager defaultManager] removeItemAtPath:[storePath stringByAppendingString:@"-shm"] error:NULL];
    [[NSFileManager defaultManager] removeItemAtPath:[storePath stringByAppendingString:@"-wal"] error:NULL];
}




+ (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end


