//
//  AnimationViewController.h
//  Test_1
//
//  Created by svp on 09.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface AnimationViewController : UIViewController
{
    
    IBOutlet UILabel *label_;
    IBOutlet UIView *view_;    
    IBOutlet UIImageView *imView_;
    
    CALayer *boxLayer;
    
    CABasicAnimation *spin_;
    CAKeyframeAnimation *bounce_;
    CABasicAnimation *fader_;
    CABasicAnimation *mover_;     
}

- (IBAction)press1:(id)sender;
- (IBAction)press2:(id)sender;
- (IBAction)press3:(id)sender;
- (IBAction)press4:(id)sender;
- (IBAction)press5:(id)sender;

- (IBAction)pressGroup:(id)sender;
- (IBAction)pressGroup2:(id)sender;

@end
