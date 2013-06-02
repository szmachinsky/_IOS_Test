//
//  GesturesViewController.h
//  Test_1
//
//  Created by svp on 06.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GesturesViewController : UIViewController
{
    
    IBOutlet UIView *view1_;
    
    IBOutlet UIView *view2_;
    
    IBOutlet UIImageView *image1_;
    
    IBOutlet UILabel *label1_;
    
    CGPoint origC;
}

@end


@interface UIImageView(MyGestures) 
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
@end


@interface MyView : UIView 
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
@end

