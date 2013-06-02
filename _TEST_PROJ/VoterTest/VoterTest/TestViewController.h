//
//  TestViewController.h
//  VoterTest
//
//  Created by User on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController
{
    
    IBOutlet UIView *view1;
    IBOutlet UIView *view2;
    IBOutlet UIView *view3;
    
}

- (IBAction)pressButton1:(id)sender;
- (IBAction)pressButton2:(id)sender;
- (IBAction)pressButton3:(id)sender;


@end
