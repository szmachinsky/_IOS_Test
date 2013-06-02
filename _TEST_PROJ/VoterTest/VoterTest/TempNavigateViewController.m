//
//  TempNavigateViewController.m
//  VoterTest
//
//  Created by User User on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TempNavigateViewController.h"

@implementation TempNavigateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil rootViewController:(UIViewController*)controller
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        controller_ = controller;
 //       navigation_ = [[UINavigationController alloc] init];
//        navigation_ = [[UINavigationController alloc] initWithRootViewController:controller];
//        [self.view addSubview:navigation_.view];
//        [self.view addSubview:self.navigationController.view];
        
//      NSLog(@"%.0f %.0f",self.view.frame.size.height,self.view.frame.origin.y);
 //     NSLog(@"%.0f %.0f",navigation_.view.frame.size.height,navigation_.view.frame.origin.y);
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
//    navigation_ = [[UINavigationController alloc] initWithRootViewController:controller_];
//    controller_.navigationItem.title = @"temp Controller";
//    navigation_.title = @"temp Controller";
//    [self.view addSubview:navigation_.view];
//    [self.navigationController pushViewController:controller_ animated:YES];  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [super dealloc];
}
@end
