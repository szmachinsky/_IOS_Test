//
//  BPMigrator.m
//  Core_Test
//
//  Created by Zmachinsky Sergei on 17.03.15.
//  Copyright (c) 2015 Zmachinsky Sergei. All rights reserved.
//

#import "BPMigrator.h"
#import <CoreData/CoreData.h>
#import "BPMigrationManager.h"

#import "UIViewController+Hud.h"


static BOOL _isDatabaseReady = NO;


#define ENABLE_DYNAMIC_MODELS 1


//#if ENABLE_DYNAMIC_MODELS
//# import "ZipArchive.h"
//#endif


#if ENABLE_DYNAMIC_MODELS
static NSURL * TMPMomURL()
{
    return [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"dm.bundle"]];
}
#endif

static NSURL * Model1URL()
{
#if ENABLE_DYNAMIC_MODELS
    return [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"dm.bundle/Model.momd/Model.mom"]];
#else
    return [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"mom" subdirectory:@"Model.momd"];
#endif
}

static NSURL * Model2URL()
{
#if ENABLE_DYNAMIC_MODELS
    return [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"dm.bundle/Model.momd/Model 2.mom"]];
#else
    return [[NSBundle mainBundle] URLForResource:@"Model 2" withExtension:@"mom" subdirectory:@"Model.momd"];
#endif
}

static NSURL * Model3URL()
{
#if ENABLE_DYNAMIC_MODELS
    return [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"dm.bundle/Model.momd/Model 3.mom"]];
#else
    return [[NSBundle mainBundle] URLForResource:@"Model 3" withExtension:@"mom" subdirectory:@"Model.momd"];
#endif
}

static NSURL * CurrentModelURL()
{
    return Model3URL();
}

static NSURL * Model2ToModel3MappingURL()
{
#if ENABLE_DYNAMIC_MODELS
    return [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"dm.bundle/Migrate23.cdm"]];
#else
    return [[NSBundle mainBundle] URLForResource:@"Migrate23" withExtension:@"cdm"];
#endif
}

static NSURL * Model1ToModel2MappingURL()
{
#if ENABLE_DYNAMIC_MODELS
    return [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"dm.bundle/Migrate.cdm"]];
#else
    return [[NSBundle mainBundle] URLForResource:@"Migrate" withExtension:@"cdm"];
#endif
}

static NSArray * MOMBundles()
{
    static NSArray * bundles = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        NSBundle * bundle =
#if ENABLE_DYNAMIC_MODELS
        [[NSBundle alloc] initWithPath:[TMPMomURL() path]];
#else
        [NSBundle mainBundle];
#endif
        if (bundle)
        {
            bundles = @[bundle];
        }
    });
    return bundles;
}


static volatile float _progressOffset = 0.f;
static volatile float _progressRange = 0.f;


static void ShowProgress()
{
    
}


#pragma mark -

@interface BPMigrator ()

@end

#pragma mark - BPMigrator

@implementation BPMigrator


