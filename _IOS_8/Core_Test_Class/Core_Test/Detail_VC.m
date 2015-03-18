//
//  Detail_VC.m
//  Core_Test
//
//  Created by Zmachinsky Sergei on 05.03.15.
//  Copyright (c) 2015 Zmachinsky Sergei. All rights reserved.
//

#import "Detail_VC.h"

@interface Detail_VC ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UITextField *text1;
@property (weak, nonatomic) IBOutlet UITextField *text2;
@property (weak, nonatomic) IBOutlet UIButton *button1;

@end

@implementation Detail_VC


- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.label1.text = [[self.detailItem valueForKey:t_Stamp] description];
        self.text1.text = @"???";
        self.text2.text = @"???";
        
#if _CORE_CASE == 1
        self.text1.text = [[self.detailItem valueForKey:@"detail_1"] description];
#if _CORE_VERSION >= 1
        self.text2.text = [[self.detailItem valueForKey:@"detail_2"] description];
#endif
#endif
        
#if _CORE_CASE == 2
        self.text1.text = [[self.detailItem valueForKey:@"fName"] description];
        self.text2.text = [[self.detailItem valueForKey:@"sName"] description];
#endif
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
#if _CORE_CASE == 1
    [self.detailItem setValue:self.text1.text forKey:@"detail_1"]; //zs
#if _CORE_VERSION >= 1
    [self.detailItem setValue:self.text2.text forKey:@"detail_2"]; //zs
#endif
#endif

#if _CORE_CASE == 2
    [self.detailItem setValue:self.text1.text forKey:@"fName"]; //zs
    [self.detailItem setValue:self.text2.text forKey:@"sName"]; //zs
#endif

    
//    if ([self.delegate respondsToSelector:@selector(saveContext)]) {
//        [self.delegate performSelector:@selector(saveContext)];
//    }
    
    [self saveContext];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [self.detailItem managedObjectContext];
    
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (IBAction)pressButton1:(id)sender {
}

@end
