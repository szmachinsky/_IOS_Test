//
//  CDMirgaror.m
//
//  vers.1.01
//
//  Created by Zmachinsky Sergei on 18.03.15.
//  Copyright (c) 2015 Zmachinsky Sergei. All rights reserved.
//

#import "CDMigrator.h"
#import <CoreData/CoreData.h>


#if DEBUG && 1
#define  _NSLog(...)  NSLog(__VA_ARGS__)
#else
#define  _NSLog(...)  ((void)0)
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
        _useOnlyDirectLightMigration = NO;
    }
    return self;
}

-(void)dealloc
{
    _NSLog(@"!!!DEALLOC MIGRATOR!!!");
}



#pragma mark - Migrations

-(void)migrationFor:(NSURL *)storeURL
               modelName:(NSString *)modelName
              completion:(void (^)(BOOL))completion

{
    __block BOOL result = NO;
    
    if (!self.asyncQueue)
        self.asyncQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0); //dispatch_get_main_queue()
    
    _NSLog(@"\n\n   Run migrator in asynq queue");
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
    __block BOOL result = NO;
    
    NSManagedObjectModel *_managedObjectModel;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;

    NSArray *bundles = nil;
    
    if (self.modelsUrl && [[NSFileManager defaultManager] fileExistsAtPath:[self.modelsUrl path]])
    {
        self.dataBundle = [NSBundle bundleWithURL:self.modelsUrl];
        _NSLog(@"MODEL_BUNDLE=%@",self.dataBundle);
        bundles = @[self.dataBundle];
    }
    
    if (!self.dataBundle) {
        self.dataBundle = [NSBundle mainBundle];
        bundles = @[self.dataBundle];
    }
    
