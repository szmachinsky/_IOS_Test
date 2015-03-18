//
//  RHManagedObjectContextManager.m
//
//  Copyright (C) 2013 by Christopher Meyer
//  http://schwiiz.org/
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

//#import "RHManagedObjectContextManager.h"
//#import "RHManagedObject.h"
#import "ZipArchive.h"
#import "UIViewController+Hud.h"
//#import "NSDictionary+YoutubeInfo.h"

#if !DEBUG || 0
# define NSLog(...)     ((void)0)
#endif

@interface ITMigrationManager : NSMigrationManager
@end

@implementation ITMigrationManager

- (NSDate*)defaultDate{
    static NSDate* def = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDateComponents* components = [[NSDateComponents alloc] init];
        components.year = 1970;
        components.month = 1;
        components.day = 1;
        def = [[NSCalendar autoupdatingCurrentCalendar] dateFromComponents:components];
    });
    return def;
}

- (NSString*)ensureNotEmptyString:(NSString*)s{
    if (s)
        return s;
    return @"";
}

- (NSString*)emptyString{
    return @"";
}

- (NSString*)getAuthor:(NSData*)nativeData{
    @try
    {
        NSDictionary* dict = [NSKeyedUnarchiver unarchiveObjectWithData:nativeData];
        if (![dict isKindOfClass:[NSDictionary class]])
            return @"";
        
        return nil;//[dict youtube_AuthorString];
    }
    @catch(...)
    {
        return @"";
    }
}

- (NSString*)getChannelTitle:(NSData*)nativeData{
    @try
    {
        NSDictionary* dict = [NSKeyedUnarchiver unarchiveObjectWithData:nativeData];
        if (![dict isKindOfClass:[NSDictionary class]])
            return @"";
        
        return nil;//[dict youtube_ChannelTitle];
    }
    @catch(...)
    {
        return @"";
    }
}

- (NSString*)getDescription:(NSData*)nativeData{
    @try
    {
        NSDictionary* dict = [NSKeyedUnarchiver unarchiveObjectWithData:nativeData];
        if (![dict isKindOfClass:[NSDictionary class]])
            return @"";
        
        return nil;//[dict youtube_DescriptionString];
    }
    @catch(...)
    {
        return @"";
    }
}


- (NSNumber*)getDislikeCount:(NSData*)nativeData{
    @try
    {
        NSDictionary* dict = [NSKeyedUnarchiver unarchiveObjectWithData:nativeData];
        if (![dict isKindOfClass:[NSDictionary class]])
            return @(0);
        
        return nil;//@([[dict youtube_DislikesCountString] integerValue]);
    }
    @catch(...)
    {
        return @(0);
    }
}

- (NSNumber*)getViewsCount:(NSData*)nativeData{
    @try
    {
        NSDictionary* dict = [NSKeyedUnarchiver unarchiveObjectWithData:nativeData];
        if (![dict isKindOfClass:[NSDictionary class]])
            return @(0);
        
        return nil;//@([[dict youtube_ViewCountString] integerValue]);
    }
    @catch(...)
    {
        return @(0);
    }
}

- (NSNumber*)getLikesCount:(NSData*)nativeData{
    @try
    {
        NSDictionary* dict = [NSKeyedUnarchiver unarchiveObjectWithData:nativeData];
        if (![dict isKindOfClass:[NSDictionary class]])
            return @(0);
        
        return nil;//@([[dict youtube_LikesCountString] integerValue]);
    }
    @catch(...)
    {
        return @(0);
    }
}

- (NSString*)getHRTURL:(NSData*)nativeData{
    @try
    {
        NSDictionary* dict = [NSKeyedUnarchiver unarchiveObjectWithData:nativeData];
        if (![dict isKindOfClass:[NSDictionary class]])
            return @"";
        
        return nil;//[[dict youtube_HighResolutionThumbmailURL] absoluteString];
    }
    @catch(...)
    {
        return @"";
    }
}

