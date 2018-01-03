//
//  DetailViewController.h
//  test_nav_story
//
//  Created by Sergei on 29.12.2017.
//  Copyright © 2017 Sergei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSDate *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

