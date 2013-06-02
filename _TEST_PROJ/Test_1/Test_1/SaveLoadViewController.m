//
//  SaveLoadViewController.m
//  Test_1
//
//  Created by svp on 13.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SaveLoadViewController.h"

@implementation SaveLoadViewController
{
    NSMutableArray *arr_;
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        arr_ = [[NSMutableArray alloc] initWithObjects:@"Inf1", @"Inf2", @"Inf3", nil];
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
    [imView_ release];
    imView_ = nil;

    [labelArr_ release];
    labelArr_ = nil;
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
    [imView_ release];
    
    [arr_ release];
    
    [labelArr_ release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    labelArr_.text = [arr_ description];
}

//=================================================================================

- (IBAction)press1:(id)sender {
    NSString *path = pathWithDocDir(@"MyTmpFile.tmp");
    NSLog(@"==1(%@)",path);
    path = pathInDocDir(@"MyTmpFile.tmp");
    NSLog(@"==2(%@)",path);
    path = pathInCachesDir(@"MyTmpFile.tmp");
    NSLog(@"==3(%@)",path);
    path = pathInTmpDir(@"MyTmpFile.tmp");   
    NSLog(@"==4(%@)",path);
    path = pathInTmp2Dir(@"MyTmpFile.tmp");   
    NSLog(@"==5(%@)",path);
    
    
    // Get a pointer to the application bundle
    NSBundle *applicationBundle = [NSBundle mainBundle];
    // Ask for the path to a resource named myImage.png in the bundle
    NSString *path1 = [applicationBundle pathForResource:@"01" ofType:@"png"]; 
    NSLog(@"==in bundle(%@)",path1);
    
}

- (IBAction)pressSave:(id)sender {
    NSLog(@"-pressSave");   
    NSString *str = label_.text;
    UIImage *img = imView_.image;
    NSMutableArray *arr = arr_;
    
    NSError *err;
    
    BOOL success = [str writeToFile:pathInDocDir(@"TmpString.tmp") 
                         atomically:YES encoding:NSUTF8StringEncoding error:&err];
    if	(!success)	
        NSLog(@"Error writing string : %@",[err localizedDescription]);    

    success = [arr writeToFile:pathInDocDir(@"TmpArray.tmp")  atomically:YES];
    if	(!success)	
        NSLog(@"Error writing array : %@",[err localizedDescription]); 
    
 
//  NSData *d = UIImageJPEGRepresentation(img, 0.5);
    NSData *d = UIImagePNGRepresentation(img);
    int len = [d length];
    success = [d writeToFile:pathInDocDir(@"TmpImg") atomically:YES];    
    if	(!success)	
        NSLog(@"Error writing image %d bytes",len);    
    
}

- (IBAction)pressClear:(id)sender {
    NSLog(@"-pressClear");   
//    [arr_ removeAllObjects];
    [arr_ release]; arr_=nil;
    
    label_.text = nil;
    labelArr_.text = [arr_ description]; 
    imView_.image = nil;   
}

- (IBAction)pressLoad:(id)sender {
    NSLog(@"-pressLoad");   
    NSError *err;
    BOOL success = YES;
    
    NSString *str = [NSString stringWithContentsOfFile:pathInDocDir(@"TmpString.tmp")  //read string
                                              encoding:NSUTF8StringEncoding error:&err];
    if	(!str)	
        NSLog(@"Error	reading	string:	%@",[err localizedDescription]);    
    label_.text = str;
 
    NSArray *ar = [NSArray arrayWithContentsOfFile:pathInDocDir(@"TmpArray.tmp")]; //read array
    if	(!ar)	
        NSLog(@"Error	reading	array");    
    arr_ = [[NSMutableArray alloc] initWithArray:ar];
    labelArr_.text = [arr_ description]; 

    
    UIImage *im = [UIImage imageWithContentsOfFile:pathInDocDir(@"TmpImg")];   //read image
    if	(!im)	
        NSLog(@"Error	reading	image");    
    imView_.image = im;
    success = [[NSFileManager defaultManager] removeItemAtPath:pathInDocDir(@"TmpImg") error:&err]; //delete image from TMP
    if (!success)
        NSLog(@"Error	delete	image:	%@",[err localizedDescription]);           
    
    [self.view setNeedsDisplay];
}


@end
