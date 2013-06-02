//
//  TwitMe.m
//  Test_3
//
//  Created by Sergei on 29.05.13.
//  Copyright (c) 2013 Sergei. All rights reserved.
//


#import "TwitMe.h"

TwitMe *sharedViewController = nil;

@implementation TwitMe
@synthesize delegate;
@synthesize images = _images;
@synthesize url = _url;
@synthesize textTwit = _textTwit;

+ (TwitMe *)sharedInstance
{
    @synchronized(self)
	{
		if (!sharedViewController)
        {
			sharedViewController = [[TwitMe alloc] init];
        }
        
		return sharedViewController;
	}
}

- (BOOL)addParamenterToTweet
{
    [self setInitialText:self.textTwit];
    
    if ([self.images count] > 0)
    {
        for (UIImage *imgs in self.images)
            [self addImage:imgs];
    }
    
    [self addURL:[NSURL URLWithString:self.url]];
    
    NSLog(@"%@, %d, %@", self.textTwit, [self.images count], self.url);
    
    return YES;
}

- (BOOL)removeAllImages
{
    return [self removeAllImages];
}

- (BOOL)removeAllURLs
{
    return [self removeAllURLs];
}

+ (BOOL)canSendTweet
{
    return [TWTweetComposeViewController canSendTweet];
}



- (void)showModal
{
    if ([self.delegate respondsToSelector:@selector(twitterResult:)])
    {
        if ([self.delegate respondsToSelector:@selector(twitterResult:)])
        {
            [self addParamenterToTweet];
            [self.delegate presentViewController:self
                                        animated:YES
                                      completion:^(void)
             {
                 [self.delegate twitterResult:self];
             }];
        }
    }
}

@end