@try
    {
        _NSLog(@"storeURL=%@",storeURL);
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]])
        {
            _NSLog(@"base file is not exist - migration is not needed");
            result = YES;
            return result;
        }
        
        NSURL *modelURL = [self.dataBundle URLForResource:modelName withExtension:@"momd"];
        _NSLog(@"MODEL_URL=%@",modelURL);
        if (!modelURL) {
            _NSLog(@"WRONG MODEL URL");
            return result;
        }
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    //  _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
        if (!_managedObjectModel) {
            _NSLog(@"WRONG MODEL");
            return result;
        }
        
        NSURL *url = [self.dataBundle URLForResource:@"VersionInfo"
                       withExtension:@"plist"
                        subdirectory:[modelName stringByAppendingPathExtension:@"momd"]];  
        _NSLog(@"%@",url);
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfURL:url];
        _NSLog(@"Momd_Dic=%@",dic);
        NSString *nameOfDestinationModel = dic[@"NSManagedObjectModel_CurrentVersionName"];
        _NSLog(@"dest_model_name=(%@)",nameOfDestinationModel);
        NSDictionary *d = dic[@"NSManagedObjectModel_VersionHashes"];
        NSMutableArray *arrModels = [NSMutableArray array];
        NSArray *a = [d allKeys];
        if (a) {
            [arrModels addObjectsFromArray:a];
        }
        
        _NSLog(@"models list (from mom) = %@",arrModels);
        [arrModels sortUsingComparator:^(id a, id b) {
            NSInteger x1 = [self lastNumberFromString:(NSString*)a];
            NSInteger x2 = [self lastNumberFromString:(NSString*)b];
//          _NSLog(@"(%@)(%@) %d %d",a,b,x1,x2);
            if ( x1 < x2 )
                return (NSComparisonResult)NSOrderedAscending;
            if ( x1 > x2 )
                return (NSComparisonResult)NSOrderedDescending;
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        if (!self.modelsList && arrModels.count) {
            NSMutableArray *res = [NSMutableArray array];
            for (NSString *str in arrModels) {
                [res addObject:@{@"name":str}];
                if ([nameOfDestinationModel isEqual:str]) {
                    break;
                }
           }
            _NSLog(@"set list of models (sorted) from = %@",arrModels);
            self.modelsList = res; //fill list of models
//          _NSLog(@"%@",self.models);
        }
        
       
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
        NSError *error = nil;
        NSDictionary *options = nil;
        
        NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:kCoreDataStoreType URL:storeURL error:&error];
        NSManagedObjectModel *destinationModel = [_persistentStoreCoordinator managedObjectModel];
        BOOL pscCompatible = (sourceMetadata == nil) || [destinationModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];
        
//===
//        NSManagedObjectModel *sourceModel = [NSManagedObjectModel
//                                             mergedModelFromBundles:nil
//                                             forStoreMetadata:sourceMetadata];
//        NSAssert(sourceModel != nil, ([NSString stringWithFormat:
//                                       @"Failed to find source model\n%@",
//                                       sourceMetadata]));
//===
        
        if(!pscCompatible)
        {
            _NSLog(@"Migration is needed");
            
            [self showHud];
            
            if (self.useOnlyDirectLightMigration)
            {
                _NSLog(@"Try Only Light Migration"); // Try to perform Light Migration
                options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
            } else
            {
                
                NSManagedObjectModel *sourceModel;
                NSMappingModel *mappingModel;
                NSArray *arraySteps;
                float off = 0.;
                float ran = 1.0;
                BOOL ok = YES;
                
                sourceModel = [NSManagedObjectModel mergedModelFromBundles:bundles forStoreMetadata:sourceMetadata];
                NSAssert(sourceModel != nil, ([NSString stringWithFormat:
                                               @"Failed to find source model\n%@",
                                               sourceMetadata]));
                
                mappingModel = [NSMappingModel mappingModelFromBundles:bundles forSourceModel:sourceModel destinationModel:destinationModel];
                if (mappingModel) {
                    _NSLog(@"====== there is a direct migration model ======");
                    arraySteps = @[ @{@"sourceModel":sourceModel, @"destModel":destinationModel, @"mapModel":mappingModel, @"sourceName":@"?", @"destName":@"?" } ];
                }
                NSManagedObjectModel *finalModel = destinationModel;
                
                //build  array with migration chain steps descriptios
                if (arraySteps.count == 0) {
                    arraySteps = [self migrationChainFor:self.modelsList metadata:sourceMetadata];
                }
                _NSLog(@"found %d migration(s) in chain",arraySteps.count);
                if (arraySteps.count == 0) {
                    _NSLog(@"Current model is not found - exit!!!");
                    return result;
                }
                float delta = (arraySteps.count > 0 ? 1./arraySteps.count : 1.) - 0.00001;
                off = 0.;
                ran = delta;
                for (int i = 0; i < arraySteps.count; i++)
                @autoreleasepool
                {
                    int iterationNumber = (i+1);
                    _NSLog(@"======================= run iteration %d ========================",iterationNumber);
                    NSDictionary *dic = (NSDictionary*)arraySteps[i];
                    NSManagedObjectModel *sModel = dic[@"sourceModel"];
                    NSManagedObjectModel *dModel = dic[@"destModel"];
                    BOOL toBreak = NO;
                    
                    
                    NSMappingModel *mapModel;
                    if (dic[@"mapModel"] == [NSNull null])
                    {
                        mapModel = [NSMappingModel mappingModelFromBundles:bundles forSourceModel:sModel destinationModel:dModel];
                    } else {
                        mapModel = dic[@"mapModel"];
                    }
                    _NSLog(@"%@ -> %@",dic[@"sourceName"],dic[@"destName"]);
                                        
                    if (arraySteps.count > iterationNumber) {
                        mappingModel = [NSMappingModel mappingModelFromBundles:bundles forSourceModel:sModel destinationModel:finalModel];
                        if (mappingModel) {
                            _NSLog(@"= direct migration possible!!! =");
                            dModel = finalModel;
                            mapModel = mappingModel;
                            toBreak = YES;
                        }
                     }
                    
                    if (mapModel) {
                        _NSLog(@"  there is mapping model");
                        sourceModel = sModel;
                        destinationModel = dModel;
                        mappingModel = mapModel;
                        
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
                        
                    } else {
                        _NSLog(@"there is NOT mapping model!");
                        _NSLog(@"========= Try light migration =========");
                        ok = [self runLightMigration:storeURL
                                             toModel:dModel
                                              offset:off
                                               range:1.0
                                               delta:delta];
                        if (!ok) {
                            return result;
                        } else {
                            _NSLog(@"========= light migration OK! =========");
                        }
                    }
                    
#ifdef USE_TEST_MIGRATION_DELAY
                    sleep(1);
#endif
                    
                    if ([nameOfDestinationModel isEqual:dic[@"destName"]]) {
                        _NSLog(@"-----exit by nameOfDestinationModel=%@-----",nameOfDestinationModel);
                        toBreak = YES;
                    }
                    
                    if (toBreak) {
                        break;
                    }
                    
                    off +=delta;
                    
                }//for - autorelease
                
            } //custom migration
            
        } else {
            _NSLog(@"Migration is NOT needed"); // Migration is not needed
            result = YES;
            return result;  //exit
        }
        
        id ok = [_persistentStoreCoordinator addPersistentStoreWithType:kCoreDataStoreType configuration:nil URL:storeURL options:options error:&error];
        if (!ok) {
            _NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            return result;
        }
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]])
        {
            _NSLog(@"STORE FILE IS NOT EXIST!!!");
            result = NO;
         } else {
            result = YES;
        }
        
        if (self.checkAfterMigration) {
            NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];//NSPrivateQueueConcurrencyType];
            [context setPersistentStoreCoordinator:_persistentStoreCoordinator];
            if (!context) {
                _NSLog(@"Can't create context!");
                return result;
            } else {
                result = NO;
                result = self.checkAfterMigration(context);
                _NSLog(@"checkResult=%d",result);
            }
        } 
        

    } //@try
    
