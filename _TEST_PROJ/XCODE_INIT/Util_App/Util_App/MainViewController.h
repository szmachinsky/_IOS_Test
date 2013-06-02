//
//  MainViewController.h
//  Util_App
//
//  Created by Sergei on 02.06.13.
//  Copyright (c) 2013 Sergei. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>

@property (unsafe_unretained, nonatomic) NSInteger iInt;

- (IBAction)showInfo:(id)sender;

@end
