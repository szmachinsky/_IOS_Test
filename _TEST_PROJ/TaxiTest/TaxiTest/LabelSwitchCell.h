//
//  LabelSwitchCell.h
//  TaxiTest
//
//  Created by Admin on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelSwitchCell : UITableViewCell
{
    
}

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelPosition;
@property (weak, nonatomic) IBOutlet UISwitch *switchAutoDetect;

@end
