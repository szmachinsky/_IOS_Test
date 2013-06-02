//
//  MasterViewController.h
//  Test_3
//
//  Created by Sergei on 14.05.13.
//  Copyright (c) 2013 Sergei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;
@class ButtonViewController;
@class ActionViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) ButtonViewController *buttonViewController;
@property (strong, nonatomic) ActionViewController *actionViewController;

@end
