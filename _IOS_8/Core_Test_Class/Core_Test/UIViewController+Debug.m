//
//  UIViewController+Debug.m
//  Downloader
//
//  Created by Vyachaslav Gerchicov on 27.02.15.
//
//

#ifdef DEBUG

#import "UIViewController+Debug.h"
#import <objc/runtime.h>

#define DEBUG_LABEL_TAG 1000001

static char key;

@implementation UIViewController (Debug)

+ (void)load
{
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(viewDidLoad)),
                                   class_getInstanceMethod(self, @selector(swizzled_viewDidLoad)));
    
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(viewWillLayoutSubviews)),
                                   class_getInstanceMethod(self, @selector(swizzled_viewWillLayoutSubviews)));
}

- (void)swizzled_viewDidLoad {
    [self swizzled_viewDidLoad];
    
    UILabel* nameLabel = [[self class] createDebugLabel];
    nameLabel.tag = DEBUG_LABEL_TAG;
    objc_setAssociatedObject(self, &key, nameLabel, OBJC_ASSOCIATION_RETAIN);
    [self.view addSubview:nameLabel];
    
    static const int dy = 10;
    int possibleY = (self.view.frame.size.height - dy);
    if (possibleY > 100) {
        
        possibleY = 100;
    }
    if (possibleY < 1) {
        
        possibleY = 1;
    }
    int newY = arc4random() % possibleY + 20;

    CGRect r = nameLabel.frame;
    r.origin.y = newY;
    nameLabel.frame = r;
    
//    UIView *tempView = self.view.superview;
//    int parentViewWithLabelCount = 0;
//    while (tempView) {
//        
//        if ([tempView viewWithTag:DEBUG_LABEL_TAG]) {
//            
//            parentViewWithLabelCount++;
//        }
//        tempView = tempView.superview;
//    }
//    
//    int childViewWithLabelCount = [self childLabelCountForView:self.view] - 1;
//    
//    CGRect r = nameLabel.frame;
//    r.origin.y += (10 * (parentViewWithLabelCount + childViewWithLabelCount));
//    nameLabel.frame = r;
}

- (void)swizzled_viewWillLayoutSubviews {
    [self swizzled_viewWillLayoutSubviews];
    
    UILabel* nameLabel = objc_getAssociatedObject(self, &key);
    
    if (nameLabel) {
        [nameLabel.superview bringSubviewToFront:nameLabel];
    }
}

+ (UILabel*)createDebugLabel {
    UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    nameLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
    nameLabel.textColor = [UIColor colorWithRed:1.0f green:0.1 blue:0.1f alpha:0.8f];
    nameLabel.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.8f].CGColor;
    nameLabel.layer.borderWidth = 1;
    nameLabel.layer.cornerRadius = 2;
    nameLabel.font = [UIFont systemFontOfSize:11.0f];
    nameLabel.text = [[self class] description];
    [nameLabel sizeToFit];
    
    CGRect r = nameLabel.frame;
    r.origin.x = r.origin.y = 2;
    r.size.width += 4;
    nameLabel.frame = r;
    
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
//    nameLabel.top = nameLabel.left = 2;
//    nameLabel.width += 4;
//    nameLabel.textAlignment = UITextAlignmentCenter;
    
    return nameLabel;
}

//- (int)childLabelCountForView:(UIView *)v {
//    
//    if (v.subviews.count == 0) {
//        
//        if ([v viewWithTag:DEBUG_LABEL_TAG]) {
//            
//            return 1;
//        }
//        return 0;
//    }
//    int sum = 0;
//    for (UIView *v1 in v.subviews) {
//        
//        sum += [self childLabelCountForView:v1];
//    }
//    if ([v viewWithTag:DEBUG_LABEL_TAG]) {
//        
//        sum++;
//    }
//    return sum;
//}

@end

#endif