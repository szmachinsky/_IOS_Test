//
//  YandexTest_VC.m
//  test_nav_xib
//
//  Created by Sergei on 24.11.14.
//  Copyright (c) 2014 Sergei. All rights reserved.
//

#import "YandexTest_VC.h"

@interface YandexTest_VC ()

@end

@implementation YandexTest_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"YANDEX_TEST";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)pressButton:(id)sender {
//    int x = 0;
//    int16_t y = 1;
//    int16_t z = -1;
//    int16_t z1 = -2;
//    x = y + z;
//    NSLog(@"%X  %X  %X",y,z,z1);
    char cArr[11] = {'a','b','c','r','t','a','c','c','u','y','z'};
    char res = mostFrequentCharacter(cArr, sizeof(cArr));
    NSLog(@"FOUND = (%c)",res);
}



char mostFrequentCharacter(char* str, int size)
{
    __block char res = '?';
    __block int ready = 0;
    
    char (^blmax)(char*, int, int) = ^char(char* str, int size, int n) {
        char c;
        char maxChar = '?';
        int maxNum = 0;
        int holder[256];
        memset(holder, 0, sizeof(holder));
        for (int i = 0; i<size; i++) {
            c = str[i];
            holder[c] +=1;
            if (holder[c] > maxNum) {
                maxNum = holder[c];
                maxChar = c;
            }
        }
        NSLog(@"FOUND_%d: Bl_maxInd = %d  maxChar=%c",n,maxNum,maxChar);
        return maxChar;
    };
    
    
//  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t queue = dispatch_queue_create("running.thread_1", DISPATCH_QUEUE_SERIAL);//DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"--start thread1--");
        char c1 = blmax(str,size,1);
        NSLog(@"--end1 thread1 =%c--",c1);
            ready +=1;
            res = c1;
            NSLog(@"--end2 thread1 =%d  c=%c--",ready,c1);
    });
    
//    dispatch_sync(dispatch_queue_create("running.thread_2", NULL), ^{
//        NSLog(@"--start thread2--");
//        char c2 = blmax(str,size,2);
//        NSLog(@"--end thread2--");
//        dispatch_async(dispatch_get_main_queue(), ^{
//            ready +=1;
//            res = c2;
//            NSLog(@"--thread2 =%d  c=%c--",ready,res);
//        });
//    });
    
    NSLog(@"--start thread2--");
    char c2 = blmax(str,size,2);
    NSLog(@"--end thread2 =%c--",c2);
    
    NSLog(@"-wait1-");
//    while (ready == 0) {
//    }
    
    dispatch_barrier_sync(queue, ^{
        NSLog(@"+dispatch_barrier_sync-");
    });
//    dispatch_barrier_async(queue, ^{
//        NSLog(@"+dispatch_barrier_async-");
//    });
    
    NSLog(@"-end wait2-");

//    dispatch_release(queue);
    
//    @synchronized(self) {
//        
//    }
    
    NSLog(@"ALL res=%c",res);
    return res;
}




//==============================================================================
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self testSubview];
};



typedef UIView* (^Block_Check)(UIView* v);
#define max_search_dip_level 25


-(void)testSubview
{
    NSString *s = self.navigationItem.prompt;
    
    Block_Check block = ^UIView*(UIView* v) {
        if ([v isKindOfClass:[UIActivityIndicatorView class]]) {
//            if ([((UILabel*)(v)).text isEqual:s]) {
                return v;
//            }
        }
        return nil;
    };
    
    UIActivityIndicatorView *aViev = (UIActivityIndicatorView*)[self findInSubviews:self.view block:block];
    if (aViev) {
        NSLog(@"-- found --");
    } else {
        NSLog(@"-- not found --");        
    }
    
}


-(UIView*)findInSubviews:(UIView*)v block:(Block_Check)find_block
{
    static int level = 0;
    NSArray *subviews = v.subviews;
    __block UIView *findView = nil;
    
    @try
    {
        level++;
    NSLog(@"\n\n  --------------->> find in:%@  /subviews=%lu --level=%d-------\n",NSStringFromClass([v class]),(unsigned long)v.subviews.count,level);
        if (level > max_search_dip_level) {
            return findView;
        }
        [subviews enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL *stop) {
            if (find_block(view)) {
                NSLog(@" >>> YES FOUND in (%@) at level %d!!!! \n",NSStringFromClass([view class]),level);
                *stop = YES;
                findView = view;
            }
        }];
        if (!findView) {
            for (UIView *v in subviews) {
                if (v.subviews.count) {
                    UIView *vi = [self findInSubviews:v block:find_block];
                    if (vi) {
                        findView = vi;
                        break;
                    }
                }
            }
        }
    } //try
    @finally {
        level--;
        return findView;
    }

}


@end



