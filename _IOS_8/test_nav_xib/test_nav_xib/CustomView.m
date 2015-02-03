//
//  CustomView.m
//  test_nav_xib
//
//  Created by Sergei on 23.11.14.
//  Copyright (c) 2014 Sergei. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (NSArray *)nibViews {
    UINib *uiNib = [UINib nibWithNibName:@"CustomView" bundle:nil];
    NSArray *result = [uiNib instantiateWithOwner:nil options:nil];
    
    return result;
}

+ (CustomView *)loadView {
    NSArray * nibViews = [self nibViews];
    
    for (id v in nibViews) {
        if ([v isKindOfClass:[self class]]) {
//            [v setBackgroundColor:[UIColor clearColor]];
            return v;
        }
    }
    NSAssert(NO, @"Can't load CustomView from nib");
    return nil;
}


- (IBAction)pressCustomButton:(id)sender {
    self.custLabel.text = @"press";
}



@end
