//
//  ViewControllerTest1.m
//  Test_Pic
//
//  Created by Sergei on 01.03.13.
//  Copyright (c) 2013 Sergei. All rights reserved.
//

#import "ViewControllerTest1.h"


//--------------------------------------------------------------------------------
//@implementation UIImageViewT
//@synthesize delegate,selToCall;
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"!!!Began touched... tag=%d",self.tag);
//}
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"!!!Ended touched... tag=%d",self.tag);
//    [delegate performSelector:selToCall withObject:self];
//}
//@end



@interface ViewControllerTest1 ()
{
 
    IBOutlet UIImageView *imageView1;
    
    IBOutlet UIImageView *imageView2;
    
    IBOutlet UILabel *labelText;
    
    IBOutlet UIImageView *imageViewCross;
    
    IBOutlet UIView *markView1;
}

@property (nonatomic, assign) UIView *pieceForReset;

@end



@implementation ViewControllerTest1
{
    float maxX;
    float maxY;
    
    CGAffineTransform tr;
   
    UIImageView *cr1;
    UIImageView *cr2, *cr3;
}
@synthesize pieceForReset; 


//===========================================================================================

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addGestureRecognizersToPiece:imageView1];
    [self addGestureRecognizersToPiece:imageView2];
    
    [self addGestureRecognizersToPiece:labelText];
    
    CGRect rec1 = self.view.frame;
    CGRect rec2 = self.view.bounds;
    CGRect rec3 = [[UIScreen mainScreen] applicationFrame];
    
    maxX = rec1.size.width;
    maxY = rec1.size.height;
    
    rec1 = imageView1.frame;
    rec2 = imageView1.bounds;
    CGPoint p = imageView1.center;
    
//    [imageView1 addSubview:imageViewCross];
//    imageViewCross.frame = CGRectMake(0, 0, 21, 21);
//    imageViewCross.center = CGPointMake(0, 0);
//    [imageView1 addSubview:markView1];
    markView1.frame = CGRectMake(0, 0, 3, 3);
    markView1.center = CGPointMake(149, 0);
    
    
    cr1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Button Close_64.png"]];
    [imageView1 addSubview:cr1];
    cr1.bounds = CGRectMake(0, 0, 21, 21);
    cr1.center = CGPointMake(1, 1);
    cr1.tag = 10;
    cr1.hidden = YES;
    cr1.userInteractionEnabled=YES;
//    [self selectView:imageView1];
    [self addTapRecognizerToView:cr1 forSelector:@selector(tapView:)];
        
    
    cr2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Button Close_64.png"]];
    [imageView2 addSubview:cr2];
    cr2.bounds = CGRectMake(0, 0, 21, 21);
    cr2.center = CGPointMake(1, 1);
    cr2.tag = 10;
    cr2.hidden = YES;
    cr2.userInteractionEnabled=YES;
    [self addTapRecognizerToView:cr2 forSelector:@selector(tapView:)];
    
    cr3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Button Close_64.png"]];
    [labelText addSubview:cr3];
    cr3.bounds = CGRectMake(0, 0, 21, 21);
    cr3.center = CGPointMake(11, 11);
    cr3.tag = 10;
    cr3.hidden = YES;
    cr3.userInteractionEnabled=YES;
    [self addTapRecognizerToView:cr3 forSelector:@selector(tapView:)];
    
    

//    [imageView1 addSubview:markView1];
//    markView1.frame = CGRectMake(0, 0, 5, 5);
    
    tr = imageViewCross.transform;
}

- (void)viewDidUnload
{
    imageView1 = nil;
    imageViewCross = nil;
    imageView2 = nil;
    
    
    labelText = nil;
    markView1 = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


//===========================================================================================================

// adds a set of gesture recognizers to one of our piece subviews
- (void)addGestureRecognizersToPiece:(UIView *)piece
{
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotatePiece:)];
    [piece addGestureRecognizer:rotationGesture];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scalePiece:)];
    [pinchGesture setDelegate:self];
    [piece addGestureRecognizer:pinchGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [piece addGestureRecognizer:panGesture];
    
//    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showResetMenu:)];
//    [piece addGestureRecognizer:longPressGesture];
    
//    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]
//                                  initWithTarget:self
//                                  action:@selector(tapPiece:)];
//    [piece addGestureRecognizer:tapGesture];
    [self addTapRecognizerToView:piece forSelector:@selector(tapPiece:)];
}

