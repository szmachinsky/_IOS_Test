//
//  LabelSwitchCell.m
//  TaxiTest
//
//  Created by Admin on 10.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LabelSwitchCell.h"

@implementation LabelSwitchCell
@synthesize labelTitle;
@synthesize labelPosition;
@synthesize switchAutoDetect;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
