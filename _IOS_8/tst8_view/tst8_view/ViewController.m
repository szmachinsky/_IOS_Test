//
//  ViewController.m
//  tst8_view
//
//  Created by Sergei on 29.10.14.
//  Copyright (c) 2014 Sergei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

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


- (void)viewDidAppear:(BOOL)animated
{
    CGRect f1 = self.view.frame;
    CGRect f2 = self.label.frame;
    //    NSLog(@"(%@)(%@)",f1,f2);
    f1 = CGRectZero;
}


@end