- (NSString*)getMRTURL:(NSData*)nativeData{
    @try
    {
        NSDictionary* dict = [NSKeyedUnarchiver unarchiveObjectWithData:nativeData];
        if (![dict isKindOfClass:[NSDictionary class]])
            return @"";
        
        return nil;//[[dict youtube_MediumResolutionThumbmailURL] absoluteString];
    }
    @catch(...)
    {
        return @"";
    }
}

- (NSString*)getDRTURL:(NSData*)nativeData{
    @try
    {
        NSDictionary* dict = [NSKeyedUnarchiver unarchiveObjectWithData:nativeData];
        if (![dict isKindOfClass:[NSDictionary class]])
            return @"";
        
        return nil;//[[dict youtube_DefaultThumbmailURL] absoluteString];
    }
    @catch(...)
    {
        return @"";
    }
}

@end

static BOOL _isDatabaseReady = NO;

#define ENABLE_DYNAMIC_MODELS 1

#if ENABLE_DYNAMIC_MODELS
# import "ZipArchive.h"
#endif

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

/**
 * Iteratively migrates a persistent Core Data store along a series of ordered
 * managed object models.  Allows for easily mixing inferred migrations
 * with mapping models and custom migrations.
 */
@interface Migrator : NSObject

/**
 * Iteratively migrates the store at the given URL from its current model
 * to the given finalModel in order through the list of modelNames.
 *
 * Does nothing (returns YES) if the persistent store does not yet exist
 * at the given sourceStoreURL.
 *
 * @param sourceStoreURL The file URL to the persistent store file.
 * @param sourceStoreType The type of store at sourceStoreURL
 *        (see NSPersistentStoreCoordinator for possible values).
 * @param finalModel The final target managed object model for the migration manager.
 *        At the end of the migration, the persistent store should be migrated
 *        to this model.
 * @param modelNames *.mom file names for each of the managed object models
 *        through which the persistent store might need to be migrated.
 *        The model names should be ordered in such a way that migration
 *        from one to the next can occur either using a custom mapping model
 *        or an inferred mapping model.
 *        The *.mom files should be stored in the top level of the main bundle.
 * @param error If an error occurs during the migration, upon return contains
 *        an NSError object that describes the problem.
 *
 * @return YES if the migration proceeds without errors, otherwise NO.
 */
+ (BOOL)iterativeMigrateURL:(NSURL *)sourceStoreURL
    ofType:(NSString *)sourceStoreType
    toModel:(NSManagedObjectModel *)finalModel
    error:(NSError **)error;

/**
 * Migrates the store at the given URL from one object model to another
 * using the given mapping model.  Writes the store to a temporary file
 * during migration so that if migration fails, the original store is left intact.
 *
 * @param sourceStoreURL The file URL to the persistent store file.
 * @param sourceStoreType The type of store at sourceStoreURL
 *        (see NSPersistentStoreCoordinator for possible values).
 * @param sourceModel The source managed object model for the migration manager.
 * @param targetModel The target managed object model for the migration manager.
 * @param mappingModel The mapping model to use to effect the migration.
 * @param error If an error occurs during the migration, upon return contains
 *        an NSError object that describes the problem.
 *
 * @return YES if the migration proceeds without errors, otherwise NO.
 */
+ (BOOL)migrateURL:(NSURL *)sourceStoreURL
    ofType:(NSString *)sourceStoreType
    fromModel:(NSManagedObjectModel *)sourceModel
    toModel:(NSManagedObjectModel *)targetModel
    mappingModel:(NSMappingModel *)mappingModel
    error:(NSError **)error
            offset:(float)offset
             range:(float)range;

/**
 * Returns the error domain used in NSErrors created by this class.
 */
+ (NSString *)errorDomain;

@end

static volatile float _progressOffset = 0.f;
static volatile float _progressRange = 0.f;

