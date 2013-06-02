//
//  ThreadViewController.m
//  Test_1
//
//  Created by svp on 19.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ThreadViewController.h"
#import "MyCalc.h"
#import "MyOperation.h"


#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define kLatestKivaLoansURL [NSURL URLWithString:@"http://api.kivaws.org/v1/loans/search.json?status=fundraising"] //2


@implementation ThreadViewController
{    
    IBOutlet UILabel *label_;
    
    IBOutlet UIView *view_;
    
    NSTimer* timer_;
    
    NSOperationQueue *queue_;
    
    dispatch_queue_t gcd_queue_;

}
@synthesize queue = queue_;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self->gcd_queue_ = dispatch_queue_create("test.queue", NULL); 
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [label_ release];
    label_ = nil;
    [view_ release];
    view_ = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [label_ release];
    [view_ release];
    
    [timer_ invalidate];
    timer_ = nil;
    
    [self.queue cancelAllOperations]; 
    self.queue = nil; 
    
    dispatch_release(gcd_queue_); 

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)runTimer
{ 
    static int col = 0;
    col++;
    if (col % 2 == 0) {
        view_.backgroundColor = [UIColor redColor]; }
    else {
         view_.backgroundColor = [UIColor greenColor]; }
  
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    timer_=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(runTimer) userInfo:nil repeats:YES];      
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [timer_ invalidate];
    timer_ = nil;
}

//=========================================
#pragma mark - Actions for calculations

- (int)method2:(int)var
{  
    sleep(5);
    NSLog(@"  >>met2:%d",var);      
    return (var * 10);  
}

- (int)method1:(int)var
{
    NSLog(@"  >>met1:%d",var);
    int res = [self method2:var] + 1;
    return res;
}


//=========================================
- (IBAction)testPress:(id)sender {
    static int count = 0;
    count++;
    NSLog(@"  count = %d",count);
}

//===============No Threads==========================
- (IBAction)press1:(id)sender {
    label_.text = nil;
    int res1 = [self method1:5];
    label_.text = [NSString stringWithFormat:@" main1_1=%d",res1];
}

- (IBAction)press2:(id)sender {
    label_.text = nil;
    int res2 = [[[[MyCalc alloc] init ] autorelease ] calc:5];
    label_.text = [NSString stringWithFormat:@" main2_2=%d",res2];
    
}

//==============Old Style==========================

// called on main thread! background thread exit point 
- (void) allDone: (NSDictionary*) dd { 
    int res = [[dd objectForKey:@"result"] intValue];
    label_.text = [NSString stringWithFormat:@" thr1_1=%d",res];    
}

// trampoline, background thread entry point 
- (void) enterToThread: (NSDictionary*) d { 
//  NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init]; 
    @autoreleasepool {  
//      int res = [self method1:[[d objectForKey:@"value"] intValue] ]; //run job 
        int res = [[[[MyCalc alloc] init ] autorelease ] calc:5];
        
        NSDictionary *dd = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:res], @"result", nil];        
        [self performSelectorOnMainThread:@selector(allDone:)            //get results back
                               withObject:dd waitUntilDone:NO];   
        [dd release];
        
    }    
//  [pool release]; 
} 


- (IBAction)back1:(id)sender {
    label_.text = nil;
    NSDictionary* d = [[NSDictionary alloc] initWithObjectsAndKeys: 
//                     [NSValue valueWithCGPoint:center], @"center", 
                       [NSNumber numberWithInt: 5], @"value", 
                       nil]; 
    [self performSelectorInBackground:@selector(enterToThread:) withObject:d]; 
    [d release];         
}



//=========================================

- (void)operationFinished: (NSNotification*) n  //RUN on BACK THREAD!!!
{
    [self performSelectorOnMainThread:@selector(endOperation:) 
                           withObject:[n object] waitUntilDone:NO];    
}

// now we're back on the main thread 
- (void) endOperation: (MyOperation*) op { 
    [[NSNotificationCenter defaultCenter] 
     removeObserver:self name:@"MyOperationFinished" object:op]; 
    
    int res = op.val;
    label_.text = [NSString stringWithFormat:@" oper1_1=%d",res];        
} 


- (IBAction)op1:(id)sender {
    label_.text = nil;
    
    
    if (!self.queue) { 
        NSOperationQueue* q = [[NSOperationQueue alloc] init]; 
        self.queue = q; // retain policy 
        [q release]; 
    } 
    
    NSOperation* op = [[MyOperation alloc] initWithInt:10];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(operationFinished:) 
                                                 name:@"MyOperationFinished" 
                                               object:op]; 
    [self.queue addOperation:op]; 
    [op release];     
    
    
}


//=========================================
- (IBAction)gcd1:(id)sender {
    NSLog(@"-gcd1"); 
    
    UIBackgroundTaskIdentifier bti = [[UIApplication sharedApplication] 
                                      beginBackgroundTaskWithExpirationHandler: ^{ 
                                          [[UIApplication sharedApplication] endBackgroundTask:bti]; 
                                      }];
    
///    UIBackgroundTaskIdentifier bt = [[UIApplication sh] beginBackgroundTaskWithExpirationHandler:<#^(void)handler#>];
    
    dispatch_async(gcd_queue_, ^{ 
//  dispatch_async(dispatch_get_global_queue(0,0), ^{ 
     
//      int res = [self method1:20]; //run job 
        
        MyCalc *my = [[MyCalc alloc] init ];
        int res = [my calc:20];
        [my release];
         
        dispatch_async(dispatch_get_main_queue(), ^{ 
            label_.text = [NSString stringWithFormat:@" gcd1_1=%d",res];         
            NSLog(@"-gcd3");  
            
            [[UIApplication sharedApplication] endBackgroundTask:bti]; 
        }); 
    }); 
    NSLog(@"-gcd2");    
}


//=========================================
//=========================================

//dispatch_get_global_queue(0)


@end
