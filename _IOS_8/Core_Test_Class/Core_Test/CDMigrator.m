//
//  MyMirgaror.m
//  Core_Test
//
//  Created by Zmachinsky Sergei on 18.03.15.
//  Copyright (c) 2015 Zmachinsky Sergei. All rights reserved.
//

#import "CDMigrator.h"
#import <CoreData/CoreData.h>


//#import "UIViewController+Hud.h"
//#import "SVProgressHUD.h"

//#import "MigrationManager_4_5.h"
//#import "BPMigrationManager.h"
//#import "MyMigrationManager.h"


#if !DEBUG
# define NSLog(...)     ((void)0)
#endif

#define kCoreDataStoreType  NSSQLiteStoreType


static volatile float _progressOffset = 0.f;
static volatile float _progressRange = 0.f;



@interface CDMigrator ()
@property (nonatomic, strong) NSBundle *dataBundle;
@end


@implementation CDMigrator
    
+(instancetype) sharedMigrator
{
    static CDMigrator *_sharedInstance = nil;
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
        _useOnlyLightMigration = NO;
    }
    return self;
}

-(void)dealloc
{
    NSLog(@"!!!DEALLOC MIGRATOR!!!");
}


#pragma migration Chain

-(NSArray*)migrationChainFor:(NSArray*)models metadata:(NSDictionary*)sourceMetadata
{
    NSMutableArray *arr = [NSMutableArray array];
    NSManagedObjectModel *destModel;
    NSString *destName;
    NSMutableDictionary *dict;
    for (int i = models.count-1; i >= 0;  i--) {
        NSDictionary *dic = [models objectAtIndex:i];
        NSString *modelName = dic[@"name"];
                
        NSURL *modelURL = [self urlForModelName:modelName inDirectory:nil]; //@"BPModel"
        if(!modelURL) {
            NSLog(@"for (%@) modelURL not found!!!",modelName);
            return NO;
        }
        NSLog(@"MODEL_URL for %@ = %@",modelName,modelURL);
        NSManagedObjectModel *model =  [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        if(!model) {
            NSLog(@"for (%@) model not found!!!",modelName);
            return NO;
        }
        BOOL compatible = [model isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];
        NSLog(@"for model (%@) compatible=%d",modelName,compatible);
        if (destModel && destName) {
            dict = [NSMutableDictionary dictionary];
            dict[@"sourceName"] = modelName;
            dict[@"sourceModel"] = model;
            dict[@"destName"] = destName;
            dict[@"destModel"] = destModel;
            [arr insertObject:dict atIndex:0];
        }
        if (compatible ) {
            return arr;
        }
        destName = modelName;
        destModel = model;
    }
    
    return nil;
}


#pragma mark - Migrations

-(void)migrationFor:(NSURL *)storeURL
               modelName:(NSString *)modelName
              completion:(void (^)(BOOL))completion

{
    __block BOOL result = NO;
    
    if (!self.asyncQueue)
        self.asyncQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0); //dispatch_get_main_queue()
    
    NSLog(@"run migrator in asynq queue");
    dispatch_async(self.asyncQueue, ^{
        result = [self checkMigrationFor:storeURL
                               modelName:modelName
                              completion:completion];
    });
    
    return;
}


