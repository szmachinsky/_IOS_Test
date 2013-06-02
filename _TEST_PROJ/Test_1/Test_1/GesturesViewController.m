//
//  GesturesViewController.m
//  Test_1
//
//  Created by svp on 06.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GesturesViewController.h"


@implementation UIImageView(MyGestures) 
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint loc = [[touches anyObject] locationInView: self.superview];
    CGPoint oldP = [[touches anyObject] previousLocationInView: self.superview];
    CGFloat deltaX = loc.x - oldP.x;
    CGFloat deltaY = loc.y - oldP.y;
    CGPoint c = self.center;
    c.x += deltaX;
    c.y += deltaY;
    self.center = c;
}
@end


@implementation MyView : UIView 
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint loc = [[touches anyObject] locationInView: self.superview];
    CGPoint oldP = [[touches anyObject] previousLocationInView: self.superview];
    CGFloat deltaX = loc.x - oldP.x;
    CGFloat deltaY = loc.y - oldP.y;
    CGPoint c = self.center;
    c.x += deltaX;
    c.y += deltaY;
    self.center = c;
}    
@end


@implementation GesturesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [view1_ release];
    view1_ = nil;
    [image1_ release];
    image1_ = nil;
    [view2_ release];
    view2_ = nil;
    [label1_ release];
    label1_ = nil;
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
    [view1_ release];
    [image1_ release];
    [view2_ release];
    [label1_ release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Gestures";
    

    
    UITapGestureRecognizer* t1 = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                  action:@selector(single_Tap:)];
    [view2_ addGestureRecognizer:t1]; 
 //   [self.view addGestureRecognizer:t1]; 
    
    
    
    UITapGestureRecognizer* t2 = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(doubleTap)];
    t2.numberOfTapsRequired = 2;    
    [view2_ addGestureRecognizer:t2]; 
    
    
    UIPanGestureRecognizer* p3 = [[UIPanGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(dragging2:)];
    [view2_ addGestureRecognizer:p3];
    // ...
      

}


//======================================================================


- (void) singleTap {
    NSLog(@"_singleTap");
}  

- (void) single_Tap: (UITapGestureRecognizer*) p  {
    UIView* vv = p.view;  
    
    NSString * clsName = NSStringFromClass ( [vv class] );
    NSLog(@"_single_Tap in class %@",clsName);
}  



- (void) doubleTap {
    NSLog(@"__doubleTap");
}    

- (void) dragging1: (UIPanGestureRecognizer*) p 
{
    UIView* vv = p.view;
    if (p.state == UIGestureRecognizerStateBegan)
        self->origC = vv.center;
    CGPoint delta = [p translationInView:vv.superview];    
    CGPoint c = self->origC;
    c.x += delta.x; c.y += delta.y;
    vv.center = c;    
}

- (void) dragging2: (UIPanGestureRecognizer*) p 
{
    UIView* vv = p.view;
    if (p.state == UIGestureRecognizerStateBegan ||
        p.state == UIGestureRecognizerStateChanged) {
        CGPoint delta = [p translationInView: vv.superview];
        CGPoint c = vv.center;
        c.x += delta.x; c.y += delta.y;
        vv.center = c;
        [p setTranslation: CGPointZero inView: vv.superview];
    }
}


@end
