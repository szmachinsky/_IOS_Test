//
//  TaxiListCell.m
//  TaxiTest
//
//  Created by Admin on 05.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TaxiListCell.h"

@implementation TaxiListCell
@synthesize cellLabelName = cellLabelName_;
@synthesize cellLabelShortNumber = cellLabelShortNumber_;
@synthesize cellButtonCall;
@synthesize cellButtonInfo;

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
