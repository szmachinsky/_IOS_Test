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


#define showLogs    1

#if !DEBUG || !showLogs
#define NSLog(...)  ((void)0)
#endif


#if Use_Category_UIRefreshControl_FixOffset_Not_Subclass

//============================================== UIRefreshControl (FixOffset) =============================================================================
#pragma mark - --Category

#define Enable_RefreshControl_Swizzle       1   //to active swizzling during "load"
#define Enable_RefreshControl_Fix           1   //to make fix enabled during "load"


static const char enable_RefreshControl_FixKey;
static const char enable_RefreshControl_BusyKey;


@implementation UIRefreshControl (FixOffset)

+ (void)load
{
    if (Enable_RefreshControl_Swizzle) {
        NSLog(@"\n\n --REFR SET SWIZZLE for UIRefreshControl \n\n");
        [self swizzleInstanceMethod:self oldSelector:@selector(beginRefreshing) newSelector:@selector(ZS_beginRefreshing)];
        [self swizzleInstanceMethod:self oldSelector:@selector(endRefreshing) newSelector:@selector(ZS_endRefreshing)];
        
        if (Enable_RefreshControl_Fix) {
            [self setFixEnabled:YES];
        } else {
            [self setFixEnabled:NO];
        }
    }
}

+ (void)setFixEnabled:(BOOL)isON
{
    objc_setAssociatedObject(self, &enable_RefreshControl_FixKey, @(isON), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)setRefreshBusy:(BOOL)isON
{
    objc_setAssociatedObject(self, &enable_RefreshControl_BusyKey, @(isON), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isFixingEnabled
{
    return [objc_getAssociatedObject([self class], &enable_RefreshControl_FixKey) boolValue];
}

- (BOOL)refreshIsBusy
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
    [self setRefreshBusy:YES];
    UITableView *tableView = [self selfTableView];
    
    NSLog(@" --REFR _beginRefreshing_1 offset=(%@) inset=(%@)", NSStringFromCGPoint(tableView.contentOffset),NSStringFromUIEdgeInsets(tableView.contentInset));
    [self ZS_beginRefreshing];
    NSLog(@" --REFR _beginRefreshing_2 offset=(%@) inset=(%@)", NSStringFromCGPoint(tableView.contentOffset),NSStringFromUIEdgeInsets(tableView.contentInset));
}


- (void)ZS_endRefreshing
{
    [self setRefreshBusy:NO];
    UITableView *tableView = [self selfTableView];
    
    NSLog(@" --REFR _endRefreshing_1 offset=(%@) inset=(%@)", NSStringFromCGPoint(tableView.contentOffset),NSStringFromUIEdgeInsets(tableView.contentInset));
    [self ZS_endRefreshing];
    NSLog(@" --REFR _endRefreshing_2 offset=(%@) inset=(%@)", NSStringFromCGPoint(tableView.contentOffset),NSStringFromUIEdgeInsets(tableView.contentInset));
    
    
    if ([self isFixingEnabled]) {
        float time = 0.3;
        NSNumber *tim = [tableView valueForKey:@"contentOffsetAnimationDuration"];
        if (tim) {
            time = [tim floatValue];
        };
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)((time+0.05) * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [self correctOffset];
        });
        
        NSLog(@" --REFR WILL CHECK offset=(%@) inset=(%@)", NSStringFromCGPoint(tableView.contentOffset),NSStringFromUIEdgeInsets(tableView.contentInset));
    } else {
        NSNotification *anote = [NSNotification notificationWithName:@"k_endRefreshing" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:anote];
    }
    
}


- (void)correctOffset
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
        BOOL busy = [self refreshIsBusy];
        
        NSLog(@" --REFR -- CHECK  correctOffset offset.y=%.3f  inset.top=%.3f  sum=%.3f ",offY,insTop,sum);
        if ((fabsf(sum) > 10.0)&&(offY < 0.0)&&(!busy))
        {
            p.y = (insTop>FLT_EPSILON)?(-insTop):0.0;
            NSLog(@" -- !!! CORRECT offset to:%f",p.y);
            [tableView setContentOffset:p animated:YES]; //correct offset
            
            NSNotification *anote1 = [NSNotification notificationWithName:@"k_wasRefreshingFix" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:anote1];
            
            NSNotification *anote2 = [NSNotification notificationWithName:@"k_endRefreshing" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:anote2];
        }
        
    }
    @finally {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
}


@end


#else  // Use_Category_UIRefreshControl_FixOffset_Not_Subclass == 0

//============================================== FX_UIRefreshControl =============================================================================
#pragma mark - --subClass

