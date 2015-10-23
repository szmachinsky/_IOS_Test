//
//  UIRefreshControl+FixOffset.h
//
//
//  Created by Zmachinsky Sergei on 21.10.15.
//  Copyright © 2015 Sergei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Use_Category_UIRefreshControl_FixOffset_Not_Subclass    0


#if Use_Category_UIRefreshControl_FixOffset_Not_Subclass

@interface UIRefreshControl (FixOffset)             //use Category
+ (void)setFixEnabled:(BOOL)isON;
- (BOOL)refreshIsBusy;
@end

#else

@interface FX_UIRefreshControl:UIRefreshControl     //use subClass
- (instancetype)init;
- (instancetype)initWithFixigEnable:(BOOL)fixIsOn;
- (BOOL)refreshIsBusy;
- (void)beginRefreshing;
- (void)endRefreshing;
@end

#endif

