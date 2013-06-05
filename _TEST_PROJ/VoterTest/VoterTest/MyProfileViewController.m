//
//  MyProfileViewController.m
//  VoterTest
//
//  Created by User User on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyProfileViewController.h"

#define kShiftPos 220

@implementation MyProfileViewController


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

- (void)viewDidUnload
{
    
    [topView_ release];
    topView_ = nil;
    
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
//  int ret = topView_.retainCount;    
    [topView_ release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view addSubview:topView_]; //add view on top of window
    currentPage_ = 1;
}




- (IBAction)pressBack:(id)sender {
    NSLog(@" press Back");    
    [self dismissModalViewControllerAnimated:YES];        
}

- (IBAction)pressButton:(id)sender {
    NSLog(@" press button"); 
        
    currentPage_ = (++currentPage_ %2);
    CGRect frame = topView_.frame;
    
    if (currentPage_ == 1)
    {    
        frame.origin.x = 0; 
    } else {
        frame.origin.x = kShiftPos;
    }
    
/*    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];    
    topView_.frame = frame;    
    [UIView commitAnimations];
*/    
   
/*    
    [UIView transitionWithView:self.view duration:0.5
                       options:UIViewAnimationOptionOverrideInheritedCurve //UIViewAnimationOptionLayoutSubviews
                    animations:^{ topView_.frame = frame;  }     
                    completion:NULL]; 
*/
/*   
 
    [UIView animateWithDuration:<#(NSTimeInterval)#> delay:<#(NSTimeInterval)#> options:<#(UIViewAnimationOptions)#> animations:<#^(void)animations#> completion:<#^(BOOL finished)completion#>
*/  
    
    [UIView animateWithDuration:0.5 animations:^{topView_.frame = frame;}];
}


@end
