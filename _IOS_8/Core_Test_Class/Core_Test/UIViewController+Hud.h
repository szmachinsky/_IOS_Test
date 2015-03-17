//
//  UIViewController+Hud.h
//  iTube
//
//  Created by Sergey Ladeiko on 11/5/13.
//  Copyright (c) 2013 Sergey Ladeiko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Hud)
+ (void)hudInit;
+ (void)showInfiniteHudText:(NSString*)text;
+ (void)showProgressHud:(float)progress text:(NSString*)text;
- (void)showProgressHud:(float)progress;
- (void)showProgressHudWithCancel:(float)progress;
- (void)showInfiniteHud:(BOOL)animated;
- (void)showInfiniteHud;
- (void)showInfiniteHud:(BOOL)animated withTitle:(NSString*)title;
- (void)showInfiniteHudWithTitle:(NSString*)title;
- (void)dismissHud:(BOOL)animated;
- (void)dismissHud;
+ (void)dismissHud;
@end
