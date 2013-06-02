//
//  MapViewController.h
//  Test_2
//
//  Created by Admin on 18.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@end



@interface UIImageView(MyGestures) 
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
@end


@interface MyView : UIView 
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
@end


