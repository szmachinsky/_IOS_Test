//
//  MyMirgaror.m
//  Core_Test
//
//  Created by Zmachinsky Sergei on 18.03.15.
//  Copyright (c) 2015 Zmachinsky Sergei. All rights reserved.
//

#import "MyMirgaror.h"
#import <CoreData/CoreData.h>

#import "MigrationManager_4_5.h"

static volatile float _progressOffset = 0.f;
static volatile float _progressRange = 0.f;


@interface MyMirgaror ()

@end


@implementation MyMirgaror


+(BOOL)checkMigrationFor:(NSURL *)storeURL 
               modelName:(NSString *)modelName
                  ofType:(NSString *)sourceStoreType
          lightMigration:(BOOL)lightMigration
              completion:(void (^)(BOOL ok))completion
{
    BOOL result = NO;
    NSManagedObjectModel *_managedObjectModel;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    
@try {
    
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
                        migrationClass:[MigrationManager_4_5 class]
                                ofType:sourceStoreType
                             fromModel:sourceModel
                               toModel:destinationModel
                          mappingModel:mappingModel
                                offset:off
                                 range:ran];
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
    
@finally {
    if (completion) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"run_complition_block woth result=%d",result);
            completion(result);
        });
    }
        
    } //@finally
    
    
    return result;
}


+ (BOOL)migrateURL:(NSURL *)storeURL
//migrationManager:(NSMigrationManager*)migrationManager
    migrationClass:(Class)migrationClass
            ofType:(NSString *)sourceStoreType
         fromModel:(NSManagedObjectModel *)sourceModel
           toModel:(NSManagedObjectModel *)destinationModel
      mappingModel:(NSMappingModel *)mappingModel
 //            error:(NSError **)err
            offset:(float)offset
             range:(float)range
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
    
    NSMigrationManager *migrationManager;
    migrationManager = [[migrationClass alloc] initWithSourceModel:sourceModel destinationModel:destinationModel];
    
    if (!migrationManager)
    {
        migrationManager = [[NSMigrationManager alloc] initWithSourceModel:sourceModel destinationModel:destinationModel];
    }
    
    NSError *error;
    NSURL *newStoreURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Core_Test-Temp.sqlite"];
    
    
//-----------------
    // Build a temporary path to write the migrated store.
    NSURL * tempDestinationStoreURL =
    [NSURL fileURLWithPath:[[storeURL path] stringByAppendingPathExtension:@"tmp"]];
    
    NSURL * sourceStoreURL_SHM =
    [NSURL fileURLWithPath:[[storeURL path] stringByAppendingString:@"-shm"]];
    
    NSURL * sourceStoreURL_WAL =
    [NSURL fileURLWithPath:[[storeURL path] stringByAppendingString:@"-wal"]];
    
    [[NSFileManager defaultManager] removeItemAtURL:tempDestinationStoreURL error:NULL];
    [[NSFileManager defaultManager] removeItemAtURL:[storeURL URLByAppendingPathExtension:@"tmp-shm"] error:NULL];
    [[NSFileManager defaultManager] removeItemAtURL:[storeURL URLByAppendingPathExtension:@"tmp-wal"] error:NULL];
    
    newStoreURL = tempDestinationStoreURL;
    
//------------
    
    BOOL ok = [migrationManager migrateStoreFromURL:storeURL
                                                 type:sourceStoreType
                                              options:nil
                                     withMappingModel:mappingModel
                                     toDestinationURL:newStoreURL
                                      destinationType:sourceStoreType
                                   destinationOptions:nil
                                                error:&error];
    if(!ok)
    {
        // Deal with error
        NSLog(@"Error migrating %@, %@", error, [error userInfo]);
        abort();
    }
    result = ok;
    
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
    
    
    return result;
}




+ (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end


