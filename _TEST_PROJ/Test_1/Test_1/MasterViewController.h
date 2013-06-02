//
//  MasterViewController.h
//  Test_1
//
//  Created by svp on 25.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestCountViewController.h"
#import "AccelerometerViewController.h"
#import "GesturesViewController.h"
#import "AnimationViewController.h"
#import "SaveLoadViewController.h"
#import "PropertyViewController.h"
#import "BlockViewController.h"
#import "ThreadViewController.h"
#import "WebViewController.h"


@interface MasterViewController : UITableViewController
{
    TestCountViewController *testCountViewController_;
    AccelerometerViewController *accelerometerViewController_;
    GesturesViewController *gesturesViewController_;
    AnimationViewController *animationViewController_;
    SaveLoadViewController *saveLoadViewController_;
    PropertyViewController *propertyViewController_;
    BlockViewController *blockViewController_;
    ThreadViewController *threadViewController_;
    WebViewController *webViewController_;
    
}

@end
