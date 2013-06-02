//
//  WaitView.m
//  EIC
//
//  Created by Dima Duleba on 15.11.11.
//  Copyright 2011 EleganceIT. All rights reserved.
//

#import "WaitView.h"

@implementation WaitView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.7;
        activityIndicator_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator_.frame = CGRectMake((frame.size.width - activityIndicator_.frame.size.width)/2,
                                                  (frame.size.height - activityIndicator_.frame.size.height)/2,
                                                  activityIndicator_.frame.size.width,
                                                  activityIndicator_.frame.size.height);
        
        [self addSubview:activityIndicator_];
        [self setHidden:YES];
    }
    return self;
}

#pragma mark - Memory management
-(void)dealloc
{
//    [activityIndicator_ release];
//    [super dealloc];
}

#pragma mark - Instance methods
- (void)showWaitScreen
{
    [activityIndicator_ startAnimating];
    [self setHidden:NO];
}

- (void)hideWaitScreen
{
    [activityIndicator_ stopAnimating];
    [self setHidden:YES];
}

@end
