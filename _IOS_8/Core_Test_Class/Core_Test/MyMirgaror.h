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


@property (nonatomic, copy) void (^initHud)();
@property (nonatomic, copy) void (^progressHud)(float, NSString*);


-(BOOL)checkMigrationFor:(NSURL *)storeURL
               modelName:(NSString *)modelName
                  ofType:(NSString *)sourceStoreType
          lightMigration:(BOOL)lightMigration
              completion: (void (^)(BOOL ok))completion
                 initHud:(void (^)())initHud
             progressHud:(void (^)(float, NSString*))progressHud;




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



@end

