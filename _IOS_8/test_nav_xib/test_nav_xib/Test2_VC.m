//
//  Test2_VC.m
//  test_nav_xib
//
//  Created by Sergei on 19.10.14.
//  Copyright (c) 2014 Sergei. All rights reserved.
//

#import "Test2_VC.h"

@interface Test2_VC ()

@end

@implementation Test2_VC
{
    __weak UIActionSheet* act_Sheet;
    __weak UIAlertController* act_Alert;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"--viewDidLoad--");
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"_TEST_02_";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Refrech) name:@"kRefreshAfterBackgroundState" object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOrientationChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    NSLog(@"-viewDidLayoutSubviews-");
}
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    NSLog(@"-viewWillLayoutSubviews-");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"+viewWillAppear+");
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"+viewDidAppear+");
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSUInteger)supportedInterfaceOrientations
{
    NSLog(@"d2---dev_supportedInterfaceOrientations");
//  return UIInterfaceOrientationMaskPortrait;
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@" action button %d",buttonIndex);
}
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{
    NSLog(@"cancel action sheet");
}
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    NSLog(@"present action sheet");
};  // before animation and showing view
- (void)didPresentActionSheet:(UIActionSheet *)actionSheet
{
    NSLog(@"did present action sheet");
};  // after animation


- (IBAction)pressButton1:(UIButton *)sender {
//    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                     cancelButtonItem:@"Cancel"
//                                                destructiveButtonItem:nil
//                                                     otherButtonItems:@[@"Item1",@"Item2"]];
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                                    cancelButtonTitle:@"Cancel1"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Item11",@"Item12",nil];
//    int i = act_Sheet.actionSheetStyle;
//    act_Sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.navigationController.view];
    
    act_Sheet = actionSheet;
}


- (IBAction)pressButton2:(UIButton *)sender {
//    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
//                                                                   message:@"This is an alert."
//                                                            preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
//                                                          handler:^(UIAlertAction * action) {}];
//    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
//                                                          handler:^(UIAlertAction * action) {}];
//    
//    [alert addAction:defaultAction];
//    [alert addAction:cancelAction];
//    [self presentViewController:alert animated:YES completion:nil];
    
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                                    cancelButtonTitle:@"Cancel2"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Item21",@"Item22",nil];
    
    [actionSheet showInView:self.view];
    act_Sheet = actionSheet;
    
}

- (IBAction)pressButton3:(UIButton *)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* defaultAction1 = [UIAlertAction actionWithTitle:@"CItem1" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    UIAlertAction* defaultAction2 = [UIAlertAction actionWithTitle:@"CItem2" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {}];
    
    UIAlertAction* canceltAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {}];
   
    [alert addAction:defaultAction1];
    [alert addAction:defaultAction2];
    [alert addAction:canceltAction];

//    [self presentViewController:alert animated:YES completion:nil];
    [self setModalPresentationStyle:UIModalPresentationPopover];
    [alert.popoverPresentationController setSourceView:sender];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    act_Alert = alert;
}


-(void)Refrech
{
    NSLog(@"kRefreshAfterBackgroundState");
//    [self performSelector:@selector(after) withObject:nil afterDelay:1.0];
//    act_Sheet.hidden = YES;
    
//  [act_Sheet setNeedsDisplay];
//  [self.view setNeedsLayout];
//  [act_Sheet setNeedsLayout];
//  [act_Sheet setNeedsUpdateConstraints];
    
//    [self.navigationController.view setNeedsLayout];
    
    [super viewWillLayoutSubviews];

    
    [act_Sheet showInView:self.navigationController.view];
    
    
//  [act_Alert viewDidAppear:NO];
    
}

-(void)after
{
    NSLog(@"after");
 // [act_Sheet setNeedsDisplay];
 //   [act_Sheet setNeedsLayout];
    
 //   act_Sheet.hidden = NO;
//    [act_Sheet setNeedsLayout];
//  [self.view setNeedsLayout]; vknkdnkfv  dkjndv  dsvkjvsv sdvsdv  d d

    
//    [act_Sheet dismissWithClickedButtonIndex:2 animated:NO];
//    [self pressButton2:nil];
    
 //   [act_Sheet setNeedsUpdateConstraints];
    
}

-(void)handleOrientationChangeNotification:(NSNotification *)notification
{
    NSLog(@"handleOrientationChangeNotification111");
//    UIDeviceOrientation currentDeviceOrientation =  [[UIDevice currentDevice] orientation];
}

@end