@implementation Migrator

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
    NSMigrationManager * migrator = [[ITMigrationManager alloc]
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

    return [NSError errorWithDomain:[Migrator errorDomain]
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

@interface RHManagedObjectContext : NSManagedObjectContext
@property (nonatomic, weak) id observer;
@end

@implementation RHManagedObjectContext
@synthesize observer;

// This subclass is for managing the NSManagedObjectContextDidSaveNotification.  The ManagedObjectContext is deallocated at an undetermined
// time when the thread on which it was allocated cleans up the threadDictionary.  By putting the removeObserver in the dealloc we can be
// certain everything is cleaned up when it's no longer required.
- (void)setObserver:(id)_observer
{
    if (_observer != self.observer)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self.observer
                                                        name:NSManagedObjectContextDidSaveNotification
                                                      object:self];

        observer = _observer;

        [[NSNotificationCenter defaultCenter] addObserver:self.observer
                                                 selector:NSSelectorFromString(@"mocDidSave:")
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:self];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.observer
                                                    name:NSManagedObjectContextDidSaveNotification
                                                  object:self];
}

@end


@interface RHManagedObjectContextManager ()

@property (nonatomic, strong) NSManagedObjectContext * managedObjectContextForMainThread;
@property (nonatomic, strong) NSManagedObjectModel * managedObjectModel;
@property (nonatomic, copy) NSString * modelName;
@property (nonatomic, copy) NSString * guid;

+ (NSMutableDictionary *)sharedInstances;
- (NSString *)storePath;
- (NSURL *)storeURL;
- (NSString *)databaseName;
- (void)mocDidSave:(NSNotification *)saveNotification;
@property (nonatomic, strong) id localChangeObserver;
@end

@implementation RHManagedObjectContextManager
@synthesize managedObjectContextForMainThread;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;
@synthesize modelName;
@synthesize guid;

#pragma mark -
#pragma mark Singleton Methods
+ (RHManagedObjectContextManager *)sharedInstanceWithModelName:(NSString *)modelName
{
    RHManagedObjectContextManager * context = nil;

    @synchronized(self)
    {
        if ([[self sharedInstances] objectForKey:modelName] == nil)
        {
            RHManagedObjectContextManager * contextManager = [[RHManagedObjectContextManager alloc] initWithModelName:modelName];
            [[self sharedInstances] setObject:contextManager forKey:modelName];
        }
        context = [[self sharedInstances] objectForKey:modelName];
    }
    return context;
}

+ (NSMutableDictionary *)sharedInstances
{
    static dispatch_once_t once;
    static NSMutableDictionary * sharedInstances;

    dispatch_once(&once, ^{
                      sharedInstances = [[NSMutableDictionary alloc] init];
                  });
    return sharedInstances;
}

+ (NSError *)deleteFile:(NSString *)filePath
{
    NSFileManager * fm = [NSFileManager defaultManager];
    NSError * error;

    if ([fm fileExistsAtPath:filePath] && [fm isDeletableFileAtPath:filePath])
    {
        [fm removeItemAtPath:filePath error:&error];
    }

    return error;
}

- (id)initWithModelName:(NSString *)_modelName
{
    if (self = [super init])
    {
        self.modelName = _modelName;



    }
    return self;
}



#pragma mark -
#pragma mark Other useful stuff
// Used to flush and reset the database.
- (NSError *)deleteStore
{
    NSError * error = nil;

    if (persistentStoreCoordinator == nil)
    {
        NSString * storePath = [self storePath];

        [self deleteStoreFiles:storePath];

    }
    else
    {

        NSPersistentStoreCoordinator * storeCoordinator = [self persistentStoreCoordinatorWithError:&error];
        if (error)
        {
            return error;
        }

        for (NSPersistentStore * store in [storeCoordinator persistentStores])
        {
            NSURL * storeURL = store.URL;
            NSString * storePath = storeURL.path;
            [storeCoordinator removePersistentStore:store error:&error];

            if (error)
            {
                return error;
            }

            [self deleteStoreFiles:storePath];
        }
    }

    self.managedObjectContextForMainThread = nil;
    self.managedObjectModel = nil;
    self.persistentStoreCoordinator = nil;
    self.guid = nil;

    [[RHManagedObjectContextManager sharedInstances] removeObjectForKey:[self modelName]];

    return nil;
}


