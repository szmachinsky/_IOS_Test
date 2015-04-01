//
//  MasterViewController.h
//  TestMigrator
//
//  Created by Zmachinsky Sergei on 01.04.15.
//  Copyright (c) 2015 Zmachinsky Sergei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end

