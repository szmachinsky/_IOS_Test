//
//  MainViewController.h
//  Test_Universal
//
//  Created by Sergei on 15.06.13.
//  Copyright (c) 2013 Sergei. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

- (IBAction)showInfo:(id)sender;

@end