- (NSError *)deleteStoreFiles:(NSString *)storePath
{
    NSError * error = [RHManagedObjectContextManager deleteFile:storePath];

    [RHManagedObjectContextManager deleteFile:[storePath stringByAppendingString:@"-shm"]];
    [RHManagedObjectContextManager deleteFile:[storePath stringByAppendingString:@"-wal"]];

    return error;

}

- (NSString *)guid
{
    if (guid == nil)
    {
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        NSString * uuidStr = (__bridge_transfer NSString *) CFUUIDCreateString(kCFAllocatorDefault, uuid);
        CFRelease(uuid);

        self.guid = [uuidStr lowercaseString];
    }
    return guid;
}

- (NSUInteger)pendingChangesCountWithError:(NSError **)error
{
    NSManagedObjectContext * moc = [self managedObjectContextForCurrentThreadWithError:error];

    NSSet * updated  = [moc updatedObjects];
    NSSet * deleted  = [moc deletedObjects];
    NSSet * inserted = [moc insertedObjects];

    return [updated count] + [deleted count] + [inserted count];
}

// http://stackoverflow.com/questions/5236860/app-freeze-on-coredata-save
- (NSError *)commit
{

    NSError * error = nil;
    NSManagedObjectContext * moc = [self managedObjectContextForCurrentThreadWithError:&error];

    if (error)
    {
        return error;
    }

    if ([self pendingChangesCountWithError:&error] > kPostMassUpdateNotificationThreshold)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:RHWillMassUpdateNotification
                                                            object:nil];
    }

    if (error)
    {
        return error;
    }

    if ([moc hasChanges] && ![moc save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return error;
    }
    return nil;
}

#pragma mark -
#pragma mark Core Data stack
- (NSManagedObjectContext *)managedObjectContextForMainThreadWithError:(NSError **)error
{
    if (managedObjectContextForMainThread == nil)
    {
        NSAssert([NSThread isMainThread], @"Must be instantiated on main thread.");
        self.managedObjectContextForMainThread = [[NSManagedObjectContext alloc] init];
        [managedObjectContextForMainThread setPersistentStoreCoordinator:[self persistentStoreCoordinatorWithError:error]];
        [managedObjectContextForMainThread setMergePolicy:kMergePolicy];

        self.localChangeObserver = [[NSNotificationCenter defaultCenter]
                                    addObserverForName:NSManagedObjectContextObjectsDidChangeNotification
                                                object:managedObjectContextForMainThread
                                                 queue:[NSOperationQueue mainQueue]
                                            usingBlock:^(NSNotification * notification) {
                                        NSSet * updatedObjects = [[notification userInfo] objectForKey:NSUpdatedObjectsKey];
                                        [updatedObjects makeObjectsPerformSelector:@selector(didUpdate)];
                                    }];
    }

    return managedObjectContextForMainThread;
}

- (NSManagedObjectContext *)managedObjectContextForCurrentThreadWithError:(NSError **)error
{
    NSThread * thread = [NSThread currentThread];

    if ([thread isMainThread])
    {
        return [self managedObjectContextForMainThreadWithError:error];
    }

    // A key to cache the moc for the current thread.
    // 2013-04-10 - Added a GUID to make sure the key is unique if the store is ever reset.  We don't want to access
    // a cached value from a deleted store!
    NSString * threadKey = [NSString stringWithFormat:@"RHManagedObjectContext_%@_%@", self.modelName, self.guid];

    if ( [[thread threadDictionary] objectForKey:threadKey] == nil )
    {
        // create a moc for this thread
        RHManagedObjectContext * threadContext = [[RHManagedObjectContext alloc] init];
        [threadContext setPersistentStoreCoordinator:[self persistentStoreCoordinatorWithError:error]];
        [threadContext setMergePolicy:kMergePolicy];
        [threadContext setObserver:self];

        [[thread threadDictionary] setObject:threadContext forKey:threadKey];
    }

    return [[thread threadDictionary] objectForKey:threadKey];
}

