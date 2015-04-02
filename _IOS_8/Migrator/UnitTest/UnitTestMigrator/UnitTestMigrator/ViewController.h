//
//  ViewController.h
//  UnitTestMigrator
//
//  Created by Zmachinsky Sergei on 02.04.15.
//  Copyright (c) 2015 Zmachinsky Sergei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

-(void)infoText:(NSString*)info;

@end

