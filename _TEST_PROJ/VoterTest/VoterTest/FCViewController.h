//
//  FCViewController.h
//  VoterTest
//
//  Created by svp on 01.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "FBConnect.h"
#import "FBSession.h"


//@interface FCViewController : UIViewController <FBRequestDelegate,FBDialogDelegate,FBSessionDelegate>
@interface FCViewController : UIViewController 
<FBSeccionDelegate>

{
    IBOutlet UIButton *buttonBack;
    IBOutlet UIButton *buttonFC;
    IBOutlet UIButton *buttonInfo;
    
    FBSession *fbSession_;
}

@property(readonly) FBSession *fbSession; 
  

- (IBAction)pressBack:(id)sender;
- (IBAction)pressFC:(id)sender;
- (IBAction)pressGetInfo:(id)sender;

@end
