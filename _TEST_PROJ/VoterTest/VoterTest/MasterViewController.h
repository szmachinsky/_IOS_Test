//
//  MasterViewController.h
//  VoterTest
//
//  Created by User on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SignInViewController;
@class DetailViewController;
@class ForgotViewController;
@class SignUpViewController;
@class EditProfileViewController;
@class TestViewController;
@class TestScrollController;
@class MyProfileViewController;
@class FCViewController;
@class GGLViewController;
@class OAuth2SampleRootViewControllerTouch;

@interface MasterViewController : UITableViewController 
{
    SignInViewController *signInViewController_;
    ForgotViewController *forgotViewController_;
    SignUpViewController *signUpViewController_;
    EditProfileViewController *editProfileViewController_;
    MyProfileViewController *myProfileViewController;
    
    TestViewController *testViewController;
    TestScrollController *testScrollController;
    
    FCViewController *fCViewController;
    GGLViewController *gGLViewController;
    OAuth2SampleRootViewControllerTouch *oAuth2SampleRootViewControllerTouch_;
    
}

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (nonatomic, assign) FCViewController *fCViewController;

@end