- (void)addTapRecognizerToView:(UIView*)view forSelector:(SEL)select
{
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:select];
    [view addGestureRecognizer:tapGesture];
}

//===========================================================================================
NSString *pathInTmpDir(NSString	*fileName)
{
    NSString *sandboxPath = NSHomeDirectory(); //full sandbox path
    NSString *documentPath = [sandboxPath stringByAppendingPathComponent:@"Tmp"];
    return [documentPath stringByAppendingPathComponent:fileName];
}


- (IBAction)toolButton1:(id)sender {
    NSLog(@"Pressed button 1");
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
}
- (IBAction)toolButton2:(id)sender {
    NSLog(@"Pressed button 2");
}
- (IBAction)toolButton3:(id)sender {
    NSLog(@"Pressed button 3");
}
- (IBAction)toolButton4:(id)sender {
    NSLog(@"Pressed button 4");
    
    [self hideCloseButtons];
   
    
//    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
//        UIGraphicsBeginImageContextWithOptions(self.view.window.bounds.size, NO, [UIScreen mainScreen].scale);
//    else
//        UIGraphicsBeginImageContext(self.view.window.bounds.size);    
//    [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    NSData * data = UIImagePNGRepresentation(image);
//    BOOL success = [data writeToFile:pathInTmpDir(@"TmpImg.png") atomically:YES];
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(self.view.bounds.size);
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData * data = UIImagePNGRepresentation(image);
    [data writeToFile:pathInTmpDir(@"TmpImg.png") atomically:YES];
    
}
//===========================================================================================

#pragma mark -
#pragma mark === Utility methods  ===
#pragma mark

// scale and rotation transforms are applied relative to the layer's anchor point
// this method moves a gesture recognizer's view's anchor point between the user's fingers
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
        
//        CALayer *pi = piece.layer;
        
        
    }
}

// display a menu with a single item to allow the piece's transform to be reset
- (void)showResetMenu:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        UIMenuItem *resetMenuItem = [[UIMenuItem alloc] initWithTitle:@"Reset" action:@selector(resetPiece:)];
        CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer view]];
        
        [self becomeFirstResponder];
        [menuController setMenuItems:[NSArray arrayWithObject:resetMenuItem]];
        [menuController setTargetRect:CGRectMake(location.x, location.y, 0, 0) inView:[gestureRecognizer view]];
        [menuController setMenuVisible:YES animated:YES];
        
        self.pieceForReset = [gestureRecognizer view];
    }
}

// animate back to the default anchor point and transform
- (void)resetPiece:(UIMenuController *)controller
{
    CGPoint locationInSuperview = [self.pieceForReset convertPoint:CGPointMake(CGRectGetMidX(self.pieceForReset.bounds), CGRectGetMidY(pieceForReset.bounds)) toView:[self.pieceForReset superview]];
    
    [[self.pieceForReset layer] setAnchorPoint:CGPointMake(0.5, 0.5)];
    [self.pieceForReset setCenter:locationInSuperview];
    
    [UIView beginAnimations:nil context:nil];
    [self.pieceForReset setTransform:CGAffineTransformIdentity];
    [UIView commitAnimations];
}

// UIMenuController requires that we can become first responder or it won't display
- (BOOL)canBecomeFirstResponder
{
    return YES;
}


#pragma mark -
#pragma mark === Touch handling  ===
#pragma mark

//- (void)pressImage:(id)sender {
//    UIImageViewT *v = (UIImageViewT*)sender;
//    int res = v.tag;
//    NSLog(@"press image. tag=%d",res);
//}


-(void)hideCloseButtons
{
    cr1.hidden = YES;
    cr2.hidden = YES;
    cr3.hidden = YES;    
}

-(void)unselectViews
{
    [self hideCloseButtons];
    for (UIView *v in [self.view subviews]) {
        if (v.tag > 0) {
            v.backgroundColor = [UIColor clearColor];
            v.tag = 1;
        }
    }
        
}

-(void)selectView:(UIView*)view
{
    if (view.tag >= 2)
        return;
    [self unselectViews];
    
    view.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.2];
    view.tag = 2;
    UIView *w = [view viewWithTag:10];
    w.hidden = NO;
}

- (void)tapPiece:(UIPanGestureRecognizer *)gestureRecognizer
{
    NSLog(@"tap_piece :%d",[gestureRecognizer view].tag);
    [self unselectViews];
                                 
    [self selectView:[gestureRecognizer view]];
}


