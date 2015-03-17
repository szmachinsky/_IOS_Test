//
//  UIViewController+Hud.m
//  iTube
//
//  Created by Sergey Ladeiko on 11/5/13.
//  Copyright (c) 2013 Sergey Ladeiko. All rights reserved.
//

#import "UIViewController+Hud.h"
#import "SVProgressHUD.h"

#if !DEBUG
# define NSLog(...)     ((void)0)
#endif

__strong static NSMutableSet* g_shown = nil;

@implementation UIViewController (Hud)

static void init(){
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[SVProgressHUD appearance] setHudForegroundColor:
         [UIColor blackColor]
         //THEME_MAIN_COLOR
         ];
        [[SVProgressHUD appearance] setHudBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.9]];
        [[SVProgressHUD appearance] setHudRingForegroundColor:[UIColor redColor]];//THEME_MAIN_COLOR]; //zs
        [[SVProgressHUD appearance] setHudFont:[UIFont systemFontOfSize:14]];   //[UIFont fontWithName:THEME_FONT_NAME size:14]]; //zs
    });
}

+ (void)hudInit{
    init();
}

- (void)showInfiniteHud:(BOOL)animated withTitle:(NSString*)title
{
    init();
    
    if (!g_shown)
        g_shown = [NSMutableSet set];
    
    NSValue* value = [NSValue valueWithNonretainedObject:self];
    
    if (![g_shown containsObject:value])
        [g_shown addObject:value];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
}

- (void)showInfiniteHudWithTitle:(NSString*)title
{
    [self showInfiniteHud:NO withTitle:title];
}

- (void)showProgressHudWithCancel:(float)progress
{
    init();
    
    if (!g_shown)
        g_shown = [NSMutableSet set];
    
    NSValue* value = [NSValue valueWithNonretainedObject:self];
    
    if (![g_shown containsObject:value])
        [g_shown addObject:value];
    
    [SVProgressHUD showProgress:progress status:@"?cancel" maskType:SVProgressHUDMaskTypeClear];
}

- (void)showProgressHud:(float)progress
{
    init();
    
    if (!g_shown)
        g_shown = [NSMutableSet set];
    
    NSValue* value = [NSValue valueWithNonretainedObject:self];
    
    if (![g_shown containsObject:value])
        [g_shown addObject:value];
    
    [SVProgressHUD showProgress:progress status:nil maskType:SVProgressHUDMaskTypeClear];
}

- (void)showInfiniteHud:(BOOL)animated
{
    [self showInfiniteHud:animated withTitle:@""];
}

- (void)showInfiniteHud
{
    [self showInfiniteHud:NO];
}

- (void)dismissHud:(BOOL)animated
{
    NSValue* value = [NSValue valueWithNonretainedObject:self];
    
    if ([g_shown containsObject:value])
        [g_shown removeObject:value];
    
    if ([g_shown count] == 0)
        [SVProgressHUD dismiss];
}

- (void)dismissHud
{
    [self dismissHud:NO];
}

+ (void)showInfiniteHudText:(NSString*)text
{
    init();
    [SVProgressHUD showWithStatus:text maskType:SVProgressHUDMaskTypeClear];
}

+ (void)showProgressHud:(float)progress text:(NSString*)text
{
    init();
    [SVProgressHUD showProgress:progress status:text maskType:SVProgressHUDMaskTypeClear];
}

+ (void)dismissHud
{
    [SVProgressHUD dismiss];
}

@end
