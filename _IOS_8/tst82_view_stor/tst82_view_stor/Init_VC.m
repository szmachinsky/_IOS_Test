//
//  Init_VC.m
//  tst82_view_stor
//
//  Created by Sergei on 30.10.14.
//  Copyright (c) 2014 Sergei. All rights reserved.
//

#import "Init_VC.h"

@interface Init_VC ()

@end

@implementation Init_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Init_VC";
    // Do any additional setup after loading the view from its nib.
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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear:Init_VC");
}

@end
