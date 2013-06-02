//
//  LabelEditCell.m
//  VoterTest
//
//  Created by User on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LabelEditCell.h"

@implementation LabelEditCell
@synthesize cellLabel = cellLabel_, cellText = cellText;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // Create a subview - don't need to specify its position/size 
        cellLabel_ = [[UILabel alloc] initWithFrame:CGRectZero];
        [cellLabel_ setText:@"123"];  
        cellLabel_.font=[UIFont fontWithName:@"Helvetica" size:17.0];
        [[self contentView] addSubview:cellLabel_];
        [cellLabel_ release];      
        
        cellText_ = [[UITextField alloc] initWithFrame:CGRectZero]; 
        [cellText_ setText:@"123"];
        cellText_.font=[UIFont fontWithName:@"Helvetica" size:17.0];        
        [[self contentView] addSubview:cellText_]; 
        [cellText_ release];  
        
//        [valueLa_ setText

        
    }
    return self;
}

- (void)layoutSubviews
{	// We always call this, the table view cell needs to do its own work first 
    [super layoutSubviews];
    
    
    float inset = 2.0; 
    CGRect bounds = [[self contentView] bounds]; 
    float h = bounds.size.height; 
    float w = bounds.size.width; 
//    float labelWidth = cellLabel_.frame.size.width;
    float editWidth =  cellText_.frame.size.width;

    CGRect innerFrame = CGRectMake(inset, inset, inset, h - inset * 2.0); 
//    [imageView setFrame:innerFrame];    

    innerFrame.origin.x += innerFrame.size.width + inset; 
    innerFrame.size.width = w - (editWidth + inset * 5);    
    [cellLabel_ setFrame:innerFrame];   
    

    innerFrame.origin.x += innerFrame.size.width + inset; 
    innerFrame.size.width = editWidth;
	[cellText_ setFrame:innerFrame];  

//    [cellLabel_ setFrame:bounds];    
//    [cellText_ setFrame:bounds];    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


- (void)setFields:(NSString *)labelStr editString:(NSString *)editStr Delegate:(id)delegate  Pos:(int)position 
{
    cellLabel_.text = labelStr;
    cellText_.text = editStr;
    [cellText_ setDelegate:delegate];   

/*    
    CGRect frameCell=self.contentView.frame;
    CGRect frame;
    
    frame=frameCell;
    frame.origin.x+=5;
    frame.size.width=cellLabel_.frame.size.width;
    cellLabel_.frame=frame;
    
    frame=frameCell;
    frame.origin.x+=cellLabel_.frame.size.width + 5;
    frame.size.width=cellText_.frame.size.width;
    cellText_.frame=frame;    
*/  
    
    float h=self.contentView.frame.size.width - 25;
    
    CGRect frame = cellLabel_.frame;    
    frame.size.width = position - 12;
    cellLabel_.frame = frame;
    
    frame = cellText_.frame;
    frame.origin.x = position;
    frame.size.width = h - position - 12;
    cellText_.frame = frame;
    
}

@end