@implementation FX_UIRefreshControl
{
    BOOL _fixingEnabled;
    BOOL _busy;
}

- (instancetype)init
{
    self = [self initWithFixigEnable:YES]; //fix is enabled by default
    return self;
}

- (instancetype)initWithFixigEnable:(BOOL)fixIsOn
{
    self = [super init];
    if (self) {
        _fixingEnabled = fixIsOn;
        _busy = NO;
    }
    return self;
}


- (UITableView*)selfTableView
{
    UITableView *tableView;
    UIView* v = [self superview];
    if ([v isKindOfClass:[UITableView class]]) {
        tableView = (UITableView*)v;
    }
    return tableView;
}

- (BOOL)refreshIsBusy
{
    return _busy;
}


- (void)beginRefreshing
{
    NSLog(@"\n\n ___beginRefreshing_2___");
    _busy = YES;
    [super beginRefreshing];
}


- (void)endRefreshing
{
    NSLog(@"\n\n ___endRefreshing_2___");
    _busy = NO;
    UITableView *tableView = [self selfTableView];
    
    [super endRefreshing];
    
    NSNotification *anote = [NSNotification notificationWithName:@"k_endRefreshing" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:anote];
    
    if (_fixingEnabled) {
        float time = 0.3;
        NSNumber *tim = [tableView valueForKey:@"contentOffsetAnimationDuration"];
        if (tim) {
            time = [tim floatValue];
        };
        
//        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
//        
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)((time+0.05) * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^{
//            [self correctOffset];
//        });
//        
//        NSLog(@" -.-REFR WILL CHECK offset=(%@) inset=(%@)", NSStringFromCGPoint(tableView.contentOffset),NSStringFromUIEdgeInsets(tableView.contentInset));
    } else {
        NSNotification *anote = [NSNotification notificationWithName:@"k_endRefreshing" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:anote];
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
        
        BOOL busy = [self refreshIsBusy];
        
        NSLog(@" -.-REFR -- CHECK  correctOffset offset.y=%.3f  inset.top=%.3f  sum=%.3f ",offY,insTop,sum);
        if ((fabsf(sum) > 10.0)&&(offY < 0.0)&&(!busy))
        {
            p.y = (insTop>FLT_EPSILON)?(-insTop):0.0;
            NSLog(@" -.- !!! CORRECT offset to:%f",p.y);
            [tableView setContentOffset:p animated:YES]; //correct offset
            
            NSNotification *anote1 = [NSNotification notificationWithName:@"k_wasRefreshingFix" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:anote1];
            
            NSNotification *anote2 = [NSNotification notificationWithName:@"k_endRefreshing" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:anote2];
        }
        
    }
    @finally {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
}


@end

#endif


//=================================================================================================================
#define USE_iSmartPullToRefreshUtilitiesUIRefreshControl        1

#if USE_iSmartPullToRefreshUtilitiesUIRefreshControl
@interface iSmartPullToRefreshUtilitiesUIRefreshControl : UIRefreshControl
@end

@implementation iSmartPullToRefreshUtilitiesUIRefreshControl //zs222

- (UITableView*)selfTableView
{
    UITableView *tableView;
    UIView* v = [self superview];
    if ([v isKindOfClass:[UITableView class]]) {
        tableView = (UITableView*)v;
    }
    return tableView;
}

- (void)beginRefreshing
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(correctOffset) object:nil];
    [super beginRefreshing];
}

- (void)endRefreshing
{
    NSLog(@"\n\n ___endRefreshing____");
    [super endRefreshing];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(correctOffset) object:nil];
    
    UITableView *tableView = [self selfTableView];
    if (!tableView){
        return;
    }
    
    float time = 0.3;
    NSNumber *tim = [tableView valueForKey:@"contentOffsetAnimationDuration"];
    if (tim) {
        time = [tim floatValue];
    }
    
    [self performSelector:@selector(correctOffset) withObject:nil afterDelay:time + 0.05];
}

- (void)correctOffset
{
    if ([self isRefreshing]){
        return;
    }
    
    UITableView *tableView = [self selfTableView];
    if (!tableView){
        return;
    }
    
    CGPoint p = [tableView contentOffset];
    float offY = p.y;
    float insTop = tableView.contentInset.top;
    float sum = offY + insTop;
    
    if ((fabsf(sum) > 10.0) && (offY < 0.0))
    {
        p.y = (insTop > FLT_EPSILON)?(-insTop):0.0;
        [tableView setContentOffset:p animated:YES];
    }
}

@end
#else
# define iSmartPullToRefreshUtilitiesUIRefreshControl UIRefreshControl
#endif



