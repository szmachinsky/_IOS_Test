//
//  TestViewController.m
//  VoterTest
//
//  Created by User on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestViewController.h"

@implementation TestViewController

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [view1 release];
    view1 = nil;
    [view2 release];
    view2 = nil;
    [view3 release];
    view3 = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (IBAction)pressButton1:(id)sender {
    NSLog(@"press 1"); 
    self.view = view1;
}

- (IBAction)pressButton2:(id)sender {
    NSLog(@"press 2");    
    self.view = view2;
}

- (IBAction)pressButton3:(id)sender {
    NSLog(@"press 3");    
    self.view = view3;
}

- (void)dealloc {
    [view1 release];
    [view2 release];
    [view3 release];
    [super dealloc];
}
@end
