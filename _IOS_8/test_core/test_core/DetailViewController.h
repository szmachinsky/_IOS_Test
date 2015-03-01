//
//  DetailViewController.h
//  test_core
//
//  Created by Sergei on 02.03.15.
//  Copyright (c) 2015 Sergei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

