//
//  SZTaxiDetailViewController.m
//  TaxiTest
//
//  Created by Admin on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SZTaxiDetailViewController.h"
#import "DetailListCell.h"

#import "SZMTaxi.h"


@interface SZTaxiDetailViewController ()
- (void) pressButtonCall:(id)sender;
- (void) pressCellButtonCall:(id)sender;
@end

@implementation SZTaxiDetailViewController
{    
    __weak IBOutlet UIButton *buttonCall_;    
    __weak IBOutlet UILabel *labelShortNumber_;
    __weak IBOutlet UILabel *labelName_;
        
    __weak IBOutlet UITextView *textDescription_;    
    __weak IBOutlet UITableView *tableView_;
    
    __weak SZMTaxi *taxi_;
}
@synthesize taxi = taxi_;


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
    [buttonCall_ addTarget:self action:@selector(pressButtonCall:) forControlEvents:UIControlEventTouchUpInside];
    if (taxi_.shortNumber == nil)
        buttonCall_.enabled = NO;
    
    labelName_.text = taxi_.name;
    labelShortNumber_.text = taxi_.shortNumber;
    
    self.title = taxi_.name;
    
    NSString *desc = [NSString stringWithFormat:@"%@ / %@", taxi_.description, taxi_.tarifs];
    textDescription_.text = desc;

}

- (void)viewDidUnload
{
    buttonCall_ = nil;
    labelShortNumber_ = nil;
    labelName_ = nil;
    textDescription_ = nil;
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
    NSInteger res = [taxi_.operators count];
    return res;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    NSString *key = [taxi_.operators objectAtIndex:section];
    NSArray *arr = [taxi_.numbers objectForKey:key];
    NSInteger res = [arr count];
    return res;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    NSInteger count = [taxi_.operators count];
    if ((count > 0) && (count > section))
    {
        NSString *str = [taxi_.operators objectAtIndex:section];
        _NSLog(@">>%@",str);
        return str;
    } else {
        return nil;
    }    
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView 
//{ 
//    NSArray *res = [[NSMutableArray alloc] initWithObjects:@"Veclom", @"MTC", @"Life", nil];
//    return res;
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
////        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//// Configure the cell...
//    cell.textLabel.text = @"+375 29 123-45-45";
//    cell.textLabel.font = [UIFont boldSystemFontOfSize:12];//[UIFont fontWithName:<#(NSString *)#> size:<#(CGFloat)#>];
//    UIImage *im = [UIImage imageNamed:@"Phone_blink2"];
//    UIImage *i = [SZUtils thumbnailFromImage:im forSize:30 Radius:0.0];
//    cell.imageView.image = i;

    
    static NSString *CellIdentifier = @"DetailListCell";
    [tableView_ registerNib:[UINib nibWithNibName:@"DetailListCell" bundle:nil] 
     forCellReuseIdentifier:CellIdentifier];
    DetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];    
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.cellLabelNumber.text = @"+375 29 123-45-45";
    
    NSString *key = [taxi_.operators objectAtIndex:indexPath.section];
    NSArray *arr = [taxi_.numbers objectForKey:key];
    NSString *num = [arr objectAtIndex:indexPath.row];
    cell.cellLabelNumber.text = num;

    
    
    [cell.cellButtonCall addTarget:self action:@selector(pressCellButtonCall:) forControlEvents:UIControlEventTouchUpInside]; 
//    [cell.cellButtonCall setTitle:@"CALL" forState:UIControlStateNormal]; 
    //    cell.cellButtonCall.adjustsImageWhenHighlighted=NO;
    //    cell.cellButtonCall.highlighted = NO;
    cell.cellButtonCall.tag = (indexPath.section*100) + indexPath.row;    
    
    return cell;
}


//------------------------------------------------------------------------------
- (void) pressButtonCall:(id)sender
{
    NSString *num = taxi_.shortNumber;
    _NSLog(@" call pressed %@",num);
    if (num != nil) {
        _NSLog(@"  call with number (%@)",num);
        [SZUtils callToNumber:num];
    }
}

- (void) pressCellButtonCall:(id)sender
{
    UIButton *but = (UIButton*)sender;
    NSInteger tag = but.tag;
    NSInteger sec = tag / 100;
    NSInteger row = tag % 100;
    
    NSString *key = [taxi_.operators objectAtIndex:sec];
    NSArray *arr = [taxi_.numbers objectForKey:key];
    NSString *num = [arr objectAtIndex:row];
    
    NSLog(@" cell_call pressed %d  %d:%d (%@)",tag,sec,row,num);
    
    if (num != nil) {
        _NSLog(@"  call with number (%@)",num);
        [SZUtils callToNumber:num];
    }
 }




@end
