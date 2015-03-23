//
//  MasterViewController.m
//  Core_Test
//
//  Created by Zmachinsky Sergei on 05.03.15.
//  Copyright (c) 2015 Zmachinsky Sergei. All rights reserved.
//

#import "MasterViewController.h"
#import "Detail_VC.h"


@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
//    [self.tableView registerClass:[UITableViewCell class]   forCellReuseIdentifier:@"Cell"];
    
}

-(void)update
{
    if (_managedObjectContext)
        [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_managedObjectContext)
        [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    [self insertNewObjects:sender];
    return;
    
    
//    for (int i = 1; i <= 1; i++) {
//        @autoreleasepool {
//            NSLog(@"%04d)",i);
//            for (int j = 1; j <= 120; j++) { //30kb
//                [self insertNewObjects:sender];            
//            }
//            
//            [self saveContext];
//        }
//    }
    
}

- (void)insertNewObjects:(id)sender {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSError *error;
 
#if _CORE_CASE == 1
    
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:t_Stamp];
    
#if _CORE_VERSION == 3
    [newManagedObject setValue:@"3-detail1" forKey:@"detail_1"];
#endif
    
#if _CORE_VERSION == 4
    [newManagedObject setValue:@"4-detail1" forKey:@"detail_1"];
#endif

#if _CORE_VERSION == 5
    [newManagedObject setValue:@"5-detail1" forKey:@"detail_1"];
#endif
#endif //_CORE_CASE

    
//    [newManagedObject setValue:@"new detail2" forKey:@"detail_2"];
#if _CORE_VERSION == 4
    [newManagedObject setValue:@12 forKey:@"x"];
    [newManagedObject setValue:@15.5 forKey:@"f"];
#endif
    
    
#if _CORE_CASE == 2
    static int ind = 0;
    ind ++;
    
    NSManagedObject *newManagedObject1 = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
    
    [newManagedObject1 setValue:[NSDate date] forKey:t_Stamp];
    
    if (ind<=100) {
        [newManagedObject1 setValue:@"Name" forKey:@"fName"];
        [newManagedObject1 setValue:@"no" forKey:@"sName"];
    } else {
        [newManagedObject1 setValue:@"Name" forKey:@"fName"];
        [newManagedObject1 setValue:@"no" forKey:@"sName"];
        [newManagedObject1 setValue:@(99) forKey:@"age"];
        return;
    }
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *e = [NSEntityDescription entityForName:@"Sex" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:e];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"descr" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    NSArray *result = [context executeFetchRequest:request error:&error];
     if (result.count == 0)
    {
        NSManagedObject *newManagedObject3 = [NSEntityDescription insertNewObjectForEntityForName:@"Sex" inManagedObjectContext:context];
        [newManagedObject3 setValue:@"MEN" forKey:@"descr"];
        
        [newManagedObject1 setValue:newManagedObject3 forKey:@"sex"];
        
        NSSet *set = [newManagedObject3 valueForKey:@"people"];
        NSMutableSet *sett = [set mutableCopy];
        [sett addObject:newManagedObject1];
        [newManagedObject3 setValue:sett forKey:@"people"];
        
        
        
        newManagedObject3 = [NSEntityDescription insertNewObjectForEntityForName:@"Sex" inManagedObjectContext:context];
        [newManagedObject3 setValue:@"WIM" forKey:@"descr"];
        newManagedObject3 = [NSEntityDescription insertNewObjectForEntityForName:@"Sex" inManagedObjectContext:context];
        [newManagedObject3 setValue:@"UNI" forKey:@"descr"];        
    }
    if (result.count == 3) {
        int new_ind = (ind %3);
        NSManagedObject *newManagedObject4 = result[new_ind]; //0-men 2-wim 1-uni
        
        [newManagedObject1 setValue:newManagedObject4 forKey:@"sex"];
//        NSSet *set = [newManagedObject4 valueForKey:@"people"];
//        NSMutableSet *sett = [set mutableCopy];
        NSMutableSet *sett = [newManagedObject4 valueForKey:@"people"];
        [sett addObject:newManagedObject1];
        [newManagedObject4 setValue:sett forKey:@"people"];
        
        [newManagedObject1 setValue:@(25+new_ind) forKey:@"age"];
 
        [newManagedObject1 setValue:@"Name" forKey:@"fName"];
        [newManagedObject1 setValue:@"" forKey:@"sName"];
    }
    
    
    
#endif //_CORE_CASE
    
    
    
    // Save the context.
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    if (_managedObjectContext)
        [self.tableView reloadData];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!_managedObjectContext)
        return 0;
    
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_managedObjectContext)
        return 0;
    
   id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}
//===================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
//                                      reuseIdentifier:CellIdentifier];
//        
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath]; //get object
    
//  cell.textLabel.text = [[object valueForKey:t_Stamp] description];
    

#if _CORE_CASE == 1

    NSDate *date = [object valueForKey:t_Stamp];
    cell.textLabel.text = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    
    NSString *str1 = [object valueForKey:@"detail_1"];
    NSString *str2;
#if _CORE_VERSION >= 1
    str2 = [object valueForKey:@"detail_2"];
#endif
    NSString *str = [NSString stringWithFormat:@"(%@)(%@)",str1,str2];
    
#if _CORE_VERSION >= 4
    NSNumber *val1 = [object valueForKey:@"x"];
    NSNumber *val2 = [object valueForKey:@"f"];
    str = [NSString stringWithFormat:@"%@ %d %.1f",str,[val1 integerValue],[val2 floatValue]];
#endif
#if _CORE_VERSION == 5
    NSString *str3 = [object valueForKey:@"field"];
    str = [NSString stringWithFormat:@"%@ (%@)",str,str3];
#endif

#endif //_CORE_CASE
    
    
#if _CORE_CASE == 2
    NSString *str1 = [object valueForKey:@"fName"];
    NSString *str2 = [object valueForKey:@"sName"];
    NSNumber *num = [object valueForKey:@"age"];
    NSString *str3 = [num stringValue];
    NSString *nf;
    if ([str2 hasSuffix:@" ."]) {
        nf = [object valueForKey:@"newField"];
    }
    if (!nf)
        nf = @"";
    cell.textLabel.text = [NSString stringWithFormat:@"%@/%@/%@/%@",str1,str2,str3,nf];
    
    NSManagedObject *obj = [object valueForKey:@"sex"];
    NSString *str = [obj valueForKeyPath:@"descr"];
    NSMutableSet *set = [obj valueForKeyPath:@"people"];
    int i = set.count;
    str = [NSString stringWithFormat:@"%@ /all is %d",str,i];

#endif //_CORE_CASE
    
    
    cell.detailTextLabel.text = str;
}



#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    
    if (!_managedObjectContext)
        return nil;
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:CORE_ENTITY1 inManagedObjectContext:self.managedObjectContext]; //"Event"
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:t_Stamp ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil]; //@"Master"
    
    
//    [aFetchedResultsController cacheName]
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Detail_VC* detail = [[Detail_VC alloc] init];
    
    NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    detail.detailItem = selectedObject;
    detail.delegate = self;
    [self.navigationController pushViewController:detail animated:YES];
}


- (void)saveContext {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.tableView reloadData];
}


@end
