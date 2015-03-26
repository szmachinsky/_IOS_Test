//
//  MyMirgaror.h
//  Core_Test
//
//  Created by Zmachinsky Sergei on 18.03.15.
//  Copyright (c) 2015 Zmachinsky Sergei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDMigrator : NSObject

+(instancetype)sharedMigrator;

-(instancetype)init;

@property (nonatomic, strong) NSMutableArray *models;

@property (nonatomic, copy) void (^initHud)();
@property (nonatomic, copy) void (^dismissHud)();
@property (nonatomic, copy) void (^progressHud)(float);


-(BOOL)checkMigrationFor:(NSURL *)storeURL 
              asyncQueue:(dispatch_queue_t)queue
               modelName:(NSString *)modelName
                  ofType:(NSString *)sourceStoreType
          lightMigration:(BOOL)lightMigration
          migrationClass:(Class)migrationClass
              completion:(void (^)(BOOL))completion;


-(BOOL)checkMigrationFor:(NSURL *)storeURL
               modelName:(NSString *)modelName
                  ofType:(NSString *)sourceStoreType
          lightMigration:(BOOL)lightMigration
          migrationClass:(Class)migrationClass
              completion:(void (^)(BOOL))completion;


- (BOOL)migrateURL:(NSURL *)storeURL
    migrationClass:(Class)migrationClass
            ofType:(NSString *)sourceStoreType
         fromModel:(NSManagedObjectModel *)sourceModel
           toModel:(NSManagedObjectModel *)destinationModel
      mappingModel:(NSMappingModel *)mappingModel
            offset:(float)offset
             range:(float)range
        completion:(void (^)(BOOL))completion;


@end

