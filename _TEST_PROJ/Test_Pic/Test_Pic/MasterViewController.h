//
//  MasterViewController.h
//  Test_Pic
//
//  Created by Sergei on 28.02.13.
//  Copyright (c) 2013 Sergei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