- (void)tapView:(UIPanGestureRecognizer *)gestureRecognizer
{
    NSLog(@"tap_view :%d",[gestureRecognizer view].tag);
//    [self unselectViews];
//    [self selectView:[gestureRecognizer view]];
    UIView *v = [[gestureRecognizer view] superview];
    v.hidden = YES;
}


// shift the piece's center by the pan amount
// reset the gesture recognizer's translation to {0, 0} after applying so the next callback is a delta from the current position
- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer
{
    [self selectView:[gestureRecognizer view]];

    UIView *piece = [gestureRecognizer view];
    CGRect fr = piece.frame;
//    CGPoint p = piece.frame.origin;
//    CGPoint c = piece.center;
//    CGPoint p1 = imageView1.center;
    
    CGPoint cent = piece.frame.origin;
    cent.x += (fr.size.width / 2.);
    cent.y += (fr.size.height / 2.);
    
//    NSLog(@"--rec_pan:(%f %f) (%f %f) (%f %f)",p.x, p.y, c.x, c.y, p1.x, p1.y);

    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        
        if (cent.x >= maxX-1 && translation.x > 0) translation.x = 0;
        if (cent.x <= 1  && translation.x < 0) translation.x = 0;
        if (cent.y >= maxY-1 && translation.y > 0) translation.y = 0;
        if (cent.y <= 1  && translation.y < 0) translation.y = 0;
                
        CGPoint point = CGPointMake([piece center].x + translation.x, [piece center].y + translation.y);
        
//        NSLog(@"-----to point:(%f %f)  trans:(%f %f)",point.x, point.y, translation.x, translation.y);
        [piece setCenter:point];
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
        
    }
//    CGRect f = fr;
//    f.origin.x = cent.x - 1;
//    f.origin.y = cent.y - 1;// - (fr.size.height / 2.) - 10;
//    f.size.width = 3;
//    f.size.height = 3;
//    markView1.frame = f;
}

// rotate the piece by the current rotation
// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current rotation
- (void)rotatePiece:(UIRotationGestureRecognizer *)gestureRecognizer
{
    [self selectView:[gestureRecognizer view]];
    
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform = CGAffineTransformRotate([[gestureRecognizer view] transform], [gestureRecognizer rotation]);
        [gestureRecognizer setRotation:0];
        
//      imageViewCross.transform =  CGAffineTransformInvert([gestureRecognizer view].transform); //zs;        
        UIView *w = [[gestureRecognizer view] viewWithTag:10];
        w.transform = CGAffineTransformInvert([gestureRecognizer view].transform); //zs;
        w.hidden = NO;
        
    }
//    CGPoint pp = gestureRecognizer.view.frame.origin;
//    imageViewCross.center = pp;    
}

// scale the piece by the current scale
// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current scale
- (void)scalePiece:(UIPinchGestureRecognizer *)gestureRecognizer
{
    [self selectView:[gestureRecognizer view]];
    
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [gestureRecognizer view].transform = CGAffineTransformScale([[gestureRecognizer view] transform], [gestureRecognizer scale], [gestureRecognizer scale]);
        [gestureRecognizer setScale:1];
        
//      imageViewCross.transform =  CGAffineTransformInvert([gestureRecognizer view].transform); //zs;
        UIView *w = [[gestureRecognizer view] viewWithTag:10];
        w.transform = CGAffineTransformInvert([gestureRecognizer view].transform); //zs;        
    }
    
//    CGPoint pp = gestureRecognizer.view.frame.origin;
//    imageViewCross.center = pp;
}

// ensure that the pinch, pan and rotate gesture recognizers on a particular view can all recognize simultaneously
// prevent other gesture recognizers from recognizing simultaneously
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
//     if the gesture recognizers's view isn't one of our pieces, don't allow simultaneous recognition
   if (gestureRecognizer.view != imageView1 && gestureRecognizer.view != imageView2 && gestureRecognizer.view != labelText)
       return NO;
    
    // if the gesture recognizers are on different views, don't allow simultaneous recognition
    if (gestureRecognizer.view != otherGestureRecognizer.view)
        return NO;
    
    // if either of the gesture recognizers is the long press, don't allow simultaneous recognition
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        return NO;
    
    return YES;
}

//===========================================================================================
//===========================================================================================
//===========================================================================================




@end
