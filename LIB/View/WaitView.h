//
//  WaitView.h
//  Test_1
//
//  Created by svp on 03.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitView : UIView
{
@private
    UIActivityIndicatorView* activityIndicator_;
}

-(void)showWaitScreen;
-(void)hideWaitScreen;

@end
