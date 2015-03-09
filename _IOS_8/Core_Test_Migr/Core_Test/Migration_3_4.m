//
//  Migration_3_4.m
//  Core_Test
//
//  Created by Zmachinsky Sergei on 09.03.15.
//  Copyright (c) 2015 Zmachinsky Sergei. All rights reserved.
//

#import "Migration_3_4.h"

@implementation Migration_3_4


- (BOOL)createDestinationInstancesForSourceInstance:(NSManagedObject *)sInstance entityMapping:(NSEntityMapping *)mapping manager:(NSMigrationManager *)manager error:(NSError **)error
{
    // Create the ellipse managed object
    NSManagedObject *newObj = [NSEntityDescription insertNewObjectForEntityForName:[mapping destinationEntityName] inManagedObjectContext:[manager destinationContext]];
    
    NSString *str = [NSString stringWithFormat:@"N1:%@",[sInstance valueForKey:@"detail_1"]];
    [newObj setValue:str forKey:@"detail_1"];
    str = [NSString stringWithFormat:@"N2:%@",[sInstance valueForKey:@"detail_2"]];
    [newObj setValue:str forKey:@"detail_2"];
    [newObj setValue:[sInstance valueForKey:@"when"] forKey:@"when"];
    
    // new values
    [newObj setValue:@20.f forKey:@"f"];
//  [newObj setValue:@3456 forKey:@"x"];
    
    // Set up the association between the Circle and the Ellipse for the migration manager
    [manager associateSourceInstance:sInstance withDestinationInstance:newObj forEntityMapping:mapping];
    return YES;
}

@end