+ (BOOL)iterativeMigrateURL:(NSURL *)sourceStoreURL
                     ofType:(NSString *)sourceStoreType
                    toModel:(NSManagedObjectModel *)finalModel
                      error:(NSError **)error
{
    // If the persistent store does not exist at the given URL,
    // assume that it hasn't yet been created and return success immediately.
    if (NO == [[NSFileManager defaultManager] fileExistsAtPath:[sourceStoreURL path]])
    {
        NSLog(@"NO == [[NSFileManager defaultManager] fileExistsAtPath:[sourceStoreURL path]]");
        return YES;
    }
    
    // Get the persistent store's metadata.  The metadata is used to
    // get information about the store's managed object model.
    NSDictionary * sourceMetadata = [self metadataForPersistentStoreOfType:sourceStoreType
                                                                       URL:sourceStoreURL
                                                                     error:error];
    if (nil == sourceMetadata)
    {
        NSLog(@"nil == sourceMetadata");
        return NO;
    }
    
    // Check whether the final model is already compatible with the store.
    // If it is, no migration is necessary.
    if ([finalModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata])
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[sourceStoreURL URLByAppendingPathExtension:@"mgt3"] path]]){
            NSLog(@"[[NSFileManager defaultManager] fileExistsAtPath:[[sourceStoreURL URLByAppendingPathExtension:@\"mgt3\"] path]]");
            return YES;
        }
    }
    
    float off = 0.;
    float ran = 1.0;
    
    // Find the current model used by the store.
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[sourceStoreURL URLByAppendingPathExtension:@"mgt"] path]])
    {
        NSManagedObjectModel * sourceModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:Model1URL()];
        if (nil == sourceModel){
            NSLog(@"sourceModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:Model1URL()] == nil");
            return NO;
        }
        
        NSMappingModel * mappingModel = nil;
        
        mappingModel = [[NSMappingModel alloc] initWithContentsOfURL:Model1ToModel2MappingURL()];
        
        if (nil == mappingModel){
            NSLog(@"mappingModel = [[NSMappingModel alloc] initWithContentsOfURL:Model1ToModel2MappingURL()] == nil");
            return NO;
        }
        
        ran = 0.5;
        
        if (![self migrateURL:sourceStoreURL
                       ofType:sourceStoreType
                    fromModel:sourceModel
                      toModel:finalModel
                 mappingModel:mappingModel
                        error:error
                       offset:off range:ran])
        {
            return NO;
        }
        
        off += 0.5;
        
        [@"Y" writeToFile :[[sourceStoreURL URLByAppendingPathExtension:@"mgt"] path] atomically : YES
                 encoding : NSUTF8StringEncoding error : NULL];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[sourceStoreURL URLByAppendingPathExtension:@"mgt3"] path]])
    {
        NSManagedObjectModel * sourceModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:Model2URL()];
        if (nil == sourceModel){
            NSLog(@"sourceModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:Model2URL()] == nil");
            return NO;
        }
        
        NSMappingModel * mappingModel = nil;
        
        mappingModel = [[NSMappingModel alloc] initWithContentsOfURL:Model2ToModel3MappingURL()];
        
        if (nil == mappingModel){
            NSLog(@"mappingModel = [[NSMappingModel alloc] initWithContentsOfURL:Model2ToModel3MappingURL()] == nil");
            return NO;
        }
        
        if (![self migrateURL:sourceStoreURL
                       ofType:sourceStoreType
                    fromModel:sourceModel
                      toModel:finalModel
                 mappingModel:mappingModel
                        error:error
                       offset:off range:ran])
        {
            return NO;
        }
        
        [@"Y" writeToFile :[[sourceStoreURL URLByAppendingPathExtension:@"mgt3"] path] atomically : YES
                 encoding : NSUTF8StringEncoding error : NULL];
        
    }
    
    return YES;
}

+ (void)removeStoreAtURL:(NSURL *)storeURL
{
    NSString * storePath = [storeURL path];
    
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:NULL];
    [[NSFileManager defaultManager] removeItemAtPath:[storePath stringByAppendingString:@"-shm"] error:NULL];
    [[NSFileManager defaultManager] removeItemAtPath:[storePath stringByAppendingString:@"-wal"] error:NULL];
}

+ (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSMigrationManager * migrator = object;
    
    if ([NSThread isMainThread])
    {
        [UIViewController showProgressHud:_progressOffset + migrator.migrationProgress * _progressRange text:NSLocalizedString(@"Updating media database...",)];
        
        while (kCFRunLoopRunHandledSource == CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.001, YES));
    }
    else{
        NSLog(@"NOT MAIN THREAD");
        const float off = _progressOffset;
        const float ran = _progressRange;
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIViewController showProgressHud:off + migrator.migrationProgress * ran text:NSLocalizedString(@"Updating media database...",)];
        });
    }
    
    NSLog(@"migrationProgress = %f",migrator.migrationProgress);
}