@finally
    {
        [self hideHud];
        
        if (completion)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                _NSLog(@"run_completion_block with result=%d",result);
                completion(result);
            });
        }
        
        return result;
    } //@finally
    
    return result;
}


-(BOOL)runLightMigration:(NSURL *)storeURL
                 toModel:(NSManagedObjectModel *)destinationModel
                  offset:(float)offset
                   range:(float)range
                   delta:(float)delta
{
    _progressOffset = offset;
    _progressRange = range;

    [self showProgress:delta*0.1];
    NSError *error = nil;
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:destinationModel];
    
    NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:kCoreDataStoreType URL:storeURL error:&error];
    BOOL pscCompatible = (sourceMetadata == nil) || [destinationModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];
    
    if(!pscCompatible) //Migration is needed
    {
        _NSLog(@"Migration is needed  %.3f %.3f %.3f",offset,range,delta); // Migration is needed
    }
    [self showProgress:delta*0.3];

    id ok = [persistentStoreCoordinator addPersistentStoreWithType:kCoreDataStoreType configuration:nil URL:storeURL options:options error:&error];
    if (!ok) {
        _NSLog(@"Unresolved Light Migration error %@, %@", error, [error userInfo]);
        return NO;
    }
    [self showProgress:delta];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]])
    {
        _NSLog(@"LITE MIGRATION FAILS - STORE FILE IS NOT EXIST!!!");
        return NO;
    } else {
        return YES;
    }
}


- (BOOL)migrateURL:(NSURL *)storeURL
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
    
    if (!mappingModel) {
        return result;
    }
    
    if (!self.migrationClass) {
        self.migrationClass = [NSMigrationManager class];
    }
    if (![self.migrationClass isSubclassOfClass:[NSMigrationManager class]]) {
        _NSLog(@"Error migration manager class");
        return result;
    }
    
    NSMigrationManager *migrationManager = [[self.migrationClass alloc] initWithSourceModel:sourceModel destinationModel:destinationModel];

    if (!migrationManager)
    {
        _NSLog(@"Wrong migration manager");
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
//                                  NSMigratePersistentStoresAutomaticallyOption:@YES,
//                                  NSInferMappingModelAutomaticallyOption:@YES,
                                    NSSQLitePragmasOption: @{@"journal_mode": @"DELETE"} //"DELETE" "WAL"
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
            _NSLog(@"Error migrating %@, %@", error, [error userInfo]);
            [migrationManager removeObserver:(id)self forKeyPath:@"migrationProgress"];
            
            [self removeStoreAtURL:tempDestinationStoreURL];
            
            return result;
        } else {
            _NSLog(@"OK migrating");
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
        
    } //@try
    
@catch (NSException *exception)
    {
        _NSLog(@"!!! GOT MIGRATION EXCEPTION !!!");
    } //@catch
    
