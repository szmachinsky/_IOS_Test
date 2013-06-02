//
//  SZOptionsViewController.m
//  TaxiTest
//
//  Created by Admin on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SZOptionsViewController.h"
#import "SZPlaceViewController.h"

#import "LabelSwitchCell.h"
#import "LabelTextCell.h"

@interface SZOptionsViewController ()
- (void) switchValueChanged:(id)sender;
- (void) pressButtonNumberDone:(id)sender;
@end

@implementation SZOptionsViewController
{    
    __weak IBOutlet UITableView *tableView_;
    BOOL showHandDetectionCell;
    __unsafe_unretained UITextField *editText_;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        showHandDetectionCell = ![SZAppInfo sharedInstance].autoDetection;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Настройки";
}

- (void)viewDidUnload
{
    tableView_ = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    showHandDetectionCell = ![SZAppInfo sharedInstance].autoDetection;
    
    [tableView_ reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
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
            if (showHandDetectionCell) {
                return 2;
            } else {
                return 1;
            };            
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 0;
            break;            
    } 
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    switch (section) {
        case 0:
            return @"Местоположение";
            break;
        case 1:
            return @"Контакты";
            break;
        case 2:
            return @"Прочие опции";
            break;            
        default:
            break;
    } 
    return nil;
}

-(void)reloadTable
{
    [tableView_ reloadData];    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"LabelSwitchCell";
            [tableView_ registerNib:[UINib nibWithNibName:@"LabelSwitchCell" bundle:nil] 
             forCellReuseIdentifier:CellIdentifier];
            LabelSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];                
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.switchAutoDetect.on = [SZAppInfo sharedInstance].autoDetection;
            if ([SZAppInfo sharedInstance].autoDetection) {
                cell.labelPosition.text = @" хз где я";
            } else {
                cell.labelPosition.text = nil;                
            }
            [cell.switchAutoDetect addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        
            return cell;
        }
        
        if (indexPath.row == 1) {
            static NSString *CellIdentifier = @"CellDetection";
            UITableViewCell *ncell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (ncell == nil) {
                ncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                ncell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//              ncell.accessoryType = UITableViewCellAccessoryNone;
                ncell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            // Configure the cell...
            ncell.textLabel.text = @"Ручной выбор";
            ncell.textLabel.font = [UIFont systemFontOfSize:17];
            return ncell;
        
        }
        
        
    }

    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"LabelTextCell";
            [tableView_ registerNib:[UINib nibWithNibName:@"LabelTextCell" bundle:nil] 
             forCellReuseIdentifier:CellIdentifier];
            LabelTextCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];                
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textNumber.delegate = self;
            editText_ = cell.textNumber;
            [cell.buttonNumberDone addTarget:self action:@selector(pressButtonNumberDone:) forControlEvents:UIControlEventTouchUpInside]; 
                        
            return cell;
        }
    }
    
    
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *ncell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (ncell == nil) {
        ncell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//      ncell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        ncell.accessoryType = UITableViewCellAccessoryNone;
        ncell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
// Configure the cell...
    ncell.textLabel.text = @"info";
    ncell.textLabel.font = [UIFont boldSystemFontOfSize:12];
    return ncell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 0) && (indexPath.row == 1)) {
        SZPlaceViewController *controller = [[SZPlaceViewController alloc] initWithNibName:@"SZPlaceViewController" bundle:nil]; 
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}


//------------------------------------------------------------------------------
- (void)deleteRow
{
    NSArray *deleteIndexPaths = [NSArray arrayWithObjects:
                                    [NSIndexPath indexPathForRow:1 inSection:0], nil];
    [tableView_ beginUpdates];
    [tableView_ deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    [tableView_ endUpdates]; 
    
//    [tableView_ reloadData];
}

- (void)insertRow
{
    NSArray *insertIndexPaths = [NSArray arrayWithObjects:
                                 [NSIndexPath indexPathForRow:1 inSection:0], nil];
    [tableView_ beginUpdates];
    [tableView_ insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    [tableView_ endUpdates];    
    
}

//------------------------------------------------------------------------------
- (void) switchValueChanged:(id)sender
{
    UISwitch *sw = (UISwitch*)sender;
    BOOL state = sw.on;
    _NSLog(@" switch is %d",state);
    [SZAppInfo sharedInstance].autoDetection = state;
    showHandDetectionCell = ![SZAppInfo sharedInstance].autoDetection;
        
    if (!showHandDetectionCell) {
        [self deleteRow];
    } else {
        [self insertRow];
    }
    
//    [tableView_ reloadData];
    [self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.5];
}

//------------------------------------------------------------------------------

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSString *num = textField.text;
    _NSLog(@" input (%@)",num);
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSString *str = textField.text;
    if ([str length] == 0) {
        textField.text = @"+375";  
    }
    return  YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _NSLog(@" (%d %d) (%@)",range.location,range.length,string);  
    if (range.location ==0)
        return NO;
    if (range.location > 12)
        return NO;
    return  YES;
}

- (void) pressButtonNumberDone:(id)sender
{
//    UIButton *but = (UIButton*)sender;
//    NSInteger tag = but.tag;
    NSString *str = editText_.text;
    [editText_ resignFirstResponder];    
    _NSLog(@" done button pressed (%@)",str);    
}



@end
