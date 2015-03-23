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
#import "MyMigrationManager.h"


static volatile float _progressOffset = 0.f;
static volatile float _progressRange = 0.f;


@implementation MyMirgaror
    
+(instancetype) sharedMigrator
{
    static MyMirgaror *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (_sharedInstance == nil){
            _sharedInstance = [[self alloc] init];
        }
    });
    
    return _sharedInstance;
}


-(instancetype)init
{
    self = [super init];
    if (self)  {
    }
    return self;
}

-(void)dealloc
{
    NSLog(@"!!!DEALLOC MIGRATOR!!!");
}


-(BOOL)checkMigrationFor:(NSURL *)storeURL
              asyncQueue:(dispatch_queue_t)queue
               modelName:(NSString *)modelName
                  ofType:(NSString *)sourceStoreType
          lightMigration:(BOOL)lightMigration
          migrationClass:(Class)migrationClass
              completion:(void (^)(BOOL))completion

{
    __block BOOL result = NO;
    if (queue) {
        NSLog(@"run migrator in asynq queue");
        dispatch_async(queue, ^{
            result = [self checkMigrationFor:storeURL
                                    modelName:modelName
                                       ofType:sourceStoreType
                               lightMigration:lightMigration
                              migrationClass:migrationClass
                                   completion:completion];
        });
    } else {
        NSLog(@"run migrator sync");
        result = [self checkMigrationFor:storeURL
                               modelName:modelName
                                  ofType:sourceStoreType
                          lightMigration:lightMigration
                          migrationClass:migrationClass
                              completion:completion];
        
    }
    return result;
}


//BPModel BPModel 2
//Migration_BPModel_0_2

// Returns the URL for a model file with the given name in the given directory.
// @param directory The name of the bundle directory to search.  If nil,
//    searches default paths.
- (NSURL *)urlForModelName:(NSString *)modelName
               inDirectory:(NSString *)directory
{
    NSBundle * bundle = nil;
    
    if (!bundle)
        bundle = [NSBundle mainBundle];
    
    NSURL * url = [bundle URLForResource:modelName
                           withExtension:@"mom"
                            subdirectory:directory];
    if (nil == url)
    {
        // Get mom file paths from momd directories.
        NSArray * momdPaths = [bundle pathsForResourcesOfType:@"momd"
                                                  inDirectory:directory];
        for (NSString * momdPath in momdPaths)
        {
            url = [bundle URLForResource:modelName
                           withExtension:@"mom"
                            subdirectory:[momdPath lastPathComponent]];
            if (url)
                break;
        }
    }
    
    return url;
}


-(BOOL)checkCurrentModel:(NSString*)modelName compatibleWithStoreMetadata:sourceMetadata
{
    BOOL res = NO;
    
    NSURL *modelURL0 = [self urlForModelName:modelName inDirectory:nil]; //@"BPModel"
    NSLog(@"MODEL_URL for %@ = %@",modelName,modelURL0);
    NSManagedObjectModel *model =  [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL0];
    
    BOOL pscCompatible = (sourceMetadata == nil) || [model isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];
    NSLog(@"for %@ compatible is %d",modelName,pscCompatible);
    
    return res;
}


