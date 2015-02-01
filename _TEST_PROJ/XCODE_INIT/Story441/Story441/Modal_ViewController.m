//
//  Modal_ViewController.m
//  Story441
//
//  Created by Sergei on 23.10.14.
//  Copyright (c) 2014 Sergei. All rights reserved.
//

#import "Modal_ViewController.h"

@interface Modal_ViewController ()

@end

@implementation Modal_ViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)dismissCont:(id)sender
{
//  [[self presentingViewController] dismissViewControllerAnimated:YES
//                                                        completion:nil];
    [self  dismissViewControllerAnimated:YES completion:nil];
}

@end
