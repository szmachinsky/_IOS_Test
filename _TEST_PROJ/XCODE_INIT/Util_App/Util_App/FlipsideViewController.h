//
//  FlipsideViewController.h
//  Util_App
//
//  Created by Sergei on 02.06.13.
//  Copyright (c) 2013 Sergei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;
@property (unsafe_unretained, nonatomic) NSInteger iInt;

- (IBAction)done:(id)sender;

@end
