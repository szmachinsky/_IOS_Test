//
//  PropertyViewController.m
//  Test_1
//
//  Created by svp on 14.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PropertyViewController.h"

@interface PropertyViewController ()
@property (nonatomic, copy) NSString *strAlias;
@property (nonatomic, retain) NSMutableDictionary *dictAlias;

//@property (nonatomic, copy) NSString *tst;
@end

@implementation PropertyViewController
#pragma mark Variables
{
    IBOutlet UILabel *label_;
    IBOutlet UIButton *butt1_;
    
    NSString *str_;
    NSMutableDictionary *dict_;
    NSString *dictPath_;
}

@synthesize strAlias = str_;
@synthesize dictAlias = dict_;
//@synthesize tst;


//===========================================================================
#pragma mark Accessors
-(NSString*)str 
{
    NSLog(@"** get string (%@)",self.strAlias);
    return self.strAlias;
}

-(void)setStr:(NSString *)string
{
    NSLog(@"** set string to (%@)",string);
    self.strAlias = string;
}

-(NSMutableDictionary*)dict 
{
    NSLog(@"** get dict1 (%@)",self.dictAlias);
    
    if (!dict_) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:dictPath_]) {
            NSMutableDictionary *data = [NSMutableDictionary dictionaryWithContentsOfFile:dictPath_];
            self.dictAlias = data;
            NSLog(@"** get dict from file! (%@)",self.dictAlias);
            NSError* err = nil;
            BOOL ok = [[NSFileManager defaultManager] removeItemAtPath:dictPath_ error:&err];
            if (!ok)
                NSLog(@"Couldn't remove temp file (%@)",[err localizedDescription]);
        }
    }
    return self.dictAlias;
}

-(void)setDict:(NSMutableDictionary *)dict
{
    NSLog(@"** set dict to (%@)",dict);
    self.dictAlias = dict;
}

//============================================================================

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@" Init");        
        self.str = @"initial string";
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"!!!didReceiveMemoryWarning");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning]; //call viewDidUnload!!! 
    
    // Release any cached data, images, etc that aren't in use.
    
    if (dict_) 
    { 
        [self.dict writeToFile:dictPath_ atomically:NO]; //save to disk
        self.dict = nil; //delete object
    }     
}

#pragma mark - View lifecycle


- (void)viewDidUnload
{
    NSLog(@"!!!viewDidUnload");
    [label_ release];
    label_ = nil;
    [butt1_ release];
    butt1_ = nil;
    
//  self.str = nil;
    
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
    NSLog(@"!!!dealloc");
    [label_ release];
    [butt1_ release];
    
    self.str = nil;
    self.dict = nil;
    [dictPath_ release];
    
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@" Did Load (%@)",str_);
    // Do any additional setup after loading the view from its nib.
//    label_.text = str_;
    
    NSArray *ar1 = [NSArray arrayWithObjects:@"ar11", @"ar12", nil];
    NSArray *ar2 = [NSArray arrayWithObjects:@"ar21", @"ar22", nil]; 
    self.dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:ar1,@"Arr_key1", ar2,@"Arr_key2", nil];
    dictPath_ = [[NSString alloc] initWithString:pathInTmpDir(@"myBigData")];
    NSLog(@" path to save = (%@)",dictPath_);
    
    for (int i=0; i<5; i++) {
        NSString *str = [UserTool UUIDString];
        NSLog(@"rand str = (%@)",str);
    }
}

- (void)viewWillAppear:(BOOL)animated 
{
    NSLog(@" Will Appear (%@)",str_);
    label_.text = str_;
    [super viewWillAppear:animated];
}

//====================================================
- (IBAction)press1:(id)sender 
{
    NSLog(@" press1 (%@)",str_);
    label_.text = str_;
    if (!self.dict) {
        NSLog(@" dict is empty!!!");
    } else {
        NSLog(@" dict is %@",dict_);       
    }
}

- (IBAction)press2:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"Str_Object1" forKey:@"Setting1"];
    [defaults synchronize]; 

    defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults objectForKey:@"Setting1"];
    NSLog(@" str = (%@)",str); 
    
//    [defaults removeObjectForKey:@"Setting1"];
//    [defaults synchronize];     
    
}




@end
