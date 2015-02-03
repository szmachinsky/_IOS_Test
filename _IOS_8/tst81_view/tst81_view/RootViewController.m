//
//  RootViewController.m
//  tst81_view
//
//  Created by Sergei on 29.10.14.
//  Copyright (c) 2014 Sergei. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
    CGRect f1 = self.view.frame;
    CGRect f2 = self.label.frame;
    //    NSLog(@"(%@)(%@)",f1,f2);
    f1 = CGRectZero; f2 = CGRectZero;
}


- (void)viewDidLayoutSubviews
{
    NSLog(@"viewDidLayoutSubviews");
    //    for (UIView *subview in self.view.subviews) {
    //        if([subview hasAmbiguousLayout])
    //            NSLog(@"AMBIGUOUS: %@", subview);
    //    }
}

- (void) traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    NSLog(@"traitCollectionDidChange %@",previousTraitCollection);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
