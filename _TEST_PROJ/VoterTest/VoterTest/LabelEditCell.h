//
//  LabelEditCell.h
//  VoterTest
//
//  Created by User on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelEditCell : UITableViewCell 
{
    UILabel     *cellLabel_; 
    UITextField *cellText_;
}
@property (nonatomic,assign) UILabel *cellLabel; 
@property (nonatomic,assign) UITextField *cellText; 

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setFields:(NSString *)labelStr editString:(NSString *)editStr Delegate:(id)delegate  Pos:(int)position;

@end
