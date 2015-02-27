//
//  MasterViewController.m
//  test_nav_xib
//
//  Created by Sergei on 19.10.14.
//  Copyright (c) 2014 Sergei. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "Test1_VC.h"
#import "Test2_VC.h"
#import "Test3_VC.h"
#import "TstNew1_VC.h"
#import "TstNew2_VC.h"

#import "LoadFiles_VC.h"
#import "YandexTest_VC.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
    NSInteger def_rows;
}
@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    def_rows = 6;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
//    NSLog(@"test - NSLog");
//    _NSLog(@"test - _NSLog");
//    _NSLog0(@"test - _NSLog0");
//    printf("test1 %d\n",def_rows);
//    printf("test2 %d\n",def_rows);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    NSInteger col = _objects.count; //0
    
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
//    [_objects insertObject:[NSDate date] atIndex:0];
    [_objects addObject:[NSDate date]];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:def_rows+col inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];//UITableViewRowAnimationAutomatic];
//    [self.tableView reloadData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger col = def_rows + _objects.count;
//    NSLog(@"row count = %ld",(long)col);
    return (def_rows + _objects.count);
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = @"...";

    NSDate *object;
    NSInteger ind = indexPath.row;
    NSLog(@">>got cell_%ld",(long)ind);
    switch (ind) {
        case 0:
            cell.textLabel.text = @"Test1_VC - Dealloc";
            NSLog(@"-----%@-----",cell.textLabel.text);
            break;
        case 1:
            cell.textLabel.text = @"Test2_VC - Act Sheet";
            NSLog(@"-----%@-----",cell.textLabel.text);
            break;
        case 2:
            cell.textLabel.text = @"Test3_VC";
            NSLog(@"-----%@-----",cell.textLabel.text);
            break;
            
        case 3:
            cell.textLabel.text = @"LoadFiles_VC";
            NSLog(@"-----%@-----",cell.textLabel.text);
            break;
        case 4:
            cell.textLabel.text = @"YANDEX_TEST";
            NSLog(@"-----%@-----",cell.textLabel.text);
            break;
            
        case 5:
            cell.textLabel.text = @"NEW_1_2";
            NSLog(@"-----%@-----",cell.textLabel.text);
            [self performSelector:@selector(delayed) withObject:nil afterDelay:1.0];
            break;
            
        default:
            object = _objects[ind - def_rows];
            cell.textLabel.text = [object description];
            NSLog(@"--%@--",cell.textLabel.text);
            break;
    }
    
    cell.textLabel.alpha = 0.1;
    [UIView animateWithDuration:2.0
                     animations:^{
                         NSLog(@"anim beg");
                         cell.textLabel.alpha = 0.9;
                     } completion:^(BOOL finished) {
                         NSLog(@"%d %f",finished,cell.textLabel.alpha);
                     }];
    

    NSLog(@"cell end");
    
    return cell;
}
 -(void)delayed
{
    NSLog(@"del");
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        Test1_VC *vc = [[Test1_VC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 1) {
        Test2_VC *vc = [[Test2_VC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 2) {
        Test3_VC *vc = [[Test3_VC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 3) {
        LoadFiles_VC *vc = [[LoadFiles_VC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 4) {
        YandexTest_VC *vc = [[YandexTest_VC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 5) {
        TstNew1_VC *vc = [[TstNew1_VC alloc] init];
//        TstNew2_VC *vc = [[TstNew2_VC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
  
    if (indexPath.row > 5) {
        if (!self.detailViewController) {
            self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        }
        NSDate *object = _objects[indexPath.row - def_rows];
        self.detailViewController.detailItem = object;
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    }
    
    
}

@end
