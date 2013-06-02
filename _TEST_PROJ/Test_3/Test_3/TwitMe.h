//
//  TwitMe.h
//  Test_3
//
//  Created by Sergei on 29.05.13.
//  Copyright (c) 2013 Sergei. All rights reserved.
//

/*
 USAGE:
 
 [[TwitMe sharedInstance] setImages:[NSArray arrayWithObjects:[UIImage imageNamed:@"twitter.png"], nil]];
 [[TwitMe sharedInstance] setTextTwit:@"first tweet with iOS5"];
 [[TwitMe sharedInstance] setUrl:@"http://www.apple.com"];
 [[TwitMe sharedInstance] setDelegate:self];
 [[TwitMe sharedInstance] showModal];
 
 */

#import <Foundation/Foundation.h>
#import <Twitter/Twitter.h>

@protocol TwitterDelegate <NSObject>
@optional

- (void)twitterResult:(TWTweetComposeViewController *)handler;

@end


@interface TwitMe : TWTweetComposeViewController
{
//    NSString *textTwit;
//    NSString *url;
//    NSArray *images;
//    UIViewController<TwitterDelegate> *delegate;
}

+ (TwitMe *)sharedInstance;
- (BOOL)addParamenterToTweet;
- (void)showModal;
- (BOOL)removeAllImages;
- (BOOL)removeAllURLs;

@property(nonatomic, strong) UIViewController<TwitterDelegate> *delegate;
@property(nonatomic, strong) NSArray *images;
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *textTwit;

@end
