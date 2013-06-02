//
//  TestScrollController.m
//  VoterTest
//
//  Created by User User on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestScrollController.h"

#define kViewSize 120


@implementation TestScrollController


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
    
    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 2, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    

    [scrollView addSubview:view1_];
    shiftXPos_ = view1_.frame.size.width;
    
    CGRect frame = scrollView.frame;
    frame.origin.x = shiftXPos_;
    frame.origin.y = 0;
    view2_.frame = frame;
    [scrollView addSubview:view2_];
    
    [self switchPage:nil];
}

- (void)viewDidUnload
{
    [scrollView release];
    scrollView = nil;
    [view1_ release];
    view1_ = nil;

    [view2_ release];
    view2_ = nil;
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
    [scrollView release];
    [view1_ release];

    [view2_ release];
    [super dealloc];
}


- (IBAction)switchPage:(id)sender {
    NSLog(@"--press");
// update the scroll view to the appropriate page
    
    currentPage_ = (++currentPage_ %2);
    CGRect frame = scrollView.frame;
    if (currentPage_ == 0)
    {    
        frame.origin.x = 0; 
    } else {
        frame.origin.x = shiftXPos_;
    }
    [scrollView scrollRectToVisible:frame animated:YES];    
}
@end
