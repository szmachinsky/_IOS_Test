//
//  SZPlaceViewController.m
//  TaxiTest
//
//  Created by Admin on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SZPlaceViewController.h"

@interface SZPlaceViewController ()

@end

@implementation SZPlaceViewController
{
    __weak IBOutlet UITableView *tableView_;
    NSIndexPath *indexChecked_;
    NSString *cityChecked_;
    NSString *sectionChecked_;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        indexChecked_ = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Выбор региона";
}

- (void)viewDidUnload
{
    tableView_ = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//------------------------------------------------------------------------------
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    switch (section) {
        case 0:
            return 3;       
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;            
    } 
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    switch (section) {
        case 0:
            return @"Минская область";
            break;
        case 1:
            return @"Могилевская область";
            break;
        case 2:
            return @"Брестская область";
            break;            
        default:
            break;
    } 
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.textLabel.text = nil;
    
    // Configure the cell...
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Минск";
                break;
            case 1:
                cell.textLabel.text = @"Молодечно";
                break;
            case 2:
                cell.textLabel.text = @"Слуцк";
                break;                
            default:
                break;
        }
    }
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Могилев";
                break;
           default:
                break;
        }
    }
    
    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Брест";
                break;
            default:
                break;
        }
    }
    
    if ([indexPath isEqual:indexChecked_]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cityChecked_ = cell.textLabel.text;
        sectionChecked_ = [self tableView:tableView titleForHeaderInSection:indexPath.section];
        _NSLog(@"(%@) (%@)",cityChecked_,sectionChecked_);
        [SZAppInfo sharedInstance].regionName = sectionChecked_;
        [SZAppInfo sharedInstance].cityName = cityChecked_;
        
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    return cell;    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexChecked_ = indexPath;
    [tableView_ reloadData];
}


@end