-(BOOL)checkMigrationFor:(NSURL *)storeURL
               modelName:(NSString *)modelName
                  ofType:(NSString *)sourceStoreType
          lightMigration:(BOOL)lightMigration
          migrationClass:(Class)migrationClass
              completion:(void (^)(BOOL))completion
{
    BOOL result = NO;
    NSManagedObjectModel *_managedObjectModel;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    
@try
    {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"]; //modelName @"BPModel"
        NSLog(@"MODEL_URL1=%@",modelURL);
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
        
        
//        NSSet *vers = _managedObjectModel.versionIdentifiers;
//        NSDictionary *dic = _managedObjectModel.entityVersionHashesByName;
    
        
//        NSURL *modelURL0 = [self urlForModelName:@"BPModel" inDirectory:nil];
//        NSLog(@"MODEL_URL_0=%@",modelURL0);
//        NSManagedObjectModel *mod0 =  [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL0];
//        
//        NSURL *modelURL2 = [self urlForModelName:@"BPModel 2" inDirectory:nil];
//        NSLog(@"MODEL_URL_2=%@",modelURL2);
//        NSManagedObjectModel *mod2 =  [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL2];
//        
//        _managedObjectModel = mod2;
        
        
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
        NSLog(@"Migration from storeURL=%@",storeURL);
        NSError *error = nil;
        NSDictionary *options = nil;
        
        NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:storeURL error:&error];
        NSManagedObjectModel *destinationModel = [_persistentStoreCoordinator managedObjectModel];
        BOOL pscCompatible = (sourceMetadata == nil) || [destinationModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];
        
        BOOL pscCompatible0 = [self checkCurrentModel:@"BPModel" compatibleWithStoreMetadata:sourceMetadata];
        BOOL pscCompatible2 = [self checkCurrentModel:@"BPModel 2" compatibleWithStoreMetadata:sourceMetadata];
        
        
       
        if(!pscCompatible) //Migration is needed
        {
            if (self.initHud) {
                NSLog(@"-init HUD");
               if ([NSThread isMainThread])
                {
                    self.initHud();
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.initHud();
                    });
                }
            }
            
            NSLog(@"Migration is needed"); // Migration is needed
            if (lightMigration) {
                NSLog(@"Light Migration"); // Try Light Migration
                options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
            } else {
                NSManagedObjectModel *sourceModel = [NSManagedObjectModel mergedModelFromBundles:nil forStoreMetadata:sourceMetadata];
                
                NSMappingModel *mappingModel =[NSMappingModel mappingModelFromBundles:nil forSourceModel:sourceModel destinationModel:destinationModel];
                
                if(mappingModel == nil) {
                    NSLog(@"Could not find a mapping model");
                    return result;
                }
                
                float off = 0.;
                float ran = 1.0;
                
                BOOL ok = [self migrateURL:storeURL
                            migrationClass:migrationClass //[NSMigrationManager class]
                                    ofType:sourceStoreType
                                 fromModel:sourceModel
                                   toModel:destinationModel
                              mappingModel:mappingModel
                                    offset:off
                                     range:ran
                                completion:nil];
                if (!ok) {
                    return result;
                }
                
            }
        } else {
            NSLog(@"Migration is NOT needed"); // Migration is not needed
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
            result = NO;
         } else {
            result = YES;
        }

    } //@try
    
@finally
    {
        if (self.dismissHud) {
            NSLog(@"-dismiss HUD");
            if ([NSThread isMainThread])
            {
                self.dismissHud();//[UIViewController dismissHud];
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.dismissHud();//[UIViewController dismissHud];
                });
            }
        }
        
        if (completion)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"run_completion_block with result=%d",result);
                completion(result);
            });
        }
        
        return result;
    } //@finally
    
    return result;
}


