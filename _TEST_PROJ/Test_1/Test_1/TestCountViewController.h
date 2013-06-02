//
//  TestCountViewController.h
//  Test_1
//
//  Created by svp on 25.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaitView.h"

@interface TestCountViewController : UIViewController
{
    
    IBOutlet UILabel *label1;
    
    IBOutlet UILabel *label3;
    
    UILabel *label4;
    
    IBOutlet UIImageView *imageView1_;
    
    IBOutlet UIImageView *imageView2_;
    
    IBOutlet UITextField *text_;
    
    IBOutlet UIButton *do3_;
    
    
    WaitView *waitView_;
}

@property (retain, nonatomic) IBOutlet UILabel *label2;

@property (retain, nonatomic) IBOutlet UILabel *label3;

- (IBAction)pressBack:(id)sender;
- (IBAction)pressInfo:(id)sender;
- (IBAction)pressDO1:(id)sender;
- (IBAction)pressDO2:(id)sender;
- (IBAction)pressDO3:(id)sender;

@end
