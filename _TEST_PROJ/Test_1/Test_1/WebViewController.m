//
//  WebViewController.m
//  Test_1
//
//  Created by svp on 03.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"
#import "FileDownloader.h"



@implementation WebViewController
{
    IBOutlet UIImageView *imView_;
    NSMutableArray *connections_;

    ImageDownloader *imd_;
    
    
    IBOutlet UILabel *humanReadble;
    IBOutlet UILabel *jsonSummary;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        connections_ = [[NSMutableArray alloc] init];
        
 
    }
    return self;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [imView_ release];
    
    [connections_ release];
    [imd_ release];
     
    [humanReadble release];
    [jsonSummary release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    imd_ = [[ImageDownloader alloc] initWithString:@"http://pit.dirty.ru/dirty/1/2012/05/03/34819-193101-da23520db3069a60cc6290874329b5fb.jpg"];     
    imd_.imSize = 120;
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(imFinished:) name:kImageDownloadNote object:imd_]; 

}

- (void)viewDidUnload
{
    [imView_ release];
    imView_ = nil;
    
    [humanReadble release];
    humanReadble = nil;
    [jsonSummary release];
    jsonSummary = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//===================================================
- (void) finished: (NSNotification*) n 
{ 
    NSLog(@">Note>DATA loaded");
    FileDownloader* d = [n object]; 
    NSData* data = nil; 
    if ([n userInfo]) { 
        // ... error of some kind! ... 
        NSDictionary *info = [n userInfo];
        NSLog(@"ERROR!!! %@",[info objectForKey:@"error"]);        
    } else { 
        data = [d receivedData];         
        UIImage* im = [UIImage imageWithData:data]; 
        imView_.image = im;        
     } 
    [connections_ removeObject:d]; 
} 

//------ load with MyLoader class------
- (IBAction)pressLoad1:(id)sender {
    imView_.image = nil;
//    NSString* s = @"http://pit.dirty.ru/dirty/1/2012/05/03/35788-131206-4cf2676d2984c2a524e285c46d842999.jpg"; 
//    NSURL* url = [NSURL URLWithString:s]; 
//    NSURLRequest* req = [NSURLRequest requestWithURL:url];     
//  FileDownloader* d = [[FileDownloader alloc] initWithRequest:req];
    
    FileDownloader* d = [[FileDownloader alloc] initWithString:@"http://pit.dirty.ru/dirty/1/2012/05/03/35788-131206-4cf2676d2984c2a524e285c46d842999.jpg"]; 
    
    [connections_ addObject:d]; 
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(finished:) name:kFileDownloadNote object:d]; 
    [d.connection start]; 
    [d release];     
    
}

- (void)imFinished:(NSNotification*) n 
{
    NSLog(@">Note>IMAGE loaded");
}

//---- lazy loading----------------------------
- (IBAction)pressLoad2:(id)sender {
    
    imView_.image = imd_.image; //lazy load

}


//----load with GCD----------------------------
- (void)fetchedDataIm:(NSData *)data {
    UIImage* im = [UIImage imageWithData:data]; 
    imView_.image = im;          
}

- (IBAction)pressLoad3:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data =  [NSData dataWithContentsOfURL:
                        [NSURL URLWithString:@"http://i38.fastpic.ru/big/2012/0505/7f/bcb495bc5f11b75104b3528ba9af047f.jpg"]];
//      [self performSelectorOnMainThread:@selector(fetchedDataIm:) withObject:data waitUntilDone:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fetchedDataIm:data];
        });                                
    });    
}

//=====================JSON==============================
#define kBgQueue            dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

#define kLatestKivaLoansURL [NSURL URLWithString:@"http://api.kivaws.org/v1/loans/search.json?status=fundraising"] //2

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData 
                          options:kNilOptions 
                            error:&error];
    
    NSArray* latestLoans = [json objectForKey:@"loans"];
    
//    NSLog(@"loans: %@", latestLoans); //3
    
    // 1) Get the latest loan
    NSDictionary* loan = [latestLoans objectAtIndex:0];
    
    // 2) Get the funded amount and loan amount
    NSNumber* fundedAmount = [loan objectForKey:@"funded_amount"];
    NSNumber* loanAmount = [loan objectForKey:@"loan_amount"];
    float outstandingAmount = [loanAmount floatValue] - 
    [fundedAmount floatValue];
    
    // 3) Set the label appropriately
    humanReadble.text = [NSString stringWithFormat:@"Latest loan: %@from %@ needs another $%.2f to pursue their entrepreneural dream",
                         [loan objectForKey:@"name"],
                         [(NSDictionary*)[loan objectForKey:@"location"] 
                          objectForKey:@"country"],
                         outstandingAmount];  
    
//-------
    //build an info object and convert to json
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                          [loan objectForKey:@"name"], @"who",
                          [(NSDictionary*)[loan objectForKey:@"location"] objectForKey:@"country"], @"where",
                          [NSNumber numberWithFloat: outstandingAmount], @"what",
                          nil];
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info 
                        options:NSJSONWritingPrettyPrinted error:&error];
    //print out the data contents
    jsonSummary.text = [[NSString alloc] initWithData:jsonData                                        
                                             encoding:NSUTF8StringEncoding];
    
}

- (IBAction)pressJSON:(id)sender {
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL:kLatestKivaLoansURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) 
                               withObject:data waitUntilDone:YES];
    });
}



@end
