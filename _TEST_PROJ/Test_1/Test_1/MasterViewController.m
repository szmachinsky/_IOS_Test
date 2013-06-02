//
//  MasterViewController.m
//  Test_1
//
//  Created by svp on 25.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"


@implementation MasterViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"!-Master_didReceiveMemoryWarning");   
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"Master";
//    self.tableView.allowsSelection = NO;
//    self.tableView.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
    //return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Retain Count Test";
            break;
        case 1:
            cell.textLabel.text = @"Accelerometr";
            break;
        case 2:
            cell.textLabel.text = @"Gestures";
            break;
        case 3:
            cell.textLabel.text = @"Animation";
            break;
        case 4:
            cell.textLabel.text = @"Save Load";
            break;
        case 5:
            cell.textLabel.text = @"Property";
            break;
        case 6:
            cell.textLabel.text = @"Blocks";
            break;
            
        case 7:
            cell.textLabel.text = @"Threads";
            break;
            
        case 8:
            cell.textLabel.text = @"WebTest";
            break;
            
        case 9:
            cell.textLabel.text = @"";
            break;
            
        case 10:
            cell.textLabel.text = @"";
            break;
           
        default:
            break;
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) 
    {
        case 0:
            if (!testCountViewController_)
                testCountViewController_ = [[TestCountViewController alloc] initWithNibName:@"TestCountViewController" bundle:nil];             
//            testCountViewController_.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//            testCountViewController_.modalTransitionStyle = UIModalTransitionStylePartialCurl;
//            testCountViewController_.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            testCountViewController_.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
///         testCountViewController_.modalPresentationStyle = 
            [self presentModalViewController:testCountViewController_ animated:YES]; 
            
//            [self.navigationController pushViewController:testCountViewController_ animated:YES];
            
//            [testCountViewController_ release];
//            testCountViewController_ = nil;
                
            break;
            
        case 1:
            if (!accelerometerViewController_)
                accelerometerViewController_ = [[AccelerometerViewController alloc] initWithNibName:@"AccelerometerViewController" bundle:nil];             
            [self.navigationController pushViewController:accelerometerViewController_ animated:YES];            
            [accelerometerViewController_ release];
            accelerometerViewController_ = nil;            
            break;

        case 2:
            if (!gesturesViewController_)
                gesturesViewController_ = [[GesturesViewController alloc] initWithNibName:@"GesturesViewController" bundle:nil];             
            [self.navigationController pushViewController:gesturesViewController_ animated:YES];            
            [gesturesViewController_ release];
            gesturesViewController_ = nil;            
            break;
            
        case 3:
            if (!animationViewController_)
                animationViewController_ = [[AnimationViewController alloc] initWithNibName:@"AnimationViewController" bundle:nil];             
            [self.navigationController pushViewController:animationViewController_ animated:YES];            
            [animationViewController_ release];
            animationViewController_ = nil;            
            break;            
           
        case 4:
            if (!saveLoadViewController_)
                saveLoadViewController_ = [[SaveLoadViewController alloc] initWithNibName:@"SaveLoadViewController" bundle:nil];             
            [self.navigationController pushViewController:saveLoadViewController_ animated:YES];            
            [saveLoadViewController_ release];
            saveLoadViewController_ = nil;            
            break;            
            
        case 5:
            if (!propertyViewController_)
                propertyViewController_ = [[PropertyViewController alloc] initWithNibName:@"PropertyViewController" bundle:nil];             
            propertyViewController_.str = @"extern string";
            [self.navigationController pushViewController:propertyViewController_ animated:YES]; 
//          propertyViewController_.str = @"extern string";
//          [propertyViewController_ release]; propertyViewController_ = nil;            
            break;  
            
        case 6:
            if (!blockViewController_)
                blockViewController_ = [[BlockViewController alloc] initWithNibName:@"BlockViewController" bundle:nil];             
            [self.navigationController pushViewController:blockViewController_ animated:YES];            
            [blockViewController_ release];
            blockViewController_ = nil;            
            break;            
            
        case 7:
            if (!threadViewController_)
                threadViewController_ = [[ThreadViewController alloc] initWithNibName:@"ThreadViewController" bundle:nil];             
            [self.navigationController pushViewController:threadViewController_ animated:YES];            
            [threadViewController_ release];
            threadViewController_ = nil;            
            break;

        case 8:
            if (!webViewController_)
                webViewController_ = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];             
            [self.navigationController pushViewController:webViewController_ animated:YES];            
            [webViewController_ release];
            webViewController_ = nil;            
            break;

            
            
    } //switch
    
}

@end