+ (BOOL)migrateURL:(NSURL *)sourceStoreURL
            ofType:(NSString *)sourceStoreType
         fromModel:(NSManagedObjectModel *)sourceModel
           toModel:(NSManagedObjectModel *)targetModel
      mappingModel:(NSMappingModel *)mappingModel
             error:(NSError **)error
            offset:(float)offset
             range:(float)range
{
    _progressOffset = offset;
    _progressRange = range;
    
    // Build a temporary path to write the migrated store.
    NSURL * tempDestinationStoreURL =
    [NSURL fileURLWithPath:[[sourceStoreURL path] stringByAppendingPathExtension:@"tmp"]];
    
    
    NSURL * sourceStoreURL_SHM =
    [NSURL fileURLWithPath:[[sourceStoreURL path] stringByAppendingString:@"-shm"]];
    
    NSURL * sourceStoreURL_WAL =
    [NSURL fileURLWithPath:[[sourceStoreURL path] stringByAppendingString:@"-wal"]];
    
    // Migrate from the source model to the target model using the mapping,
    // and store the resulting data at the temporary path.
    NSMigrationManager * migrator = [[BPMigrationManager alloc]
                                     initWithSourceModel:sourceModel
                                     destinationModel:targetModel];
    
    [[NSFileManager defaultManager] removeItemAtURL:tempDestinationStoreURL error:NULL];
    [[NSFileManager defaultManager] removeItemAtURL:[sourceStoreURL URLByAppendingPathExtension:@"tmp-shm"] error:NULL];
    [[NSFileManager defaultManager] removeItemAtURL:[sourceStoreURL URLByAppendingPathExtension:@"tmp-wal"] error:NULL];
    
    NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                              [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                              @{ @"journal_mode": @"DELETE" }, NSSQLitePragmasOption,
                              nil];
    
    if ([NSThread isMainThread])
    {
        [UIViewController showInfiniteHudText:NSLocalizedString(@"Updating media database...",)];
        
        //while (kCFRunLoopRunHandledSource == CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.001, YES)) ;
    }
    else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIViewController showInfiniteHudText:NSLocalizedString(@"Updating media database...",)];
        });
    }
    
    [migrator addObserver:(id)self forKeyPath:@"migrationProgress" options:0 context:NULL];
    
    if (![migrator migrateStoreFromURL:sourceStoreURL
                                  type:sourceStoreType
                               options:options
                      withMappingModel:mappingModel
                      toDestinationURL:tempDestinationStoreURL
                       destinationType:sourceStoreType
                    destinationOptions:nil
                                 error:error])
    {
        [migrator removeObserver:(id)self forKeyPath:@"migrationProgress"];
        
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
        return NO;
    }
    
    [migrator removeObserver:(id)self forKeyPath:@"migrationProgress"];
    
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
    
    
    [[NSFileManager defaultManager] removeItemAtURL:sourceStoreURL_SHM error:NULL];
    [[NSFileManager defaultManager] removeItemAtURL:sourceStoreURL_WAL error:NULL];
    
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    // Move the original source store to a backup location.
    NSString * backupPath = [[sourceStoreURL path] stringByAppendingPathExtension:@"bak"];
    
    if (![fileManager moveItemAtPath:[sourceStoreURL path]
                              toPath:backupPath
                               error:error])
    {
        [self removeStoreAtURL:tempDestinationStoreURL];
        // If the move fails, delete the migrated destination store.
        [fileManager moveItemAtPath:[tempDestinationStoreURL path]
                             toPath:[sourceStoreURL path]
                              error:NULL];
        
        [[NSFileManager defaultManager] removeItemAtURL:[sourceStoreURL URLByAppendingPathExtension:@"tmp-shm"] error:NULL];
        [[NSFileManager defaultManager] removeItemAtURL:[sourceStoreURL URLByAppendingPathExtension:@"tmp-wal"] error:NULL];
        return NO;
    }
    
    [fileManager moveItemAtPath:[[sourceStoreURL URLByAppendingPathExtension:@"tmp-shm"] path]
                         toPath:[sourceStoreURL_SHM path]
                          error:error];
    
    [fileManager moveItemAtPath:[[sourceStoreURL URLByAppendingPathExtension:@"tmp-wal"] path]
                         toPath:[sourceStoreURL_WAL path]
                          error:error];
    
    
    // Move the destination store to the original source location.
    if ([fileManager moveItemAtPath:[tempDestinationStoreURL path]
                             toPath:[sourceStoreURL path]
                              error:error])
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
    
    return YES;
}

+ (NSString *)errorDomain
{
    return @"com.artlogic.IterativeMigrator";
}

#pragma mark - Private methods

// Returns an NSError with the give code and localized description,
// and this class' error domain.
+ (NSError *)errorWithCode:(NSInteger)code description:(NSString *)description
{
    NSDictionary * userInfo = @{
                                NSLocalizedDescriptionKey: description
                                };
    
    return [NSError errorWithDomain:[BPMigrator errorDomain]
                               code:code
                           userInfo:userInfo];
    
    return NO;
}

