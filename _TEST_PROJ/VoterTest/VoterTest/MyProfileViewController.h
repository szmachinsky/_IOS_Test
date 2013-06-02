//
//  MyProfileViewController.h
//  VoterTest
//
//  Created by User User on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProfileViewController : UIViewController 
{
    IBOutlet UIView *topView_;    
    int currentPage_;
    
}

- (IBAction)pressBack:(id)sender;
- (IBAction)pressButton:(id)sender;

@end
