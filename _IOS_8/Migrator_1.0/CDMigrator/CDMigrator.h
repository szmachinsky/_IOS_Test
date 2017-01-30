//
//  CDMirgaror.h  
//
//  Created by Zmachinsky Sergei on 18.03.15.
//  Copyright (c) 2015 Zmachinsky Sergei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CDMigrator : NSObject

+(instancetype)sharedMigrator;

-(instancetype)init;

@property (nonatomic, strong) NSArray *modelsList;

@property (nonatomic, copy) void (^initHud)();
@property (nonatomic, copy) void (^dismissHud)();
@property (nonatomic, copy) void (^progressHud)(float);

@property (nonatomic, copy) BOOL (^checkAfterMigration)(NSManagedObjectContext *context);


@property (nonatomic, unsafe_unretained) BOOL useOnlyDirectLightMigration;

@property (nonatomic, strong) dispatch_queue_t asyncQueue;
@property (nonatomic, strong) Class migrationClass;

@property (nonatomic, strong) NSURL *modelsUrl;


-(void)migrationFor:(NSURL *)storeURL
               modelName:(NSString *)modelName
              completion:(void (^)(BOOL))completion;



@end

