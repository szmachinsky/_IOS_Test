//
//  DetailViewController.h
//  test111
//
//  Created by Sergei on 22.10.14.
//  Copyright (c) 2014 Sergei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
