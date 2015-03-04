//
//  Test1_VC.m
//  test_nav_xib
//
//  Created by Sergei on 19.10.14.
//  Copyright (c) 2014 Sergei. All rights reserved.
//

#import "Test1_VC.h"

@interface Test1_VC ()

@end

@implementation Test1_VC

- (NSString *)deallocDescription{ //custom dealloc message!!!!
    return @"DEALLOC_TEST1_VC";
}

-(void)dealloc
{
    NSLog(@"real dealloc TEST1_VC");
}

- (void)setupTapRecognizers
{
    
    UIView * view = [ [ UIView alloc ] initWithFrame:self.view.frame ];
    view.backgroundColor = [ UIColor clearColor ];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [ self.view addSubview:view ];
    
    
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Action:)];
 //   self.leftSwipeGestureRecognizer = swipeLeftRecognizer;
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeLeftRecognizer.delegate = self;
    [view addGestureRecognizer:swipeLeftRecognizer];
    
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(Action:)];
//    self.rightSwipeGestureRecognizer = swipeRightRecognizer;
    swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRightRecognizer.delegate = self;
//    BOOL del1 = self.rightSwipeGestureRecognizer.delaysTouchesBegan; //zs
    //    self.rightSwipeGestureRecognizer.delaysTouchesBegan = YES;
    [view addGestureRecognizer:swipeRightRecognizer];
    
    
    UITapGestureRecognizer * recognizer = [ [ UITapGestureRecognizer alloc ] initWithTarget:self action:@selector(Action:) ];
//    self.tapRecognizer = recognizer;
//    self.tapRecognizer.delegate = self;
//    BOOL del0 = self.tapRecognizer.delaysTouchesBegan; //zs
    //    self.tapRecognizer.delaysTouchesBegan = YES;
    [ view addGestureRecognizer:recognizer ];
    
    // double tap
    UITapGestureRecognizer * recognizer2 = [ [ UITapGestureRecognizer alloc ] initWithTarget:self action:@selector(Action:) ];
//    self.doubleTapGestureRecognizer = recognizer2; //zs
    recognizer2.numberOfTapsRequired = 2;
    recognizer2.delegate = self;
//    BOOL del00 = self.doubleTapGestureRecognizer.delaysTouchesBegan; //zs
    //    self.doubleTapGestureRecognizer.delaysTouchesBegan = YES;
    [ view addGestureRecognizer:recognizer2 ];
    
    
    BOOL del2 = self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan; //zs
    self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan = YES;
}

-(void)Action:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"ACTION");
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"_TEST_01_";
    [self setupTapRecognizers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    NSLog(@"d1-??-dev_viewDidLayoutSubviews");
}



- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"d1-01-dev_willRotateToInterfaceOrientation %d %f",toInterfaceOrientation,duration);
    self.view.backgroundColor = [UIColor redColor];
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    NSLog(@"d1-02-dev_willAnimateRotationToInterfaceOrientation %d %f",toInterfaceOrientation,duration);
    self.view.backgroundColor = [UIColor blueColor];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
     NSLog(@"d1-03-dev_didRotateFromInterfaceOrientation %d",toInterfaceOrientation);
    self.view.backgroundColor = [UIColor greenColor];
}



- (NSUInteger)supportedInterfaceOrientations
{
    NSLog(@"d1---dev_supportedInterfaceOrientations");
    
//    return UIInterfaceOrientationMaskPortrait;
    
    return UIInterfaceOrientationMaskPortrait |
    UIInterfaceOrientationMaskLandscapeLeft |
    UIInterfaceOrientationMaskLandscapeRight;
//
//    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft;
//    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate
{
    NSLog(@"d1--dev_shouldAutorotate");
    return YES;
}



@end
