//
//  GGLViewController.h
//  VoterTest
//
//  Created by User User on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGLViewController : UIViewController
{
    
    IBOutlet UIButton *backButton_;    
    IBOutlet UIButton *connectButton_;
    
    NSMutableData *responseData;    
}

- (IBAction)pressBack:(id)sender;
- (IBAction)pressConnect:(id)sender;

@end