/**
 * Returns the managed object model for the application.
 * If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel == nil)
    {
#if ENABLE_DYNAMIC_MODELS
        self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:CurrentModelURL()];
#else
        NSString * modelPath = [[NSBundle mainBundle] pathForResource:self.modelName ofType:@"momd"];
        NSURL * modelURL = [NSURL fileURLWithPath:modelPath];
        modelURL = CurrentModelURL();
        self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
#endif
    }

    return managedObjectModel;
}

- (void)mocDidSave:(NSNotification *)saveNotification
{
    if ([NSThread isMainThread])
    {
        // This ensures no updated object is fault, which would cause the NSFetchedResultsController updates to fail.
        // http://www.mlsite.net/blog/?p=518

        NSDictionary * userInfo = saveNotification.userInfo;

        NSArray * updates = [[userInfo objectForKey:@"updated"] allObjects];
        for (RHManagedObject * item in updates)
        {
            [[item objectInCurrentThreadContext] willAccessValueForKey:nil];
        }

        // 2013-04-14 - This hack is also required on the "inserted" key to ensure NSFetchedResultsController works properly
        NSArray * inserted = [[userInfo objectForKey:@"inserted"] allObjects];
        for (RHManagedObject * item in inserted)
        {
            [[item objectInCurrentThreadContext] willAccessValueForKey:nil];
        }

        NSError * error = nil;
        [[self managedObjectContextForMainThreadWithError:&error] mergeChangesFromContextDidSaveNotification:saveNotification];

    }
    else
    {
        [self performSelectorOnMainThread:@selector(mocDidSave:) withObject:saveNotification waitUntilDone:NO];
    }
}

- (BOOL)doesRequireMigrationWithError:(NSError **)error
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self storePath]])
    {
        //		NSError *error = nil;
        NSDictionary * sourceMetadata = [NSPersistentStoreCoordinator
                                         metadataForPersistentStoreOfType:NSSQLiteStoreType
                                                                      URL:[self storeURL]
                                                                    error:error];
        return ![[self managedObjectModel] isConfiguration:nil
                               compatibleWithStoreMetadata:sourceMetadata];
    }
    else
    {
        return NO;
    }
}

/**
 * Returns the persistent store coordinator for the application.
 * If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinatorWithError:(NSError **)error
{
    if (persistentStoreCoordinator == nil)
    {
        NSError * __autoreleasing _error = nil;
        if (!error)
            error = &_error;

        @synchronized(self)
        {
            // This next block is useful when the store is initialized for the first time.  If the DB doesn't already
            // exist and a copy of the db (with the same name) exists in the bundle, it'll be copied over and used.  This
            // is useful for the initial seeding of data in the app.
            NSString * storePath = [self storePath];

            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{

                  NSError * error = nil;

#if ENABLE_DYNAMIC_MODELS
                  NSString * tmp = [NSTemporaryDirectory() stringByAppendingPathComponent:@"dm.bundle"];
                  [[NSFileManager defaultManager] removeItemAtPath:tmp error:NULL];
                  [[NSFileManager defaultManager] createDirectoryAtPath:tmp withIntermediateDirectories:YES attributes:nil error:NULL];
                  ZipArchive * zip = [[ZipArchive alloc] initWithFileManager:[NSFileManager defaultManager]];
                  if ([zip UnzipOpenFile:[[NSBundle mainBundle] pathForResource:@"mdl" ofType:@"dat"]])
                  {
                      if ([zip UnzipFileTo:tmp overWrite:YES])
                      {
                          [zip CloseZipFile2];
                          
                          if ([zip UnzipOpenFile:[[NSBundle mainBundle] pathForResource:@"mpg" ofType:@"dat"]])
                          {
                              if ([zip UnzipFileTo:tmp overWrite:YES])
                              {
                                  // bundles = @[[[NSBundle alloc] initWithPath:tmp]];
                              }
                          }
                          
                          if ([zip UnzipOpenFile:[[NSBundle mainBundle] pathForResource:@"mpg23" ofType:@"dat"]])
                          {
                              if ([zip UnzipFileTo:tmp overWrite:YES])
                              {
                                  // bundles = @[[[NSBundle alloc] initWithPath:tmp]];
                              }
                          }
                      }
                  }
    
                  [self managedObjectModel];// call it here to be able to use tmp bundle!

#endif//#if ENABLE_DYNAMIC_MODELS
    
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
                  else
                  {
                      [@"Y" writeToFile:[[[self storeURL] URLByAppendingPathExtension:@"mgt"] path]
                             atomically: YES
                               encoding: NSUTF8StringEncoding error: NULL];
                      
                      [@"Y" writeToFile:[[[self storeURL] URLByAppendingPathExtension:@"mgt3"] path]
                             atomically: YES
                               encoding: NSUTF8StringEncoding error: NULL];
                      
                  }
#if ENABLE_DYNAMIC_MODELS
                  [[NSFileManager defaultManager] removeItemAtPath:tmp error:NULL];
#endif//#if ENABLE_DYNAMIC_MODELS

              });

            NSFileManager * fileManager = [NSFileManager defaultManager];

            if (![fileManager fileExistsAtPath:storePath])
            {
                NSString * defaultStorePath = [[NSBundle mainBundle] pathForResource:[self databaseName] ofType:nil];

                if ([fileManager fileExistsAtPath:defaultStorePath])
                {
                    [fileManager copyItemAtPath:defaultStorePath toPath:storePath error:error];
                }
            }

            NSURL * storeURL = [self storeURL];
            //			NSError *error = nil;


            self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];

            // https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CoreDataVersioning/Articles/vmLightweightMigration.html#//apple_ref/doc/uid/TP40004399-CH4-SW1
            NSDictionary * options = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                      [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                                      @{ @"journal_mode": @"DELETE" }, NSSQLitePragmasOption,
                                      nil];

            if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                          configuration:nil
                                                                    URL:storeURL
                                                                options:options
                                                                  error:error])
            {
                /*
                   Replace this implementation with code to handle the error appropriately.

                   abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.

                   Typical reasons for an error here include:
                 * The persistent store is not accessible;
                 * The schema for the persistent store is incompatible with current managed object model.
                   Check the error message to determine what the actual problem was.


                   If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.

                   If you encounter schema incompatibility errors during development, you can reduce their frequency by:
                 * Simply deleting the existing store:
                   [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]

                 * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
                   [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

                   Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.

                 */

                NSLog(@"Unresolved error %@, %@", *error, [*error userInfo]);

                [[NSFileManager defaultManager] removeItemAtURL:storeURL error:NULL];

                if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                              configuration:nil
                                                                        URL:storeURL
                                                                    options:options
                                                                      error:error])
                {
                    /*
                       Replace this implementation with code to handle the error appropriately.

                       abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.

                       Typical reasons for an error here include:
                     * The persistent store is not accessible;
                     * The schema for the persistent store is incompatible with current managed object model.
                       Check the error message to determine what the actual problem was.


                       If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.

                       If you encounter schema incompatibility errors during development, you can reduce their frequency by:
                     * Simply deleting the existing store:
                       [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]

                     * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
                       [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];

                       Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.

                     */
                    if (error)
                        NSLog(@"Unresolved error %@, %@", *error, [*error userInfo]);
                    abort();
                }
            }
            
            _isDatabaseReady = YES;            
        }         // end @synchronized
    }
    
    return persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Application's Documents directory
- (NSString *)storePath
{
    return [[self applicationDocumentsDirectory] stringByAppendingPathComponent:[self databaseName]];
}

- (NSURL *)storeURL
{
    return [NSURL fileURLWithPath:[self storePath]];
}

- (NSString *)databaseName
{
    // return [NSString stringWithFormat:@"%@.sqlite", [self.modelName lowercaseString]];
    return @"model.sqlite";
}

- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (BOOL)isDatabaseReady{
    return _isDatabaseReady;
}

@end