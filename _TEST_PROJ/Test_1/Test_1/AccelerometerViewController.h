//
//  AccelerometerViewController.h
//  Test_1
//
//  Created by svp on 30.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollTextViewController.h"

@interface AccelerometerViewController : ScrollTextViewController <UIAccelerometerDelegate, UITextFieldDelegate>
{    
    IBOutlet UIImageView *imageView_;
    
    IBOutlet UITextField *textField_;
    
    UIColor *color;
}


@end
