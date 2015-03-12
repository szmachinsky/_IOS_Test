//
//  Migration_4_5.m
//  Core_Test
//
//  Created by Zmachinsky Sergei on 12.03.15.
//  Copyright (c) 2015 Zmachinsky Sergei. All rights reserved.
//

#import "Migration_4_5.h"

@implementation Migration_4_5


- (BOOL)createDestinationInstancesForSourceInstance:(NSManagedObject *)sInstance entityMapping:(NSEntityMapping *)mapping manager:(NSMigrationManager *)manager error:(NSError **)error
{
    // Create the ellipse managed object
    NSManagedObject *newObj = [NSEntityDescription insertNewObjectForEntityForName:[mapping destinationEntityName] inManagedObjectContext:[manager destinationContext]];
    
    NSLog(@"__run_migr_polisy 4->5");
    
    NSString *str = [NSString stringWithFormat:@"4->5 :%@",[sInstance valueForKey:@"detail_1"]];
    [newObj setValue:str forKey:@"detail_1"];
    
    str = [NSString stringWithFormat:@"4->5 :%@",[sInstance valueForKey:@"detail_2"]];
    [newObj setValue:str forKey:@"detail_2"];
    
    [newObj setValue:[sInstance valueForKey:@"when"] forKey:@"when"];
    [newObj setValue:@"4->5 field" forKey:@"field"];
    
    // new values
    [newObj setValue:@26.f forKey:@"f"];
    //  [newObj setValue:@3456 forKey:@"x"];
    
    // Set up the association between the Circle and the Ellipse for the migration manager
    [manager associateSourceInstance:sInstance withDestinationInstance:newObj forEntityMapping:mapping];
    return YES;
}

@end
