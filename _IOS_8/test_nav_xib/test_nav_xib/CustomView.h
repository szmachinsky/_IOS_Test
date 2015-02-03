//
//  CustomView.h
//  test_nav_xib
//
//  Created by Sergei on 23.11.14.
//  Copyright (c) 2014 Sergei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomView : UIView

@property (weak, nonatomic) IBOutlet UILabel *custLabel;
@property (weak, nonatomic) IBOutlet UIButton *custButton;


+ (CustomView *)loadView;

@end
