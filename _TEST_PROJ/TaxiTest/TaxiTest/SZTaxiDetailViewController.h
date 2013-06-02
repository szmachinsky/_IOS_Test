//
//  SZTaxiDetailViewController.h
//  TaxiTest
//
//  Created by Admin on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SZMTaxi;

@interface SZTaxiDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) SZMTaxi *taxi;

@end
