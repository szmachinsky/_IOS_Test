
//
//  FCViewController.m
//  VoterTest
//
//  Created by svp on 01.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FCViewController.h"


@interface FCViewController ()

@end

//static NSString* kAppId = @"331663473546996";

@implementation FCViewController
//@synthesize facebook = facebook_;
@synthesize fbSession = fbSession_;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"---dealloc FCView");
#endif
    
    [buttonBack release];
    [buttonFC release];
    
    [buttonInfo release];
    
    [fbSession_ release];
    [super dealloc];
}

#pragma mark - View lifecycle


- (void)viewDidUnload
{
    [buttonBack release];
    buttonBack = nil;
    [buttonFC release];
    buttonFC = nil;
    [buttonInfo release];
    buttonInfo = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



#pragma mark - delegate for FaceBookSeccion
//===============================================================================
- (void)fbDidLogin:(NSString*)token expDate:(NSDate*)date 
{
#ifdef DEBUG
    NSLog(@"-delegate:token:%@",token);
    NSLog(@"-delegate:date:%@",date);    
#endif
    [fbSession_ facebookGetInfo];    
}

- (void)fbDidLogin:(NSString*)token expDate:(NSDate*)date withInfo:(NSMutableDictionary*)result 
{
    NSString *email = [result valueForKey:@"email"];
    NSString *name = [result valueForKey:@"name"];    
#ifdef DEBUG
    NSLog(@"delegate:token:%@",token);
    NSLog(@"delegate:date:%@",date);   
    NSLog(@"(%@)(%@)",email,name);     
#endif
//    self.username = name;
//    self.email = email;
//    [infoTableView_ reloadData];
}


//===============================================================================

- (IBAction)pressBack:(id)sender {
    [fbSession_ facebookLogout];
    [self dismissModalViewControllerAnimated:YES];    
}

- (IBAction)pressFC:(id)sender {
    if (!fbSession_)
        fbSession_ = [[FBSession alloc] initWithDelegate:self];
    [fbSession_ facebookLogin];            
}

- (IBAction)pressGetInfo:(id)sender {
//    [facebook_ requestWithGraphPath:@"me" andDelegate:self];
    [fbSession_ facebookGetInfo];
}

@end
