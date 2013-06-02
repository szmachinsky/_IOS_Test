//
//  ActionViewController.m
//  Test_3
//
//  Created by Sergei on 27.05.13.
//  Copyright (c) 2013 Sergei. All rights reserved.
//

#import "ActionViewController.h"


@interface ActionViewController ()

@end

@implementation ActionViewController
{    
    IBOutlet UIButton *connectButton;
    UIActionSheet *actSheet;
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
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//  [actSheet showFromToolbar:self.navigationController.toolbar];
    
//  CGRect rect = connectButton.frame;
//  [actSheet showFromRect:rect inView:self.view animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *clickedButtonString = [NSString stringWithFormat:@"Кнопка по индексу %d была нажата",buttonIndex];
    NSLog(@"%@", clickedButtonString);
    if (buttonIndex == 0) {
        [self callFacebook];
    }
    if (buttonIndex == 1) {
        [self callTwitter2];
    }
    
}


- (void)callFacebook
{
    NSLog(@">>>>Call Facebook_Beg<<<<");
//    [self loginToFacebook];
    [self publishFBStream];
    NSLog(@">>>>Call Facebook_End<<<<");
    
}

- (void)callTwitter
{
    NSLog(@">>>>Call Twitter_Begin<<<<");
    [[TwitMe sharedInstance] setImages:[NSArray arrayWithObjects:[UIImage imageNamed:@"twitter.png"], nil]];
    [[TwitMe sharedInstance] setTextTwit:@""];
    [[TwitMe sharedInstance] setUrl:@"http://www.apple.com"];
    [[TwitMe sharedInstance] setDelegate:self];
    [[TwitMe sharedInstance] showModal];
    NSLog(@">>>>Call Twitter_End<<<<");
}


- (void)twitterResult:(TWTweetComposeViewController *)handler
{
    NSLog(@">>>>Delegate Twitter<<<<");
}



 -(void)callTwitter2
{
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    [twitter setInitialText:@""];//optional
//    [twitter addImage:[UIImage imageNamed:@"02.png"]];
//    [twitter addURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.apple.com"]]];
    
    if([TWTweetComposeViewController canSendTweet]){
        [self presentViewController:twitter animated:YES completion:nil];
    } else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Unable to tweet"
                                                            message:@"You might be in Airplane Mode or not have service. Try again later."
                                                           delegate:self cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult res) {
        if (TWTweetComposeViewControllerResultDone) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Tweeted"
                                                                message:@"You successfully tweeted"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        } else if (TWTweetComposeViewControllerResultCancelled) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Ooops..."
                                                                message:@"Something went wrong, try again later"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        [self dismissModalViewControllerAnimated:YES];
    };
}


//---------------------------------------------------------
- (void)publishFBStream {
    [self initFacebook];
    
    if ([_facebook isSessionValid]) {
//      SBJSON *jsonWriter =  [SBJSON new];//[[SBJSON new] autorelease];
        
        NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
                                                               @"Always Running",
                                                               @"text",
                                                               @"http://itsti.me/",
                                                               @"href", nil], nil];
        
//      NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
        NSData *data1 = [NSJSONSerialization dataWithJSONObject:actionLinks options:NSJSONWritingPrettyPrinted error:nil];
        NSString *actionLinksStr = [[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
        
        NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"a long run", @"name",
                                    @"The Facebook Running app", @"caption",
                                    @"it is fun", @"description",
                                    @"http://itsti.me/", @"href", nil];
//      NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
        NSData *data2 = [NSJSONSerialization dataWithJSONObject:attachment options:NSJSONWritingPrettyPrinted error:nil];
        NSString *attachmentStr = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];
        
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Share on Facebook",  @"user_message_prompt",
                                       actionLinksStr, @"action_links",
                                       attachmentStr, @"attachment",
                                       @"Это отличный сайт! \n http://softmix.by", @"message", nil];
        [_facebook dialog:@"feed"
               andParams:params
             andDelegate:self];
        
        
    } else {
        [self loginToFacebook];  
    }
}


- (void)loginToFacebook {
    [self initFacebook];
    
    if ([_facebook isSessionValid]) {
//        [_facebook logout:self];
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"FBpermissions" ofType:@"plist"];
        NSDictionary *settingsDic = [NSDictionary dictionaryWithContentsOfFile:path];
        NSArray *permissions = [settingsDic objectForKey:@"facebookPermissions"];
        [_facebook authorize:permissions delegate:self];
    }
}

- (void)initFacebook {
    if (!_facebook) {
        self.facebook = [[Facebook alloc] initWithAppId:@"527673330624606"]; //331663473546996
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        _facebook.accessToken = [userDefaults objectForKey:@"AccessToken"];
        _facebook.expirationDate = [userDefaults objectForKey:@"ExpirationDate"];
        
//        [facebook release];
    }
}

- (void)fbDidLogin {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:self.facebook.accessToken forKey:@"AccessToken"];
	[userDefaults setObject:self.facebook.expirationDate forKey:@"ExpirationDate"];
	[userDefaults synchronize];
	
	[_facebook requestWithGraphPath:@"me" andDelegate:self];
//    [self performSelector:@selector(publishFBStream) withObject:nil afterDelay:0.5];
    [self publishFBStream];
}

- (void)fbDidLogout {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults removeObjectForKey:@"AccessToken"];
	[userDefaults removeObjectForKey:@"ExpirationDate"];
	[userDefaults removeObjectForKey:@"userName"];
	[userDefaults synchronize];
    
//    [fbButton setTitle:@"Login" forState:UIControlStateNormal];
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSDictionary class]]) {
        if ([result objectForKey:@"name"]) {
            NSString *userName = [result objectForKey:@"name"];
            NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:userName forKey:@"userName"];
            [defaults synchronize];
            
//            [fbButton setTitle:userName forState:UIControlStateNormal];
        } else if ([result objectForKey:@"data"]) {
            NSArray *curentResult = [result objectForKey:@"data"];
            
            for (NSDictionary *element in curentResult) {
                NSLog(@"id:%@", [element objectForKey:@"id"]);
                NSLog(@"name:%@", [element objectForKey:@"name"]);
//                NSLog(@"photoURL:%@", [element objectForKey:@"picture"]);
//                NSLog(@"gender:%@", [element objectForKey:@"gender"]);
            }
        }
    } else {
        NSString *XMLresult = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSLog(@"%@", XMLresult);
//        [XMLresult release];
    }
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"FACEBOOK_ERROR : %@", error);
}


- (void)dialogDidComplete:(FBDialog *)dialog;
{
//    NSLog(@"FACEBOOK_dialogDidComplete : %@", dialog);
}

- (void)dialogCompleteWithUrl:(NSURL *)url
{
//    NSLog(@"FACEBOOK_dialogCompleteWithUrl : %@", url);
    NSString *str = [url absoluteString];
//    NSLog(@"FACEBOOK_dialogCompleteWithUrl : %@", str);
    NSRange range = [str rangeOfString:@"fbconnect://success?post_id="];
    if (range.location == 0 && range.length == 28) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Запись в Facebook добавлена" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];                
    }
        
}

@end
