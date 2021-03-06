//
//  Test1_VC.m
//  test_nav_xib
//
//  Created by Sergei on 19.10.14.
//  Copyright (c) 2014 Sergei. All rights reserved.
//

#import "Test1_VC.h"


#define RunOnMainThread0()              \
if (![NSThread isMainThread])\
{\
[self performSelectorOnMainThread:_cmd withObject:nil waitUntilDone:YES];\
return;\
}

#define RunOnMainThread1(arg1)          \
if (![NSThread isMainThread])\
{\
[self performSelectorOnMainThread:_cmd withObject:(arg1) waitUntilDone:YES];\
return;\
}


@interface NSArray (FixOffset)     //use Category
+ (void)setFixEnabled:(BOOL)isON;
- (BOOL)refreshIsBusy;
@end

@implementation NSArray (FixOffset)
@end

//=========================================================

@interface FX_NSArray:NSArray     //use subClass
- (instancetype)init;
- (void)removeAllObjects;
@end

@implementation FX_NSArray
- (instancetype)init
{   self = [super init];
    return self;
}
- (void)removeAllObjects
{
    
}
@end


@interface Test1_VC ()

@end

@implementation Test1_VC

- (NSString *)deallocDescription{ //custom dealloc message!!!!
    return @"custom string_DEALLOC_TEST1_VC";
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


//- (void)viewDidUnload {
//    [super viewDidUnload];
//    
//    NSLog(@"\n\n -- DidUNLoad_test_1 --\n");
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"-----begin-----");
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"_TEST_01_";
    [self setupTapRecognizers];
    
    NSLog(@"\n\n -- DidLoad_test_1 --\n");
    
//#ifdef DEBUG
//    NSLog(@"-debug-");
//#else
//    NSLog(@"-release-");
//#endif
//    
//    DLog(@"DLog TEst");
//    #ifdef NS_BLOCK_ASSERTIONS
//    NSLog(@"-0--");
//    #endif
//    ALog(@"Alog Test");
//    
//    NSLog(@"--1-");
//    NSAssert(false,@"!!!!!");
//    NSLog(@"--2-");
    
    
    NSLog(@"-----run tests-----");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    dispatch_async(dispatch_get_main_queue(), ^{
        [self runTest1];
        [self runTest2:@"-test-"];
 });

    NSLog(@"-----end-----");
    
}


-(void)viewDidAppear:(BOOL)animated
{
     [super viewDidAppear:animated];
    
    id id1 = self;
    id id2 = self.navigationController.interactivePopGestureRecognizer.delegate;
    id id3 = self.navigationController;
    NSLog(@"\n\n 1))) self=(%p)  delegate=(%p)  nav=(%p)",id1,id2,id3);
    id1 = id2;
    
    
//    DLog(@"test_Dl_log:%d",1);
//    
//    ZAssert((id1==id2),@"Z-assert_test");
//    
//    NSAssert(1!=2, @"Print this statement.");
//    id1 = id2;
//    
//    assert((id1!=id2));
}

-(void)runTest1
{
    RunOnMainThread0();
    NSLog(@"\n\n -- runTest1 --\n");
//    int i = 0;
    return;
}

-(void)runTest2:(NSString*)str
{
    RunOnMainThread1(str);
    NSLog(@"\n\n -- runTest2:(%@) --\n",str);
//    int i = 0;
    return;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"\n\n -- MemoryWarning_test_1 --\n");
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



- (UIInterfaceOrientationMask)supportedInterfaceOrientations
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

- (NSArray<id> *)previewActionItems {
    
    // setup a list of preview actions
    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"Action 1" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Action 1 triggered");
    }];
    
    UIPreviewAction *action2 = [UIPreviewAction actionWithTitle:@"Destructive Action" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Destructive Action triggered");
    }];
    
    UIPreviewAction *action3 = [UIPreviewAction actionWithTitle:@"Selected Action" style:UIPreviewActionStyleSelected handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"Selected Action triggered");
    }];
    
    // add them to an arrary
    NSArray *actions = @[action1, action2, action3];
    
    // and return them
    return actions;
}


@end
