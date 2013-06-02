//
//  FlipsideViewController.m
//  Util_App
//
//  Created by Sergei on 02.06.13.
//  Copyright (c) 2013 Sergei. All rights reserved.
//

#import "FlipsideViewController.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.iInt = 2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    NSLog(@">>flipside_dismiss %d %d",self.iInt,_iInt);
    [self.delegate flipsideViewControllerDidFinish:self];
//    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    
//    [self.parentViewController dismissModalViewControllerAnimated:YES];
//    [self dismissModalViewControllerAnimated:YES];
    
//    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