// Gets the metadata for the given persistent store.
+ (NSDictionary *)metadataForPersistentStoreOfType:(NSString *)storeType
                                               URL:(NSURL *)url
                                             error:(NSError **)error
{
    NSDictionary * sourceMetadata =
    [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:storeType
                                                               URL:url
                                                             error:error];
    
    if (nil == sourceMetadata && NULL != error)
    {
        NSString * errorDesc = [NSString stringWithFormat:
                                @"Failed to find source metadata for store: %@",
                                url];
        *error = [self errorWithCode:102 description:errorDesc];
    }
    
    return sourceMetadata;
}

// Finds the source model for the store described by the given metadata.
+ (NSManagedObjectModel *)modelForStoreMetadata:(NSDictionary *)metadata
                                          error:(NSError **)error
{
    NSManagedObjectModel * sourceModel = [NSManagedObjectModel
                                          mergedModelFromBundles:MOMBundles()
                                          forStoreMetadata:metadata];
    
    if (nil == sourceModel && NULL != error)
    {
        NSString * errorDesc = [NSString stringWithFormat:
                                @"Failed to find source model for metadata: %@",
                                metadata];
        *error = [self errorWithCode:100 description:errorDesc];
    }
    
    return sourceModel;
}

// Returns an array of NSManagedObjectModels loaded from mom files with the given names.
// Returns nil if any model files could not be found.
+ (NSArray *)modelsNamed:(NSArray *)modelNames
                   error:(NSError **)error
{
    NSMutableArray * models = [NSMutableArray array];
    
    for (NSString * modelName in modelNames)
    {
        NSURL * modelUrl = [self urlForModelName:modelName inDirectory:nil];
        NSManagedObjectModel * model =
        [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
        
        if (nil == model)
        {
            if (NULL != error)
            {
                NSString * errorDesc =
                [NSString stringWithFormat:@"No model found for %@ at URL %@", modelName, modelUrl];
                *error = [self errorWithCode:110 description:errorDesc];
            }
            return nil;
        }
        
        [models addObject:model];
    }
    return models;
}

// Returns an array of paths to .mom model files in the given directory.
// Recurses into .momd directories to look for .mom files.
// @param directory The name of the bundle directory to search.  If nil,
//    searches default paths.
+ (NSArray *)modelPathsInDirectory:(NSString *)directory
{
    NSMutableArray * modelPaths = [NSMutableArray array];
    
    NSArray * bundles = MOMBundles();
    
    if (!bundles)
        bundles = @[[NSBundle mainBundle]];
    else
    {
        bundles = [bundles arrayByAddingObject:[NSBundle mainBundle]];
    }
    
    for (NSBundle * bundle in bundles)
    {
        // Get top level mom file paths.
        [modelPaths addObjectsFromArray:
         [bundle pathsForResourcesOfType:@"mom"
                             inDirectory:directory]];
        
        // Get mom file paths from momd directories.
        NSArray * momdPaths = [bundle pathsForResourcesOfType:@"momd"
                                                  inDirectory:directory];
        for (NSString * momdPath in momdPaths)
        {
            NSString * resourceSubpath = [momdPath lastPathComponent];
            
            [modelPaths addObjectsFromArray:
             [[NSBundle mainBundle]
              pathsForResourcesOfType:@"mom"
              inDirectory:resourceSubpath]];
        }
    }
    
    return modelPaths;
}

// Returns the URL for a model file with the given name in the given directory.
// @param directory The name of the bundle directory to search.  If nil,
//    searches default paths.
+ (NSURL *)urlForModelName:(NSString *)modelName
               inDirectory:(NSString *)directory
{
    NSBundle * bundle = [MOMBundles() lastObject];
    
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


@end

/*
if ([[NSFileManager defaultManager] fileExistsAtPath:[[self storeURL] path]])
{
    if (![Migrator iterativeMigrateURL:[self storeURL]
                                ofType:NSSQLiteStoreType
                               toModel:[self managedObjectModel]
                                 error:&error])
    {
        NSLog(@"Error migrating to latest model: %@\n %@", error, [error userInfo]);
#if DEBUG || ADHOC
        abort();
#else // #if DEBUG || ADHOC
        [[NSFileManager defaultManager] removeItemAtURL:[self storeURL] error:NULL];
#endif // #if DEBUG || ADHOC
    }
}
*/