- (BOOL)migrateURL:(NSURL *)storeURL
    migrationClass:(Class)migrationClass
            ofType:(NSString *)sourceStoreType
         fromModel:(NSManagedObjectModel *)sourceModel
           toModel:(NSManagedObjectModel *)destinationModel
      mappingModel:(NSMappingModel *)mappingModel
            offset:(float)offset
             range:(float)range
        completion:(void (^)(BOOL))completion
{
    BOOL result = NO;
    
    _progressOffset = offset;
    _progressRange = range;
    
    if (!migrationClass) {
        migrationClass = [NSMigrationManager class];
    }
    if (![migrationClass isSubclassOfClass:[NSMigrationManager class]]) {
        NSLog(@"Error migration manager class");
        return result;
    }
    
    NSMigrationManager *migrationManager = [[migrationClass alloc] initWithSourceModel:sourceModel destinationModel:destinationModel];

    if (!migrationManager)
    {
        NSLog(@"Wrong migration manager");
        return result;
    }
        
    @try
    {
        
        NSError *error;
//      NSURL *newStoreURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Core_Test-Temp.sqlite"];
        
        // Build a temporary path to write the migrated store.
        NSURL * tempDestinationStoreURL = [NSURL fileURLWithPath:[[storeURL path] stringByAppendingPathExtension:@"tmp"]];
        
        NSURL * sourceStoreURL_SHM = [NSURL fileURLWithPath:[[storeURL path] stringByAppendingString:@"-shm"]];
        NSURL * sourceStoreURL_WAL = [NSURL fileURLWithPath:[[storeURL path] stringByAppendingString:@"-wal"]];
        
        [self removeStoreAtURL:tempDestinationStoreURL];
        
        NSURL *newStoreURL = tempDestinationStoreURL;
        
        NSDictionary *options =   @{
                                   NSMigratePersistentStoresAutomaticallyOption:@YES
                                   ,NSInferMappingModelAutomaticallyOption:@YES
                                   ,NSSQLitePragmasOption: @{@"journal_mode": @"DELETE"} //"DELETE" "WAL"
                                   };
//        if (self.initHud) {
//            if ([NSThread isMainThread])
//            {
//                self.initHud();
//            }
//            else{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.initHud();
//                });
//            }
//        }
        
        [migrationManager addObserver:(id)self forKeyPath:@"migrationProgress" options:0 context:NULL];
    //    sleep(1);
        
        BOOL ok = [migrationManager migrateStoreFromURL:storeURL
                                                     type:sourceStoreType
                                                  options:options
                                         withMappingModel:mappingModel
                                         toDestinationURL:newStoreURL
                                          destinationType:sourceStoreType
                                       destinationOptions:options
                                                    error:&error];
        if(!ok)
        {
            NSLog(@"Error migrating %@, %@", error, [error userInfo]);
            [migrationManager removeObserver:(id)self forKeyPath:@"migrationProgress"];
            
            [self removeStoreAtURL:tempDestinationStoreURL];
            
            return result;
        } else {
            NSLog(@"OK migrating");
        }
        
        [migrationManager removeObserver:(id)self forKeyPath:@"migrationProgress"];
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
        
        //delete *-shm and *-wal files for result base
        [[NSFileManager defaultManager] removeItemAtURL:sourceStoreURL_SHM error:NULL];
        [[NSFileManager defaultManager] removeItemAtURL:sourceStoreURL_WAL error:NULL];
    
//    sleep(1);
    
    } //@try
    
@catch (NSException *exception)
    {
        
    } //@catch
    
@finally
    {
    
//        if ([NSThread isMainThread])
//        {
//            [UIViewController dismissHud];
//        }
//        else{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [UIViewController dismissHud];
//            });
//        }
    
        if (completion)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"run_migration_complition_block with result=%d",result);
                completion(result);
            });
        }
        
        return result;
    } //@finally
    
    return result;

}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSMigrationManager * migrator = object;
    
    if (self.progressHud) {
        if ([NSThread isMainThread])
        {
            NSLog(@"IN MAIN THREAD");
            self.progressHud(_progressOffset + migrator.migrationProgress * _progressRange);
    //        [UIViewController showProgressHud:_progressOffset + migrator.migrationProgress * _progressRange text:NSLocalizedString(@"Updating media database...",)];
            while (kCFRunLoopRunHandledSource == CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.001, YES));
        }
        else{
            NSLog(@"NOT IN MAIN THREAD");
            const float off = _progressOffset;
            const float ran = _progressRange;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressHud(off + migrator.migrationProgress * ran);
    //          [UIViewController showProgressHud:off + migrator.migrationProgress * ran text:NSLocalizedString(@"Updating media database...",)];
            });
        }
    }
    
    NSLog(@"migrationProgress = %f",migrator.migrationProgress);
}


- (void)removeStoreAtURL:(NSURL *)storeURL
{
    NSString * storePath = [storeURL path];
    NSLog(@"remove files at %@",storePath);
    
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:NULL];
    [[NSFileManager defaultManager] removeItemAtPath:[storePath stringByAppendingString:@"-shm"] error:NULL];
    [[NSFileManager defaultManager] removeItemAtPath:[storePath stringByAppendingString:@"-wal"] error:NULL];
}


- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end


