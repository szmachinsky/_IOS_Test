//
//  ActionViewController.m
//  Test_3
//
//  Created by Sergei on 27.05.13.
//  Copyright (c) 2013 Sergei. All rights reserved.
//

#import "ActionViewController.h"
#import "Social/Social.h"

@interface ActionViewController ()

@end

@implementation ActionViewController
{    
    IBOutlet UIButton *connectButton;
    __weak IBOutlet UIView *testView;
    UIActionSheet *actSheet;
    
    UITextField *textField;
    UIImage *shareImage;

}


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
    
    [self addInterface];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//----------------------------------------------------------------------------------------------

- (void)addInterface
{
    shareImage = [UIImage imageNamed:[NSString stringWithFormat:@"02.png"]];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:shareImage];
    imageView.frame = CGRectMake(138, 40, 48, 48);
    [self.view addSubview:imageView];
    
    CGRect textFieldFrame = CGRectMake(20.0f, 100.0f, 280.0f, 31.0f);
    textField = [[UITextField alloc] initWithFrame:textFieldFrame];
    textField.placeholder = @"Ссылка";
    textField.backgroundColor = [UIColor whiteColor];
    textField.textColor = [UIColor blackColor];
    textField.font = [UIFont systemFontOfSize:14.0f];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.returnKeyType = UIReturnKeyDone;
    textField.textAlignment = UITextAlignmentCenter;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    [self.view addSubview:textField];
    
    UIButton *twitterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [twitterButton addTarget:self
                      action:@selector(twiShare:)
            forControlEvents:UIControlEventTouchDown];
    [twitterButton setTitle:@"Share on Twitter" forState:UIControlStateNormal];
    twitterButton.frame = CGRectMake(80.0, 170.0, 160.0, 40.0);
    [self.view addSubview:twitterButton];
    
    UIButton *facebookButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [facebookButton addTarget:self
                       action:@selector(fbShare:)
             forControlEvents:UIControlEventTouchDown];
    [facebookButton setTitle:@"Share on Facebook" forState:UIControlStateNormal];
    facebookButton.frame = CGRectMake(80.0, 240.0, 160.0, 40.0);
    [self.view addSubview:facebookButton];
    
}

-(void)twiShare:(id)sender{
    SLComposeViewController *composeController = [SLComposeViewController
                                                  composeViewControllerForServiceType:SLServiceTypeTwitter];    
    [composeController setInitialText:@"Тест твит из iOS 6"];
    [composeController addImage:shareImage];
    [composeController addURL: [NSURL URLWithString:
                                [NSString stringWithFormat:@"%@",textField.text]]];    
    [self presentViewController:composeController
                       animated:YES completion:nil];
}

-(void)fbShare:(id)sender{
    SLComposeViewController *composeController = [SLComposeViewController
                                                  composeViewControllerForServiceType:SLServiceTypeFacebook];
    [composeController setInitialText:@"Тест msg из iOS 6"];
    [composeController addImage:shareImage];
    [composeController addURL: [NSURL URLWithString:
                                [NSString stringWithFormat:@"%@",textField.text]]];
    [self presentViewController:composeController
                       animated:YES completion:nil];    
}

- (BOOL)textFieldShouldReturn:(UITextField *)_textField{
    [_textField resignFirstResponder];
    return YES;
}

//--------------------------------------------------------

- (IBAction)pressConnectButton:(id)sender {
    actSheet = [[UIActionSheet alloc] initWithTitle:nil//@"Заголовок"
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancell"//@"Кнопка отмены"
                                            destructiveButtonTitle:nil//@"Красная кнопка"
                                                 otherButtonTitles:@"Facebook",@"Twitter",nil];//@"Другая кнопка",nil];                                            
    actSheet.actionSheetStyle = UIBarStyleBlackTranslucent;//UIBarStyleBlackOpaque;//UIActionSheetStyleDefault;
    [actSheet showInView:self.view];    
//  CGRect rect = connectButton.frame;
//  [actSheet showFromRect:rect inView:self.view animated:YES];
    
    
//    UIMenuController *menuController = [UIMenuController sharedMenuController];
//    UIMenuItem *resetMenuItem = [[UIMenuItem alloc] initWithTitle:@"Facebook" action:@selector(callFacebook:)];
//    CGPoint location = CGPointMake(10, 10);//[gestureRecognizer locationInView:[gestureRecognizer view]];    
//    [self becomeFirstResponder];
//    [menuController setMenuItems:[NSArray arrayWithObject:resetMenuItem]];
////    [menuController setTargetRect:CGRectMake(location.x, location.y, 100, 100) inView:testView];
//    [menuController setTargetRect:testView.frame inView:self.view];
//    [menuController setMenuVisible:YES animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *clickedButtonString = [NSString stringWithFormat:@"Кнопка по индексу %d была нажата",buttonIndex];
    NSLog(@"%@", clickedButtonString);
    if (buttonIndex == 0) {
        [self callFacebook];
    }
    
}


//- (BOOL) canBecomeFirstResponder
//{
//    return YES;
//}

- (void)callFacebook
{
    NSLog(@">>>>Call Facebook<<<<");
    
}

- (void)callTwitter
{
    NSLog(@">>>>Call Twitter<<<<");
    
}

- (void)viewDidUnload {
    testView = nil;
    [super viewDidUnload];
}
@end
