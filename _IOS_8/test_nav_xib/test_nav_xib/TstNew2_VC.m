//
//  TstNew2_VC.m
//  test_nav_xib
//
//  Created by Sergei on 10.02.15.
//  Copyright (c) 2015 Sergei. All rights reserved.
//

#import "TstNew2_VC.h"

@interface TstNew2_VC ()

@end

@implementation TstNew2_VC

-(id)init
{
    self = [super init];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"TstNew2_VC-viewDidLoad");
    UIView *v = self.view;
    UIColor *c = self.view.backgroundColor;
    v = nil;
    // Do any additional setup after loading the view.
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

@end
