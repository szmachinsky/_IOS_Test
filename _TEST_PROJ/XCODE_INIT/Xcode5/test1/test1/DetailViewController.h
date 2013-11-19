//
//  DetailViewController.h
//  test1
//
//  Created by Sergei on 08.09.13.
//  Copyright (c) 2013 Sergei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