@finally
    {
    
        if (completion)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                _NSLog(@"run_migration_complition_block with result=%d",result);
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
//    _NSLog(@"migrationProgress = %f",progress);
    
    [self showProgress:progress];
}

#pragma mark - progress showing

-(void)showProgress:(float)progress
{
    if (self.progressHud) {
        if ([NSThread isMainThread])
        {
            float progr = _progressOffset + progress * _progressRange;
//            _NSLog(@"IN MAIN THREAD:%.3f",progr);
            self.progressHud(progr);
            while (kCFRunLoopRunHandledSource == CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.001, YES));
        }
        else{
            const float off = _progressOffset;
            const float ran = _progressRange;
            float progr = off + progress * ran;
//            _NSLog(@"NOT IN MAIN THREAD:%.3f",progr);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressHud(progr);
            });
        }
    }
}


-(void)showHud
{
    if (self.initHud) {
        _NSLog(@"-init HUD");
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
}


-(void)hideHud
{
    if (self.dismissHud) {
        _NSLog(@"-dismiss HUD");
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
}


#pragma mark - Migration Chain

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
            _NSLog(@"for (%@) modelURL not found!!!",modelName);
            return NO;
        }
        _NSLog(@"MODEL_URL for %@ = %@",modelName,modelURL);
        NSManagedObjectModel *model =  [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        if(!model) {
            _NSLog(@"for (%@) model not found!!!",modelName);
            return NO;
        }
        BOOL compatible = [model isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];
        _NSLog(@"for model (%@) compatible=%d",modelName,compatible);
        if (destModel && destName) {
            dict = [NSMutableDictionary dictionary];
            dict[@"sourceName"] = modelName;
            dict[@"sourceModel"] = model;
            dict[@"destName"] = destName;
            dict[@"destModel"] = destModel;
            dict[@"mapModel"] = [NSNull null];
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


#pragma mark - File System's Service

- (NSURL *)urlForModelName:(NSString *)modelName
               inDirectory:(NSString *)directory
{
    NSBundle * bundle = self.dataBundle;
    
//    if (!bundle)
//        bundle = [NSBundle mainBundle];
//    _NSLog(@"bundle=%@",bundle);
    
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
//                _NSLog(@"url_found=%@",url);
                break;
            }
        }
    }
    
    return url;
}



- (void)removeStoreAtURL:(NSURL *)storeURL
{
    NSString * storePath = [storeURL path];
    _NSLog(@"remove files at %@",storePath);
    
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:NULL];
    [[NSFileManager defaultManager] removeItemAtPath:[storePath stringByAppendingString:@"-shm"] error:NULL];
    [[NSFileManager defaultManager] removeItemAtPath:[storePath stringByAppendingString:@"-wal"] error:NULL];
}


-(NSInteger)lastNumberFromString:(NSString*)str
{
    NSArray *arr = [str componentsSeparatedByString:@" "];
    NSInteger i = [[arr lastObject] integerValue];
    if ((arr.count <= 1) && (i==0)) {
        arr = [str componentsSeparatedByString:@"_"];
        i = [[arr lastObject] integerValue];
    }
    return i;
}


- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


//NSTemporaryDirectory()



/*
- (NSManagedObjectContext *)managedObjectContext {
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"YOURDB.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        if (error.code == 134100) {
            if ( [[NSFileManager defaultManager] fileExistsAtPath: [storeURL path]] ) {
                NSDictionary *existingPersistentStoreMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType: NSSQLiteStoreType URL: storeURL error: &error];
                if ( !existingPersistentStoreMetadata ) {
                    // Something *really* bad has happened to the persistent store
                    [NSException raise: NSInternalInconsistencyException format: @"Failed to read metadata for persistent store %@: %@", storeURL, error];
                }
                
                if ( ![[self managedObjectModel] isConfiguration: nil compatibleWithStoreMetadata: existingPersistentStoreMetadata] ) {
                    if (![[NSFileManager defaultManager] removeItemAtURL: storeURL error: &error] ) {
                        _NSLog(@"*** Could not delete persistent store, %@", error);
                        abort();
                    } else {
                        [__persistentStoreCoordinator addPersistentStoreWithType: NSSQLiteStoreType configuration: nil URL: storeURL options: nil error: &error];
                    }
                }
            }
        } else {
            _NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return __persistentStoreCoordinator;
}
*/


@end


