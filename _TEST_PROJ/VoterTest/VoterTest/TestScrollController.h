//
//  TestScrollController.h
//  VoterTest
//
//  Created by User User on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestScrollController : UIViewController  <UIScrollViewDelegate>
{

    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIView *view1_;
    IBOutlet UIView *view2_;
    
    int shiftXPos_;
    int currentPage_;
}

- (IBAction)switchPage:(id)sender;

@end
