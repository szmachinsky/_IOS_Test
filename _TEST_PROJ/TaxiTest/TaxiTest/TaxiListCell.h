//
//  TaxiListCell.h
//  TaxiTest
//
//  Created by Admin on 05.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaxiListCell : UITableViewCell
{
}

@property (weak, nonatomic) IBOutlet UILabel *cellLabelName;
@property (weak, nonatomic) IBOutlet UILabel *cellLabelShortNumber;

@property (weak, nonatomic) IBOutlet UIButton *cellButtonCall;
@property (weak, nonatomic) IBOutlet UIButton *cellButtonInfo;

@end
