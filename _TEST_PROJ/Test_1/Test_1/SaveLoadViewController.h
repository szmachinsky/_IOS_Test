//
//  SaveLoadViewController.h
//  Test_1
//
//  Created by svp on 13.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaveLoadViewController : UIViewController
{
    
    IBOutlet UILabel *label_;
    IBOutlet UIImageView *imView_;
    IBOutlet UILabel *labelArr_;
    
//    NSMutableArray *arr_;
}

- (IBAction)press1:(id)sender;

- (IBAction)pressSave:(id)sender;
- (IBAction)pressClear:(id)sender;
- (IBAction)pressLoad:(id)sender;


@end
