//
//  AnimationViewController.m
//  Test_1
//
//  Created by svp on 09.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AnimationViewController.h"

@implementation AnimationViewController

- (CABasicAnimation*)makeSpinAnimation
{
    // Create a basic animation 
    CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation"]; 
    [spin setToValue:[NSNumber numberWithFloat:M_PI * 2.0]]; 
    [spin setDuration:1.5];         
    // Set the timing function 
    CAMediaTimingFunction *tf = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; 
    [spin setTimingFunction:tf];         
    [spin setDelegate:self]; 
    return spin;
}

- (CAKeyframeAnimation*)makeBounceAnimation
{
    // Create a key frame animation 
    CAKeyframeAnimation *bounce = [CAKeyframeAnimation animationWithKeyPath:@"transform"];     
    // Create the values it will pass through 
    CATransform3D forward = CATransform3DMakeScale(1.5, 1.5, 1); 
    CATransform3D back = CATransform3DMakeScale(0.5, 0.5, 1); 
    CATransform3D forward2 = CATransform3DMakeScale(1.3, 1.3, 1); 
    CATransform3D back2 = CATransform3DMakeScale(0.7, 0.7, 1); 
    CATransform3D forward3 = CATransform3DMakeScale(1.1, 1.1, 1); 
    CATransform3D back3 = CATransform3DMakeScale(0.9, 0.9, 1); 
    [bounce setValues:[NSArray arrayWithObjects: 
                       [NSValue valueWithCATransform3D:CATransform3DIdentity], 
                       [NSValue valueWithCATransform3D:forward], 
                       [NSValue valueWithCATransform3D:back], 
                       [NSValue valueWithCATransform3D:forward2], 
                       [NSValue valueWithCATransform3D:back2], 
                       [NSValue valueWithCATransform3D:forward3], 
                       [NSValue valueWithCATransform3D:back3], 
                       [NSValue valueWithCATransform3D:CATransform3DIdentity], 
                       nil]]; 
    // Set the duration 
    [bounce setDuration:1.5];     
    [bounce setDelegate:self]; 
    return bounce;
}

- (CABasicAnimation*)makeFaderAnimation
{    
// This animation object will act on a layer's opacity property
    CABasicAnimation *fader = [CABasicAnimation animationWithKeyPath:@"opacity"];
// ... it will last for 1.5 second ... 
    [fader setDuration:1.5]; 
    [fader setFromValue:[NSNumber numberWithFloat:1.0]]; 
    // ... 0.0 where it finishes at t = 2.0 
    [fader setToValue:[NSNumber numberWithFloat:0.2]];
    [fader setDelegate:self];
    return fader;
}

- (CABasicAnimation*)makeMoverAnimation
{ 
    CABasicAnimation *mover = [CABasicAnimation animationWithKeyPath:@"position"];
    [mover setDuration:1.5]; 
//  [mover setFromValue:[NSValue valueWithCGPoint:CGPointMake(140.0, 100.0)]]; 
    [mover setToValue:[NSValue valueWithCGPoint:CGPointMake(180.0, 300.0)]];
    CAMediaTimingFunction *tf = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; 
    [mover setTimingFunction:tf];             
    mover.delegate = self;
    mover.fillMode = kCAFillModeForwards;
    return mover;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // Create a basic animation 
        spin_ = [[self makeSpinAnimation] retain];
        
        // Create a key frame animation 
        bounce_ = [[self makeBounceAnimation] retain];   
        
        fader_ = [[self makeFaderAnimation] retain];
        
        mover_ = [[self makeMoverAnimation] retain];

        boxLayer = [[CALayer alloc] init];
        [boxLayer setBounds:CGRectMake(0.0, 0.0, 85.0, 85.0)];
        [boxLayer setPosition:CGPointMake(160.0, 120.0)];
        UIColor *reddish = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
        CGColorRef cgReddish = [reddish CGColor];
        [boxLayer setBackgroundColor:cgReddish];    
        
        [self.view.layer addSublayer:boxLayer];
        [boxLayer release];
        
    }
    return self;
}

