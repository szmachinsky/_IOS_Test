//
//  LoadFiles_VC.m
//  test_nav_xib
//
//  Created by Sergei on 07.11.14.
//  Copyright (c) 2014 Sergei. All rights reserved.
//

#import "LoadFiles_VC.h"

#import "CustomView.h"

@interface LoadFiles_VC ()
@property (weak, nonatomic) IBOutlet UIImageView *im1;
@property (weak, nonatomic) IBOutlet UIImageView *im2;

@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;

@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;


@end



@implementation LoadFiles_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"_TEST_03_";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    NSLog(@"viewDidUnload");
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
}

-(void)dealloc{
    NSLog(@"dealloc");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)pressBtn1:(id)sender {
    self.im1.image = nil;
    [self Load1];
}

- (IBAction)pressBtn2:(id)sender {
    self.im2.image = nil;
    [self Load2];
}

- (void)Load1
{
//  NSString *requestUrl = @"http://std3.ru/41/75/1415030144-4175dfd00f9014b5a961e0f0d02abd07.jpg";
    NSString *requestUrl = @"http://www.reactionimage.org/img/gallery/9642880587.jpg";
   
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:requestUrl];
    NSLog(@"URL1 = %@",requestUrl);
    
    
//  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    dispatch_async(dispatch_queue_create("load_pictire1", NULL), ^{
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10];
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
//          [self.actIndicator stopAnimating];
            if (data) {
                NSLog(@"LOADED1 %d bytes",data.length);
                UIImage *im = [UIImage imageWithData:data];
                self.im1.image = im;
            } else {
                NSLog(@"NO DATA1");
                if (error) {
                    NSLog(@"ERROR1 %@",error.description);
                }
            }
        });
    });
}


- (void)Load2
{
    NSString *requestUrl = @"http://std3.ru/41/75/1415030144-4175dfd00f9014b5a961e0f0d02abd07.jpg";
//  NSString *requestUrl = @"http://www.reactionimage.org/img/gallery/9642880587.jpg";
    
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:requestUrl];
    NSLog(@"URL2 = %@",requestUrl);
    
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url
                                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                   timeoutInterval:10];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:nil];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:req  //downloadTaskWithURL:url
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
         dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSLog(@"LOADED2 %d bytes",data.length);
                UIImage *im = [UIImage imageWithData:data];
                self.im2.image = im;
            } else {
                NSLog(@"NO DATA2");
                if (error) {
                    NSLog(@"ERROR2 %@",error.description);
                }
            }
         });
            
            
        }];
    [task resume];
    
}


- (void)Load22
{
    NSString *requestUrl = @"http://std3.ru/41/75/1415030144-4175dfd00f9014b5a961e0f0d02abd07.jpg";
    //  NSString *requestUrl = @"http://www.reactionimage.org/img/gallery/9642880587.jpg";
    
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:requestUrl];
    NSLog(@"URL2 = %@",requestUrl);
    
    
    //    NSString *identifier = @"io.objc.backgroundTransferExample";
    //    NSURLSessionConfiguration* sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfiguration:identifier];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.HTTPMaximumConnectionsPerHost = 5;
    sessionConfiguration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    sessionConfiguration.timeoutIntervalForRequest = 10;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:nil];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url  //downloadTaskWithURL:url
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (data) {
                    NSLog(@"LOADED2 %d bytes",data.length);
                    UIImage *im = [UIImage imageWithData:data];
                    self.im2.image = im;
                } else {
                    NSLog(@"NO DATA2");
                    if (error) {
                        NSLog(@"ERROR2 %@",error.description);
                    }
                }
            });
            
            
        }];
    [task resume];
    
}


//======================================================================
- (IBAction)pressBtn3:(id)sender {
    CustomView *v = [CustomView loadView];
    
    v.custLabel.text = @"loaded1";
//    CGRect f = self.view1.bounds;
    [self.view1 addSubview:v];
//    v.frame = f;
}

- (IBAction)pressBtn4:(id)sender {
    NSArray* views=[[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:nil options:nil];
    CustomView *v = [views firstObject];

    v.custLabel.text = @"loaded2";
//    CGRect f = self.view1.bounds;
    [self.view2 addSubview:v];
//    v.frame = f;

    
}



@end
