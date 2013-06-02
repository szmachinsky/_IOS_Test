//
//  GGLViewController.m
//  VoterTest
//
//  Created by User User on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GGLViewController.h"

//  NSString* _user_id = @"sergei.zma@gmail.com";
NSString* _user_id = @"443853727988.apps.googleusercontent.com";
//NSString* _user_id = @"443853727988";
//NSString* _user_id = @"me443853727988+";
NSString* _access_key= @"AIzaSyA8C-vxrHe06GtfEucojMvPzhiTNo93XrI";



@implementation GGLViewController

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
    [backButton_ release];
    backButton_ = nil;
    [connectButton_ release];
    connectButton_ = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [backButton_ release];
    [connectButton_ release];
    [super dealloc];
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
}


//===============================================================================
- (IBAction)pressConnect:(id)sender 
{
    responseData = [[NSMutableData data] retain];
    //  NSURL *url = [NSURL URLWithString:@"https://www.googleapis.com/plus/v1/people/443853727988.apps.googleusercontent.com?key=aNFFq6S1RKuqZTVWi-Z0aQ-l"];
    
//    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.googleapis.com/plus/v1/people/{userId}?key={your-api-key}"]];
    NSString* surl = [NSString stringWithFormat:@"https://www.googleapis.com/plus/v1/people/%@?key=%@",_user_id, _access_key];
    
//    NSString* surl = [NSString stringWithFormat:@"https://www.googleapis.com/plus/v1/people/%@/activities/public?alt=json&pp=1&key=%@", user_id, access_key];
    NSLog(@"URL:%@",surl);    
    NSURL *url = [NSURL URLWithString:surl];        
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@",[NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[connection release];
    
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"==>(%@)",responseString);  
/*    
    SBJsonParser* jsonParser = [[SBJsonParser alloc]init];        
    NSDictionary *feeds = (NSDictionary* )[jsonParser objectWithString:responseString];    
    NSLog(@"---:%@",feeds);
*/    
    [responseString release];    
	[responseData release];        
}



//===============================================================================
- (IBAction)pressBack:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];        
}


@end
