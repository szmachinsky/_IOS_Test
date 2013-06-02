//
//  TestCountViewController.m
//  Test_1
//
//  Created by svp on 25.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TestCountViewController.h"
//#import "UserInfo.h"

@implementation TestCountViewController
{
    NSString *strZomb; 
    NSArray *arrZomb;     
}

@synthesize label2;
@synthesize label3;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        strZomb = [NSString stringWithFormat:@"string"];
        arrZomb = [[NSArray alloc] init];
        [arrZomb release];
    }
    return self;
}

- (void)showCount
{
    NSLog(@" %d %d %d %d view=%d",label1.retainCount, label2.retainCount, label3.retainCount, label4.retainCount, self.view.retainCount);
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"!-TestCount-didReceiveMemoryWarning");
//    if (!self->_view) NSLog(@"   view == nil!!!");
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)dealloc {
NSLog(@"--dealloc");
//if (!self.view) NSLog(@"   view == nil!!!");

    [self showCount];

    [label1 release];
    [label2 release];

    [label3 release];
//    [label3 release];

    [imageView1_ release];
    [imageView2_ release];
    
//    [waitView_ release];
    
    [text_ release];
    [do3_ release];
    
[super dealloc];
}

- (void)viewDidUnload
{
    NSLog(@"--TestCount-viewDidUnload");
//    if (!self->_view) NSLog(@"   view1 == nil!!!");
    
//  [self showCount];
    
    [label1 release];
    label1 = nil;
    
    [self setLabel2:nil];
    
    [label3 release];    
    label3 = nil;
    
    [self setLabel3:nil];
    
    [imageView1_ release];
    imageView1_ = nil;
    
    [imageView2_ release];
    imageView2_ = nil;
    
    
    [text_ release];
    text_ = nil;
    [do3_ release];
    do3_ = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
//    if (!self.view) NSLog(@"   view2 == nil!!!");
}

- (void)viewDidLoad
{
    NSLog(@"-+viewDidLoad");
    if (!self.view) NSLog(@"   view == nil!!!");
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    CGRect frame = CGRectMake(100, 200, 90, 30);
    label4 = [[UILabel alloc] initWithFrame:frame];
    label4.text = @"new label";
    [self.view addSubview:label4];
    [label4 release];
    
    [self showCount];
    self.navigationItem.title = @"Count";
    
    
    waitView_ = [[[WaitView alloc] initWithFrame:self.view.frame] autorelease] ;
    [self.view addSubview:waitView_];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"-+viewWillAppear");    
}

- (void)viewWillDisappear:(BOOL)animated 
{
    [super viewWillDisappear:animated];    
    NSLog(@"--viewWillDisappear");
    
    [UserTool netActivityStop];
    [waitView_ hideWaitScreen];     
}

    

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

//==================================================
- (IBAction)pressBack:(id)sender {
    NSLog(@"--pressBack");
    [self showCount];
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissModalViewControllerAnimated:YES];        
    }
}

- (IBAction)pressInfo:(id)sender {
    NSLog(@"--pressInfo");
    [self showCount];
}

- (IBAction)pressDO1:(id)sender {
    int i = [UserInfo shared].idd;
    NSLog(@"--pressDO1 i=%d",i); 
    [UserTool netActivityON];
//    [waitView_ showWaitScreen];
    
    self.view.userInteractionEnabled = NO;
}

- (IBAction)pressDO2:(id)sender {
    NSLog(@"--pressDO2");  
    [UserTool netActivityOFF];   
    [waitView_ hideWaitScreen];
}

- (void)changeImage:(UIImageView*)imView Image:(UIImage*)image Duration:(NSTimeInterval)dur 
{
    [UIView transitionWithView:imView duration:dur 
//                       options:UIViewAnimationOptionTransitionFlipFromBottom
//                       options:UIViewAnimationOptionTransitionFlipFromLeft  
                         options:UIViewAnimationOptionTransitionCrossDissolve
//                       options:UIViewAnimationOptionTransitionCurlDown     
                    animations:^{ [imView setImage:image]; }     
                    completion:NULL];     
}


- (IBAction)pressDO3:(id)sender {
    UIImage *im = [UserTool thumbnailFromImage:imageView1_.image  forSize:80 radius:0.0];
//  UIImage *im = [UserTool thumbnailFromImage:[UIImage imageNamed:@"01.png"]  forSize:80];

//  imageView2_.image = im;
    [self changeImage:imageView2_ Image:im Duration:0.80];
    
//    BOOL ok = FALSE;
//    NSAssert(ok, @"Couldn't remove temp file");
}                   
//------------------------------------------------------------------------------


- (IBAction)pressZombie:(id)sender {
NSLog(@"press Zombie"); 
//    [arrZomb release];
//    [strZomb release];
    
//    NSLog(@"(%@)",strZomb);
   
//    int i1 = [arrZomb retainCount];
//    int i2 = [strZomb retainCount];
//    int idd = [arrZomb indexOfObject:@"str"];
    
    NSArray *a1 = [NSArray arrayWithObject:@"string"];
    NSLog(@"%@",a1);
    NSData *dat = [NSKeyedArchiver archivedDataWithRootObject:a1];
    NSArray *a2 = [NSKeyedUnarchiver unarchiveObjectWithData:dat];
    NSLog(@"%@",a2);
        
//    NSLog(@"(%d %d %d )",i1,i2,idd); 
    
NSLog(@"exit Zombie");     
}



@end
