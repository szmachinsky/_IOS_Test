//
//  Test3_VC.m
//  test_nav_xib
//
//  Created by Sergei on 19.10.14.
//  Copyright (c) 2014 Sergei. All rights reserved.
//

#import "Test3_VC.h"

#ifdef use_FIC_Cache
#import "FICImageCache.h"
//#import "FICDPhoto.h"
#endif


#ifdef use_SDW_Cache
//  #import "UIImageView+WebCache.h"
    #import "SDWebImageManager.h"
#endif

#ifdef use_Haneke_Cache
    #import "Haneke.h"
#endif



@interface Test3_VC ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *blureView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@property (weak, nonatomic) IBOutlet UIButton *but1;
@property (weak, nonatomic) IBOutlet UIButton *but2;
@property (weak, nonatomic) IBOutlet UIButton *but3;

@end

@implementation Test3_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"_TEST_03_";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
#ifdef use_SDW_Cache
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager.imageCache clearMemory];
//    [manager.imageCache clearDisk];
    
#endif
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)pressBut1:(id)sender {
//  NSString *requestUrl = @"http://std3.ru/41/75/1415030144-4175dfd00f9014b5a961e0f0d02abd07.jpg"; //kot
//  NSString *requestUrl = @"http://www.reactionimage.org/img/gallery/9642880587.jpg"; //цирк
//    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url = [NSURL URLWithString:requestUrl];
//    NSData *dat = [NSData dataWithContentsOfURL:url];
//    if (dat) {
//        UIImage *im = [UIImage imageWithData:dat];
//        self.imageView.image = im;
//        self.imageView2.image = im;
//    }
    
    [self loadWithCache:@"http://std3.ru/41/75/1415030144-4175dfd00f9014b5a961e0f0d02abd07.jpg"]; //кот
}

- (IBAction)pressBut2:(id)sender {
    [self loadWithCache:@"http://www.reactionimage.org/img/gallery/9642880587.jpg"]; //цирк
//    [self loadWithCache_SD:@"http://www.reactionimage.org/img/gallery/9642880587.jpg"]; //цирк
}

- (IBAction)pressBut3:(id)sender {
//    [self loadWithCache:@"https://v1.std3.ru/c4/6f/1430398852-c46ff5fde79cc7ff952235910138ecea.jpg"]; //еда
    
//  [self loadWithCache:@"https://v1.std3.ru/7a/6c/1430750460-7a6cc25367d7cb48eaf012f8e14e9688.gif"]; //gif
    
    [self loadWithCache:@"https://v1.std3.ru/85/10/1425725923-8510581837d0f1243797007779fa8211.gif"]; //gif - medved + guitar
//    [self loadWithCache:@"https://v1.std3.ru/7d/01/1425652504-7d01380112043d0c149b307fc8d17cd1.gif"]; //gif - putin
}


-(void)loadWithCache_SD:(NSString *)requestUrl
{
    self.imageView.image = nil;
    self.imageView2.image = nil;
    NSLog(@"\n\n---begin---");
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSURL *url = [NSURL URLWithString:requestUrl];
    NSString *key = [manager cacheKeyForURL:url];
    BOOL isInMemoryCache = ([manager.imageCache imageFromMemoryCacheForKey:key] != nil);
    
    UIImage *im = [manager.imageCache imageFromDiskCacheForKey:key];
    

    
    NSLog(@"\n---end---");
    
    [self loadWithCache:requestUrl];
}



-(void)loadWithCache:(NSString *)requestUrl
{
    self.imageView.image = nil;
    self.imageView2.image = nil;
    
    
#ifdef use_SDW_Cache
    
    NSLog(@"\n\n---begin---");
//    BOOL ex1 = [[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:requestUrl]];
//    NSLog(@"---exist_1=%d---",ex1);
//    
//    [[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:requestUrl]
//                                                               completion:^(BOOL isInCache){
//                                                                   NSLog(@"---exist_2=%d---",isInCache);
//                                                               }];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:requestUrl]
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                NSLog(@"---completed---");
                                if (image && finished) {
                                    NSLog(@"loaded image /%d/ (%.1f %.1f)",cacheType,image.size.width,image.size.height);
                                    
                                    if (cacheType == SDImageCacheTypeMemory) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            NSLog(@"******* async completion");
                                            self.imageView.image = image;
                                            self.imageView2.image = image;
                                        });
                                    } else {
                                        self.imageView.image = image;
                                        self.imageView2.image = image;
                                    }
                                    
                                }
                            }];
//    });
    
    NSLog(@"\n---end---");
    return;
#endif
    
    
#ifdef use_Haneke_Cache
//  [self.imageView hnk_setImageFromURL:[NSURL URLWithString:requestUrl]];
    UIImageView *im;
    HNKCacheFormat *format = [HNKCache sharedCache].formats[@"thumbnail_110"];
    self.imageView2.hnk_cacheFormat = format;
    [self.imageView2  hnk_setImageFromURL:[NSURL URLWithString:requestUrl]
                            placeholder:nil
                                success:^(UIImage *image){
                                    self.imageView.image = image;
                                    self.imageView2.image = image;
                                }
                                failure:^(NSError *error){
                                    NSLog(@"!!! ERROR!!!!");
                                }];

    return;
#endif
    
    
}


- (IBAction)clearCache:(id)sender {
    [SDWebImageManager.sharedManager.imageCache clearMemory];
    [SDWebImageManager.sharedManager.imageCache clearDisk];
}

@end
