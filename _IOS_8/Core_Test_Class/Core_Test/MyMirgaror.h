//
//  MyMirgaror.h
//  Core_Test
//
//  Created by Zmachinsky Sergei on 18.03.15.
//  Copyright (c) 2015 Zmachinsky Sergei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyMirgaror : NSObject

+(instancetype)sharedMigrator;

-(instancetype)init;

@property (nonatomic, copy) void (^initHud)();
@property (nonatomic, copy) void (^progressHud)(float);


-(BOOL)checkMigrationFor:(NSURL *)storeURL
               modelName:(NSString *)modelName
                  ofType:(NSString *)sourceStoreType
          lightMigration:(BOOL)lightMigration
              completion: (void (^)(BOOL))completion;


- (BOOL)migrateURL:(NSURL *)storeURL
    migrationClass:(Class)migrationClass
            ofType:(NSString *)sourceStoreType
         fromModel:(NSManagedObjectModel *)sourceModel
           toModel:(NSManagedObjectModel *)destinationModel
      mappingModel:(NSMappingModel *)mappingModel
            offset:(float)offset
             range:(float)range
        completion: (void (^)(BOOL))completion;


@end

