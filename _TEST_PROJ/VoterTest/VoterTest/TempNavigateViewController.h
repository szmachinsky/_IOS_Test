//
//  TempNavigateViewController.h
//  VoterTest
//
//  Created by User User on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TempNavigateViewController : UIViewController
{
    UINavigationController *navigation_; 
    UIViewController *controller_;

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil rootViewController:(UIViewController*)controller;

@end
