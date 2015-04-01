//
//  DetailViewController.h
//  TestMigrator
//
//  Created by Zmachinsky Sergei on 01.04.15.
//  Copyright (c) 2015 Zmachinsky Sergei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

