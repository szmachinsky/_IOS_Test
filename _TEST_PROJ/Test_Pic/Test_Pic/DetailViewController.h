//
//  DetailViewController.h
//  Test_Pic
//
//  Created by Sergei on 28.02.13.
//  Copyright (c) 2013 Sergei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