- (void)dealloc {
    [label_ release];
    
    [spin_ release];
    [bounce_ release];
    [fader_ release];
    [mover_ release];
    
    [view_ release];
    [imView_ release];
//    [boxLayer release];
    
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
    [label_ release];
    label_ = nil;
    
    [view_ release];
    view_ = nil;
    [imView_ release];
    imView_ = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSDate *now = [NSDate date]; 
    static NSDateFormatter *formatter = nil; 
    if	(!formatter)	{ 
        formatter = [[NSDateFormatter alloc] init]; 
        //        [formatter setDateStyle:NSDateFormatterShortStyle]; 
        [formatter setDateStyle:NSDateFormatterLongStyle];
    } 
    [label_ setText:[formatter stringFromDate:now]]; 
    
    
    
    
    NSMutableArray* arr = [NSMutableArray array];
    float w = 18;
    for (int i = 0; i < 6; i++) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(w,w), NO, 0);
        CGContextRef con = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(con, [UIColor redColor].CGColor);
        CGContextAddEllipseInRect(con, CGRectMake(0+i,0+i,w-i*2,w-i*2));
        CGContextFillPath(con);
        UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [arr addObject:im];
    }
    UIImage* im = [UIImage animatedImageWithImages:arr duration:0.5];
    UIButton* b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [b setTitle:@"Howdy" forState:UIControlStateNormal];
    [b setImage:im forState:UIControlStateNormal];
    b.center = CGPointMake(220,100);
    [b sizeToFit];
    [self.view addSubview:b];    
}

//=====================================================


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag 
{ 
    NSLog(@" (%@) -Animation finished: %d", anim, flag); 
} 

- (void)animationDidStart:(CAAnimation *)anim 
{
    NSLog(@" (%@) +Animation started for %f sec", anim, anim.duration) ;     
}


- (void)animationDid_Finished:(CAAnimation *)anim 
{
    NSLog(@" (%@) +Animation started for %f sec", anim, anim.duration) ;     
}



- (IBAction)press1:(id)sender {
    [CATransaction setDisableActions:YES]; 
//    [CATransition setCompletionBlock:^(BOOL f){NSLog(@"animation stop");} ];
    [[label_ layer] addAnimation:spin_ forKey:@"spinAnimation"]; 
 }

- (IBAction)press2:(id)sender {
    [CATransaction setDisableActions:YES];     
    [[label_ layer] addAnimation:bounce_ forKey:@"bounceAnimation"];         
}


- (IBAction)press3:(id)sender {
    [CATransaction setDisableActions:YES];     
    [[label_ layer] addAnimation:mover_ forKey:@"moverAnimation"];         
}

- (IBAction)press4:(id)sender {
    [CATransaction setDisableActions:YES];     
    [[label_ layer] addAnimation:fader_ forKey:@"faderAnimation"]; 
    [label_ layer].opacity = 0.5; 
 }

- (IBAction)press5:(id)sender {
    CALayer* c = boxLayer;//[view_ layer];
//    CALayer* c = [view_ layer];
    
    [CATransaction begin];
    
//  [CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions]; //disable implicit animation
//  [CATransaction setDisableActions:YES]; 
        
    [CATransaction setAnimationDuration:2.5];
   
    
    c.transform = CATransform3DRotate(c.transform, M_PI/4.0*5.0, 0, 0, 1);
    c.position = CGPointMake(250, 350);
    

    [CATransaction commit];    
    
}

- (IBAction)pressGroup:(id)sender {
/*    
    [[label_ layer] addAnimation:spin_ forKey:@"spinAnimation"];          
    [[label_ layer] addAnimation:mover_ forKey:@"moverAnimation"];         
    return;
*/    
    
    CAAnimationGroup *group = [CAAnimationGroup animation]; 
//  [group setAnimations:[NSArray arrayWithObjects:fader_, mover_, nil]]; 
    [group setAnimations:[NSArray arrayWithObjects:spin_, mover_, fader_, nil]]; 
    [group setDelegate:self];
    group.duration = 1.5;
    [mover_ setFromValue:[NSValue valueWithCGPoint:[label_ layer].position]];
    
    // Animate the layer 
    [[label_ layer] addAnimation:group forKey:nil];
    
    [label_ layer].position = CGPointMake(180.0, 300.0);
    [label_ layer].opacity = 0.2;
}

- (IBAction)pressGroup2:(id)sender {
    CAAnimationGroup *group = [CAAnimationGroup animation]; 
    [group setAnimations:[NSArray arrayWithObjects:spin_, mover_, fader_, nil]]; 
    [group setDelegate:self];
    spin_.beginTime = 0.0;
    mover_.beginTime = spin_.duration;
    fader_.beginTime = spin_.duration +mover_.duration;
    group.duration = spin_.duration + mover_.duration + fader_.duration;
    [mover_ setFromValue:[NSValue valueWithCGPoint:[label_ layer].position]];
    
    // Animate the layer 
    [[label_ layer] addAnimation:group forKey:nil];
    
 //   [label_ layer].position = CGPointMake(180.0, 300.0);
 //   [label_ layer].opacity = 0.2;    
}




@end