-(BOOL)checkMigrationFor:(NSURL *)storeURL
               modelName:(NSString *)modelName
              completion:(void (^)(BOOL))completion
{
    BOOL result = NO;
    NSManagedObjectModel *_managedObjectModel;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    
    if (self.modelsUrl) {
        self.dataBundle = [NSBundle bundleWithURL:self.modelsUrl];
        NSLog(@"MODEL_BUNDLE=%@",self.dataBundle);
    }
    
    if (!self.dataBundle) {
        self.dataBundle = [NSBundle mainBundle];
    }
    
@try
    {
        NSURL *modelURL = [self.dataBundle URLForResource:modelName withExtension:@"momd"]; //modelName @"BPModel"
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
        
        NSURL *url = [self.dataBundle URLForResource:@"VersionInfo"
                       withExtension:@"plist"
                        subdirectory:[modelName stringByAppendingPathExtension:@"momd"]];  
        NSLog(@"%@",url);
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfURL:url];
        NSLog(@"DIC=%@",dic);
        NSString *nameOfDestinationModel = dic[@"NSManagedObjectModel_CurrentVersionName"];
        NSLog(@"dest_model_name=(%@)",nameOfDestinationModel);
        NSDictionary *d = dic[@"NSManagedObjectModel_VersionHashes"];
        NSMutableArray *arrModels = [NSMutableArray array];
        NSArray *a = [d allKeys];
        if (a)
            [arrModels addObjectsFromArray:a];
        
        NSLog(@"arrModels1=%@",arrModels);
        [arrModels sortUsingComparator:^(id a, id b) {
            NSString *str1 = (NSString*)a;
            NSString *str2 = (NSString*)b;
            return [str1 compare:str2];
            //      if ( x1 < x2 )
            //          return (NSComparisonResult)NSOrderedAscending;
            //      if ( x1 > x2 )
            //          return (NSComparisonResult)NSOrderedDescending;
            //      return (NSComparisonResult)NSOrderedSame;
        }];
        NSLog(@"arrModels2=%@",arrModels);

        
       
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
        NSLog(@"Migration from storeURL=%@",storeURL);
        NSError *error = nil;
        NSDictionary *options = nil;
        
        NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:kCoreDataStoreType URL:storeURL error:&error];
        NSManagedObjectModel *destinationModel = [_persistentStoreCoordinator managedObjectModel];
        BOOL pscCompatible = (sourceMetadata == nil) || [destinationModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];
        
        if(!pscCompatible) //Migration is needed
        {
            NSLog(@"Migration is needed"); // Migration is needed
            
            if (self.initHud) {
                NSLog(@"-init HUD");
               if ([NSThread isMainThread])
                {
                    self.initHud();
                    while (kCFRunLoopRunHandledSource == CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.001, YES));
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.initHud();
                    });
                }
            }
            
            if (self.useOnlyLightMigration)
            {
                NSLog(@"Light Migration"); // Try to perform Light Migration
                options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
            } else
            {
                
                NSManagedObjectModel *sourceModel;
                NSMappingModel *mappingModel;
                NSArray *arraySteps;
                float off = 0.;
                float ran = 1.0;
                BOOL ok = YES;
                
                sourceModel = [NSManagedObjectModel mergedModelFromBundles:nil forStoreMetadata:sourceMetadata];
                mappingModel = nil;//[NSMappingModel mappingModelFromBundles:nil forSourceModel:sourceModel destinationModel:destinationModel];
                if (mappingModel) {
                    NSLog(@"run direct migration");
                    ok = [self migrateURL:storeURL
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
                
                
                if (!mappingModel)
                {
                    //build  array with migration chain steps descriptios
                    arraySteps = [self migrationChainFor:self.models metadata:sourceMetadata];
                    NSLog(@"found %d migration chain steps",arraySteps.count);
                    float delta = (arraySteps.count > 0 ? 1./arraySteps.count : 1.) - 0.00001;
                    off = 0.;
                    ran = delta;
                    for (int i = 0; i < arraySteps.count; i++)
                    @autoreleasepool
                    {
                        NSLog(@"======================= iteraion %d ========================",(i+1));
                        NSDictionary *dic = (NSDictionary*)arraySteps[i];
                        NSManagedObjectModel *sModel = dic[@"sourceModel"];
                        NSManagedObjectModel *dModel = dic[@"destModel"];
                        NSMappingModel *mapModel = [NSMappingModel mappingModelFromBundles:nil forSourceModel:sModel destinationModel:dModel];
                        NSLog(@"%@ -> %@",dic[@"sourceName"],dic[@"destName"]);
                        if (mapModel) {
                            NSLog(@"  there is mapping model!");
                            sourceModel = sModel;
                            destinationModel = dModel;
                            mappingModel = mapModel;
                        } else {
                            NSLog(@"Could not find a mapping model");
//                          return result;
                            NSLog(@"Try light migration");
                            options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
                            break;
                        }
                        
                        ok = [self migrateURL:storeURL
                                    fromModel:sourceModel
                                      toModel:destinationModel
                                 mappingModel:mappingModel
                                       offset:off
                                        range:ran
                                   completion:nil];
                    
                        if (!ok) {
                            return result;
                        }
                
                        if ([nameOfDestinationModel isEqual:dic[@"destName"]]) {
                            NSLog(@"-----exit by nameOfDestinationModel=%@-----",nameOfDestinationModel);
                            break;
                        }
                        off +=delta;
                        
                    }//for - autorelease
                }//if
                
            } //custom migration
            
        } else {
            NSLog(@"Migration is NOT needed"); // Migration is not needed
            result = YES;
            return result;
        }
        
        id ok = [_persistentStoreCoordinator addPersistentStoreWithType:kCoreDataStoreType configuration:nil URL:storeURL options:options error:&error];
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
                self.dismissHud();
                while (kCFRunLoopRunHandledSource == CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.001, YES));
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.dismissHud();
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
//    migrationClass:(Class)migrationClass
//            ofType:(NSString *)sourceStoreType
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
    
    if (!self.migrationClass) {
        self.migrationClass = [NSMigrationManager class];
    }
    if (![self.migrationClass isSubclassOfClass:[NSMigrationManager class]]) {
        NSLog(@"Error migration manager class");
        return result;
    }
    
    NSMigrationManager *migrationManager = [[self.migrationClass alloc] initWithSourceModel:sourceModel destinationModel:destinationModel];

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
        
        [migrationManager addObserver:(id)self forKeyPath:@"migrationProgress" options:0 context:NULL];
        
        // run migration
        BOOL ok = [migrationManager migrateStoreFromURL:storeURL
                                                     type:kCoreDataStoreType
                                                  options:options
                                         withMappingModel:mappingModel
                                         toDestinationURL:newStoreURL
                                          destinationType:kCoreDataStoreType
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
        NSLog(@"!!! MIGRATION EXCEPTION !!!");
        
    } //@catch
    
@finally
    {
    
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



#pragma mark - progress Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSMigrationManager * migrator = object;
    float progress = migrator.migrationProgress;
    NSLog(@"migrationProgress = %f",progress);
    
    if (self.progressHud) {
        if ([NSThread isMainThread])
        {
            NSLog(@"IN MAIN THREAD");
            self.progressHud(_progressOffset + progress * _progressRange);
            while (kCFRunLoopRunHandledSource == CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.001, YES));
        }
        else{
            NSLog(@"NOT IN MAIN THREAD");
            const float off = _progressOffset;
            const float ran = _progressRange;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressHud(off + progress * ran);
            });
        }
    }
    
}



#pragma mark - File System's Service

- (NSURL *)urlForModelName:(NSString *)modelName
               inDirectory:(NSString *)directory
{
    NSBundle * bundle = self.dataBundle;
    
//    if (!bundle)
//        bundle = [NSBundle mainBundle];
//    NSLog(@"bundle=%@",bundle);
    
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
            if (url) {
//                NSLog(@"url_found=%@",url);
                break;
            }
        }
    }
    
    return url;
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


//NSTemporaryDirectory()

@end


