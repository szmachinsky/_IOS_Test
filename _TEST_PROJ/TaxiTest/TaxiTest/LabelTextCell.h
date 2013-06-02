//
//  LabelTextCell.h
//  TaxiTest
//
//  Created by Admin on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelTextCell : UITableViewCell
{
    
}

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UITextField *textNumber;
@property (weak, nonatomic) IBOutlet UIButton *buttonNumberDone;


@end
