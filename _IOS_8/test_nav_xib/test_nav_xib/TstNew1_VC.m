//
//  TstNew1_VC.m
//  test_nav_xib
//
//  Created by Sergei on 10.02.15.
//  Copyright (c) 2015 Sergei. All rights reserved.
//

#import "TstNew1_VC.h"

@interface TstNew1_VC ()

@end

@implementation TstNew1_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"TstNew2_VC-viewDidLoad");
    UIView *v = self.view;
    UIColor *c = self.view.backgroundColor;
    v = nil;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)shouldAutorotate
{
    NSLog(@"-ask-dev_shouldAutorotate");
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    NSLog(@"-ask-dev_supportedInterfaceOrientations");
    return UIInterfaceOrientationMaskPortrait |
    UIInterfaceOrientationMaskLandscapeLeft |
    UIInterfaceOrientationMaskLandscapeRight;
//    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft;
    //    return UIInterfaceOrientationMaskPortrait;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)pressButton:(id)sender {
    static int i = 0;
   if (++i % 2) {
        [self.view sendSubviewToBack:self.button];
    } else {
        [self.view bringSubviewToFront:self.button];
    }
    
    
    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
     }];

}



@end
