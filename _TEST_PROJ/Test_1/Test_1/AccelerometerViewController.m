//
//  AccelerometerViewController.m
//  Test_1
//
//  Created by svp on 30.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AccelerometerViewController.h"

@implementation AccelerometerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [imageView_ release];
    [textField_ release];
    [super dealloc];
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
    [imageView_ release];
    imageView_ = nil;
    [textField_ release];
    textField_ = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Accelerometr page";
    
    color = [UIColor redColor];
    imageView_.backgroundColor = color; 
    
    [UserTool shiftRandom:100];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    
    NSLog(@"Monitoring accelerometer ON"); 
    UIAccelerometer *a = [UIAccelerometer sharedAccelerometer]; 
    // Receive updates every 1/10th of a second. 
    [a setUpdateInterval:0.1];
    [a setDelegate:self];
//    a.updateInterval = 0.1;
//    a.delegate = self;
    
    // Get the device object for DEVICE ORIENTATION
    UIDevice *device = [UIDevice currentDevice];
    // Tell it to start monitoring the accelerometer for orientation
    [device beginGeneratingDeviceOrientationNotifications];
    // Get the notification center for the app
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    // Add yourself as an observer
    [nc addObserver:self selector:@selector(orientationChanged:)
               name:UIDeviceOrientationDidChangeNotification object:device];       
}


- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
    
    if (![self isFirstResponder])
        [self becomeFirstResponder]; //set self to First responder for Shake!  
    
}


- (void)viewWillDisappear:(BOOL)animated 
{
    [super viewWillDisappear:animated];
    
    NSLog(@"Monitoring accelerometer OFF"); 
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil]; //turn off Accelerometr
    
    [self.view endEditing:YES];
}

- (BOOL)canBecomeFirstResponder
{	
    return YES; 
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//======================Accelerometr==================================
#pragma mark - Accelerometr 
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)accel 
{
	NSLog(@"%f, %f, %f", [accel x], [accel y], [accel z]);    
}

//========================Shakes================================
#pragma mark - Shakes
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"motion Began");
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"motion Ended");      
    if ([self isFirstResponder]) {
        NSLog(@"hey, you shook me!");
        if (motion == UIEventSubtypeMotionShake) 
        { 
            NSLog(@"shake started"); 
            float r, g, b; 
            r = random() % 256 / 255.0; 
            g = random() % 256 / 255.0; 
            b = random() % 256 / 255.0; 
            NSLog(@"%f %f %f", r, g, b);
            color = [UIColor colorWithRed:r green:g blue:b alpha:1]; 
//          imageView_.backgroundColor = color;
            self.view.backgroundColor = color;
        }         
    } else
        [super motionEnded:motion withEvent:event];
    
    
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"motion Cancelled");    
}


//========================Orientation================================
#pragma mark - Orientation
- (void)orientationChanged:(NSNotification	*)note
{
    // Log the constant that represents the current orientation
//    NSLog(@"orientationChanged:	%d", [[note	object]	orientation]);
    NSLog(@"orientationChanged to:	%d  current is:%d", [[note	object]	orientation], self.interfaceOrientation);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"did rotate from:%d  to:%d", fromInterfaceOrientation, self.interfaceOrientation);
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)x
                                         duration:(NSTimeInterval)duration
{
    CGRect bounds = [[self view] bounds];
    // If the orientation is rotating to Portrait mode...
    if (UIInterfaceOrientationIsPortrait(x)) {
        // Put the button in the top right corner
        [imageView_ setCenter:CGPointMake(bounds.size.width - 75,75)];
 
        imageView_.backgroundColor = [UIColor blueColor];
    } else {  // If the orientation is rotating to Landscape mode   
        [imageView_ setCenter:CGPointMake(75,200)];        
        imageView_.backgroundColor = [UIColor greenColor];
    }
    
}    

@end






