//
//  UIRefreshControl+FixOffset.m
// 
//
//  Created by Zmachinsky Sergei on 21.10.15.
//  Copyright © 2015 Sergei. All rights reserved.
//

#import "UIRefreshControl+FixOffset.h"
#import <objc/runtime.h>
#import "iSmartObjectSwizzling.h"

#define Enable_RefreshControl_Swizzle   1  //enable swizzling
#define Enable_RefreshControl_Fix       1  //enable fixing offset

#define showLogs 1

#if !DEBUG || !showLogs
#define NSLog(...)  ((void)0)
#endif



static const char enable_RefreshControl_FixKey;
static const char enable_RefreshControl_BusyKey;

@implementation UIRefreshControl (FixOffset)
+ (void)load
{
    if (Enable_RefreshControl_Swizzle) {
        NSLog(@"\n\n --SET SWIZZLE for UIRefreshControl \n\n");
        [self swizzleInstanceMethod:self oldSelector:@selector(beginRefreshing) newSelector:@selector(ZS_beginRefreshing)];
        [self swizzleInstanceMethod:self oldSelector:@selector(endRefreshing) newSelector:@selector(ZS_endRefreshing)];
        
        if (Enable_RefreshControl_Fix) {
            [self Refresh_Fix_ON];
        } else {
            [self Refresh_Fix_OFF];
        }
    }
}

+(void)Refresh_Fix_ON
{
    objc_setAssociatedObject(self, &enable_RefreshControl_FixKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(void)Refresh_Fix_OFF
{
    objc_setAssociatedObject(self, &enable_RefreshControl_FixKey, @(NO), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(void)Refresh_Busy_ON
{
    objc_setAssociatedObject(self, &enable_RefreshControl_BusyKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(void)Refresh_Busy_OFF
{
    objc_setAssociatedObject(self, &enable_RefreshControl_BusyKey, @(NO), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(BOOL)Refresh_isBusy
{
    BOOL res = [objc_getAssociatedObject(self, &enable_RefreshControl_BusyKey) boolValue];
    return res;
}


-(UITableView*)selfTableView
{
    UITableView *tableView;
    UIView* v = [self superview];
    if ([v isKindOfClass:[UITableView class]]) {
        tableView = (UITableView*)v;
    }
    return tableView;
}


- (void)ZS_beginRefreshing
{
    
    [[self class] Refresh_Busy_ON];
    
    UITableView *tableView = [self selfTableView];
    
    NSLog(@" --SWIZZ------ super beginRefreshing--------");
    NSLog(@" --SWIZZ--offset=(%@) inset=(%@)", NSStringFromCGPoint(tableView.contentOffset),NSStringFromUIEdgeInsets(tableView.contentInset));
    [self ZS_beginRefreshing];
    NSLog(@" --SWIZZ--offset=(%@) inset=(%@)", NSStringFromCGPoint(tableView.contentOffset),NSStringFromUIEdgeInsets(tableView.contentInset));
}


- (void)ZS_endRefreshing
{
    
    [[self class] Refresh_Busy_OFF];
    
    UITableView *tableView = [self selfTableView];
    
    NSLog(@" --SWIZZ------ super endRefreshing -------");
    NSLog(@" --SWIZZ--offset=(%@) inset=(%@)", NSStringFromCGPoint(tableView.contentOffset),NSStringFromUIEdgeInsets(tableView.contentInset));
    [self ZS_endRefreshing];
    NSLog(@" --SWIZZ--offset=(%@) inset=(%@)", NSStringFromCGPoint(tableView.contentOffset),NSStringFromUIEdgeInsets(tableView.contentInset)); //zs1
    
//  NSNotification *anote = [NSNotification notificationWithName:@"k_endRefreshing" object:nil userInfo:nil];
//  [[NSNotificationCenter defaultCenter] postNotification:anote];
    
    if ([objc_getAssociatedObject([self class], &enable_RefreshControl_FixKey) boolValue]) {
        
        float time = 0.3;
        NSNumber *tim = [tableView valueForKey:@"contentOffsetAnimationDuration"];
        if (tim) {
            time = [tim floatValue];
        };
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [self performSelector:@selector(correctOffset) withObject:nil afterDelay:time+0.05];
        NSLog(@" --SWIZZ---WILL FIX & CHECK offset.y=%f\n\n",tableView.contentOffset.y);
    }
    
}


-(void)correctOffset
{
    @try
    {
        UITableView *tableView = [self selfTableView];
        if (!tableView)
            return;
        
        CGPoint p = [tableView contentOffset];
        float offY = p.y;
        float insTop = tableView.contentInset.top;
        float sum = offY + insTop;
        BOOL busy = [[self class] Refresh_isBusy];
        
        NSLog(@" --SWIZZ-- ??? CHECK  correctOffset offset.y=%.3f  inset.top=%.3f  sum=%.3f ",offY,insTop,sum);
        if ((fabsf(sum) > 10.0)&&(offY < 0.0)&&(!busy))
        {
            p.y = (insTop>FLT_EPSILON)?(-insTop):0.0;
            NSLog(@" -- !!! SWIZZ-- !!! CORRECT offset to:%f",p.y);
            [tableView setContentOffset:p animated:YES]; //correct offset
        }
        
    }
    @finally {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
}


@end


