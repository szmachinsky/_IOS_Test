//
//  ActionViewController.h
//  Test_3
//
//  Created by Sergei on 27.05.13.
//  Copyright (c) 2013 Sergei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FBConnect.h"
#import "TwitMe.h"

@interface ActionViewController : UIViewController <FBRequestDelegate, FBDialogDelegate, FBSessionDelegate,
TwitterDelegate,
UIActionSheetDelegate>


{
/////    Facebook *facebook;

}
@property (nonatomic, strong) Facebook *facebook;


- (void)twitterResult:(TWTweetComposeViewController *)handler;

@end
