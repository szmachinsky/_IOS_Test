//
//  CallListViewController.m
//  TaxiTest
//
//  Created by Admin on 05.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SZCallListViewController.h"
#import "TaxiListCell.h"
#import "SZTaxiDetailViewController.h"

#import "SZMCountry.h"
#import "SZMRegion.h"
#import "SZMCity.h"
#import "SZMTaxi.h"


@interface SZCallListViewController ()
- (void) pressButtonCall:(id)sender;
- (void) pressButtonInfo:(id)sender;
@end

@implementation SZCallListViewController 
{    
    __weak IBOutlet UITableView *tableView_; 
    SZMCity *city_;
    NSArray *list_;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = @"Минск";
    
    city_ = nil;//[SZMCity addCity1];
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
    
    city_ = nil;
    list_ = nil;
    
    NSString *nreg = [SZAppInfo sharedInstance].regionName;
    NSString *nsit = [SZAppInfo sharedInstance].cityName;
    SZMRegion *reg = nil;
    
    NSArray *arr1 = [SZAppInfo sharedInstance].model.listRegion;
    //    _NSLog(@"%@",arr1);
    for (SZMRegion *rg in arr1) {
        if ([rg.name isEqual:nreg]) {
            reg = rg;
            break;
        }
    }
    NSArray *arr2 = reg.listCity;
    for (SZMCity *cit in arr2) {
        if ([cit.name isEqual:nsit]) {
            city_ = cit;
            break;
        }
    }
    if (city_ != nil) {
        _NSLog(@"found (%@) (%@)",nreg,nsit);
        list_ = city_.listTaxi;
        _NSLog(@" found %d taxi",[list_ count]);
    } else {
        
    }
    self.navigationItem.title = nsit;
    
//    NSArray *arcity = [[SZAppInfo sharedInstance].model valueForKeyPath:@"listRegion.listCity.name"];
////    _NSLog(@">>%@",arcity);
//    for (NSString *str in arcity) {
//        _NSLog(@">>%@",str);        
//    }
    
    
    [tableView_ reloadData];    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



//------------------------------------------------------------------------------
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [list_ count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
////        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
    // Configure the cell...
//    cell.textLabel.text = @"call taxi";
    
//    TaxiListCell *cell = (TaxiListCell*)[tableView dequeueReusableCellWithIdentifier:@"TaxiListCell"];
//    if (cell == nil) 
//    {
//        NSArray* loadedViews = [[NSBundle mainBundle] loadNibNamed:@"TaxiListCell" owner:self options:nil];
//        for (UIView* aCell in loadedViews)
//        {
//            if ([aCell isMemberOfClass:[TaxiListCell class]])
//            {
//                cell = (TaxiListCell*) aCell; break;
//            }                
//        }            
//    }    
    
    static NSString *CellIdentifier = @"TaxiListCell";
    [tableView_ registerNib:[UINib nibWithNibName:@"TaxiListCell" bundle:nil] 
         forCellReuseIdentifier:CellIdentifier];
    TaxiListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];    
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    SZMTaxi *taxi = [list_ objectAtIndex:indexPath.row];
    
    cell.cellLabelName.text = taxi.name;
    cell.cellLabelShortNumber.text = taxi.shortNumber;

    [cell.cellButtonCall addTarget:self action:@selector(pressButtonCall:) forControlEvents:UIControlEventTouchUpInside]; 
    if (taxi.shortNumber == nil)
        cell.cellButtonCall.enabled = NO;
    
//    [cell.cellButtonCall setTitle:@"CALL" forState:UIControlStateNormal]; 
//    cell.cellButtonCall.adjustsImageWhenHighlighted=NO;
//    cell.cellButtonCall.highlighted = NO;
    cell.cellButtonCall.tag = indexPath.row;
    cell.cellButtonInfo.tintColor = [UIColor greenColor];

    [cell.cellButtonInfo addTarget:self action:@selector(pressButtonInfo:) forControlEvents:UIControlEventTouchUpInside]; 
    cell.cellButtonInfo.tag = indexPath.row;
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SZTaxiDetailViewController *controller = [[SZTaxiDetailViewController alloc] initWithNibName:@"SZTaxiDetailViewController" bundle:nil]; 
    controller.hidesBottomBarWhenPushed = YES;
    controller.taxi = [list_ objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}


//------------------------------------------------------------------------------
- (void) pressButtonCall:(id)sender
{
    UIButton *but = (UIButton*)sender;
    NSInteger tag = but.tag;
    NSLog(@" call pressed %d",tag);
    
    SZMTaxi *taxi = [list_ objectAtIndex:tag];
    NSString *num = taxi.shortNumber;
    
    if (num != nil) {
        _NSLog(@"  call with number (%@)",num);
        [SZUtils callToNumber:num];
    }    
  
}

- (void) pressButtonInfo:(id)sender
{
    UIButton *but = (UIButton*)sender;
    NSInteger tag = but.tag;
    NSLog(@" info pressed %d",tag);    
}


@end
