//
//  ViewController.m
//  tst82_view_stor
//
//  Created by Sergei on 30.10.14.
//  Copyright (c) 2014 Sergei. All rights reserved.
//

#import "ViewController.h"
#import "Init_VC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear:ViewController");
    
    [self performSelector:@selector(initControl) withObject:nil afterDelay:0.0];
    
}

- (void)initControl
{
    Init_VC *control = [[Init_VC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:control];
    
    [self presentViewController:nav animated:NO completion:nil];
}

@end
