//
//  MapViewController.m
//  Test_2
//
//  Created by Admin on 18.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "MapPoint.h"
#import "FileHelpers.h"



@implementation UIImageView(MyGestures) 
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint loc = [[touches anyObject] locationInView: self.superview];
    CGPoint oldP = [[touches anyObject] previousLocationInView: self.superview];
    CGFloat deltaX = loc.x - oldP.x;
    CGFloat deltaY = loc.y - oldP.y;
    CGPoint c = self.center;
    c.x += deltaX;
    c.y += deltaY;
    self.center = c;
}
@end


@implementation MyView : UIView 
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
CGPoint loc = [[touches anyObject] locationInView: self.superview];
CGPoint oldP = [[touches anyObject] previousLocationInView: self.superview];
CGFloat deltaX = loc.x - oldP.x;
CGFloat deltaY = loc.y - oldP.y;
CGPoint c = self.center;
c.x += deltaX;
c.y += deltaY;
self.center = c;
}    
@end




@interface MapViewController ()
-(void)handleLongPressGesture:(UIGestureRecognizer*)sender; 
- (IBAction)changeMapType:(id)sender;
- (void)foundLocation:(CLLocation *)loc;
- (void) draggingImage: (UIPanGestureRecognizer*) p; 

@end


#define  kMapTypePrefKey  @"Test_2_MapTypePrefKey"
//NSString * const WhereamiMapTypePrefKey = @"WhereamiMapTypePrefKey";


@implementation MapViewController
{
    __weak IBOutlet MKMapView *mapView_;
    
    __weak IBOutlet UIActivityIndicatorView *activityIndicator_;
    __weak IBOutlet UIButton *bottonMarkPos_;        
    __weak IBOutlet UISegmentedControl *mapTypeControl_;
    __weak IBOutlet UIButton *buttonTest_;

    __weak IBOutlet UIView *viewPin_;    
    __weak IBOutlet UIImageView *imViewPin_;
    
    
    CLLocationManager *locationManager_;
    
    CLPlacemark *myPlacemark_;
    CLGeocoder *geoCoder_;
    
    NSInteger scPos;
}


+ (void)initialize
{
    NSDictionary *defaults = [NSDictionary 
                              dictionaryWithObject:[NSNumber numberWithInt:2]
                              forKey:kMapTypePrefKey];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"--init--");
        
        BOOL ok = [CLLocationManager locationServicesEnabled]; 
        if (ok) {
            locationManager_ = [[CLLocationManager alloc] init];        
            locationManager_.delegate = self;        
            locationManager_.desiredAccuracy = kCLLocationAccuracyBest;
            locationManager_.distanceFilter = kCLDistanceFilterNone;
            
//      [locationManager_ startMonitoringSignificantLocationChanges]; //use cell towers
        } else {
            NSLog(@"local service is not enabled!!!");            
        }
        
        geoCoder_= [[CLGeocoder alloc] init];        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [mapView_ setShowsUserLocation:YES];
//    [mapView_ setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
//    [mapView_ setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
        
    NSInteger num = [[NSUserDefaults standardUserDefaults] 
                              integerForKey:kMapTypePrefKey];
    NSLog(@"read type %d",num);
    
    [mapTypeControl_ setSelectedSegmentIndex:num];
    [self changeMapType:mapTypeControl_];
    
//    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
//    [mapView_ addGestureRecognizer:longPressGesture];  

    
//    UIPanGestureRecognizer* p = [[UIPanGestureRecognizer alloc]
//                                  initWithTarget:self
//                                  action:@selector(draggingImage:)];
//    [imViewPin_ addGestureRecognizer:p];

}


- (void) draggingImage: (UIPanGestureRecognizer*) p 
{
    UIView* vv = p.view;
    if (p.state == UIGestureRecognizerStateBegan ||
        p.state == UIGestureRecognizerStateChanged) {
        CGPoint delta = [p translationInView: vv.superview];
        CGPoint c = vv.center;
        c.x += delta.x; c.y += delta.y;
        vv.center = c;
        [p setTranslation: CGPointZero inView: vv.superview];
    }
}


- (void)viewDidUnload
{
    mapView_ = nil;
    bottonMarkPos_ = nil;
    activityIndicator_ = nil;
    mapTypeControl_ = nil;
    buttonTest_ = nil;
    viewPin_ = nil;
    imViewPin_ = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    NSLog(@"--dealloc--");
    
    [mapView_ setShowsUserLocation:NO];  
    
    [locationManager_ setDelegate:nil];
    [locationManager_ stopUpdatingLocation];
    
    [activityIndicator_ stopAnimating];    
}

//----------------------------map-----------------------------------------------
#pragma mark - Map's methods
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)u
{
//    CLLocationCoordinate2D l = u.location.coordinate;
//    NSLog(@"map_location: %f %f",l.latitude,l.longitude);    
    CLLocationCoordinate2D loc = [u coordinate];
    NSLog(@"map_location: %f %f",loc.latitude,loc.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 1000, 1000);
    [mapView_ setRegion:region animated:YES];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView 
    didChangeDragState:(MKAnnotationViewDragState)newState 
    fromOldState:(MKAnnotationViewDragState)oldState 
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        NSLog(@"Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
    }
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views 
{ 
    for (MKAnnotationView* aView in views) 
    {
        if ([aView.reuseIdentifier isEqualToString:@"customPin2"]) 
        { 
            aView.alpha = 0;
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.8];
            aView.alpha = 1;
            [UIView commitAnimations]; 
        }
    }   
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation 
{
    MKAnnotationView* v = nil;
//    if ([annotation.title isEqualToString:@"Park here"]) {
    NSString *ttl = [annotation title];
    NSLog(@"get_view_for_annot:(%@)",ttl);
    if ([annotation isMemberOfClass:[MapPoint class]])
    {
        NSInteger tag = [(MapPoint*)annotation tag];
        if (tag == 100) {
            static NSString* ident = @"greenPin";
            v = [mapView dequeueReusableAnnotationViewWithIdentifier:ident]; 
            if (v == nil) {
                v = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                 reuseIdentifier:ident];
                ((MKPinAnnotationView*)v).pinColor = MKPinAnnotationColorGreen; 
                v.canShowCallout = YES;
//                v.animatesDrop = YES;
                v.draggable = YES;  
                ((MKPinAnnotationView*)v).animatesDrop = YES;
                
                UIImage *i = v.image;
                NSData *data = UIImagePNGRepresentation(i);
                NSString *path = pathWithDocDir(@"green_pin.png");  
                [data writeToFile:path atomically:YES];
            } 
            v.annotation = annotation; 
        }
        
        if (tag == 101) {
            static NSString* ident = @"redPin";
            v = [mapView dequeueReusableAnnotationViewWithIdentifier:ident]; 
            if (v == nil) {
                v = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                    reuseIdentifier:ident];
                ((MKPinAnnotationView*)v).pinColor = MKPinAnnotationColorRed; 
                v.canShowCallout = YES;
                v.draggable = YES; 
                
                UIImage *i = v.image;
                NSData *data = UIImagePNGRepresentation(i);
                NSString *path = pathWithDocDir(@"red_pin.png");  
                [data writeToFile:path atomically:YES];                
            } 
            v.annotation = annotation;         
        }
        if (tag == 102) {
            static NSString* ident = @"purplePin";
            v = [mapView dequeueReusableAnnotationViewWithIdentifier:ident]; 
            if (v == nil) {
                v = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                    reuseIdentifier:ident];
                ((MKPinAnnotationView*)v).pinColor = MKPinAnnotationColorPurple; 
                v.canShowCallout = YES;
                v.draggable = YES; 
                
                UIImage *i = v.image;
                NSData *data = UIImagePNGRepresentation(i);
                NSString *path = pathWithDocDir(@"purple_pin.png");  
                [data writeToFile:path atomically:YES];                
            } 
            v.annotation = annotation;         
        }
  
        if (tag == 103) {
            static NSString* ident = @"customPin1";
                        
            v = [mapView dequeueReusableAnnotationViewWithIdentifier:ident]; 
            if (v == nil) {
                v = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                    reuseIdentifier:ident];                
//                v.image = [UIImage imageNamed:@"07-map-marker.png"];                
                v.image = [UIImage imageNamed:@"59-flag.png"];                
//                CGRect f = v.bounds;
//                f.size.height /= 3.0;
//                f.size.width /= 3.0;
//                v.bounds = f;
//                v.centerOffset = CGPointMake(0,-20);                                                 
                v.centerOffset = CGPointMake(9,-12);                                                 
//                v.canShowCallout = YES;
                v.draggable = YES;                

            } 
            v.annotation = annotation; 
        }
        
        if (tag == 104) {
            static NSString* ident = @"customPin2";
            
            v = [mapView dequeueReusableAnnotationViewWithIdentifier:ident]; 
            if (v == nil) {
                v = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                 reuseIdentifier:ident];                
                //                v.image = [UIImage imageNamed:@"07-map-marker.png"];                
                v.image = [UIImage imageNamed:@"Map-Marker-Marker-Inside-Chartreuse-48.png"];                
                //                CGRect f = v.bounds;
                //                f.size.height /= 3.0;
                //                f.size.width /= 3.0;
                //                v.bounds = f;
                //                v.centerOffset = CGPointMake(0,-20);                                                 
                v.centerOffset = CGPointMake(1,-22);                                                 
//                v.canShowCallout = YES;
                v.draggable = YES;  
//                ((MKAnnotationView*)v).animatesDrop = YES;
                
            } 
            v.annotation = annotation; 
        }
        
        
    }
    return v; 
}

//----------------------------location------------------------------------------
#pragma mark - Location's methods

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    // How many seconds ago was this new location created?
    NSTimeInterval t = [[newLocation timestamp] timeIntervalSinceNow];
    NSLog(@">>new_loc:(%@)",newLocation);
    
    // CLLocationManagers will return the last found location of the 
    // device first, you don't want that data in this case.
    // If this location was made more than 3 minutes ago, ignore it.
    if (t < -180) {
        // This is cached data, you don't want it, keep looking
        NSLog(@">>ignore");
        return;
    }
    
    [self foundLocation:newLocation];
    
    
    [geoCoder_ reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        myPlacemark_=placemark; 
//        NSLog(@"place=(%@)",placemark);
        // Here you get the information you need 
//        NSString *s1 = placemark.country; //Belarus Белоруссия
//        NSString *s2 = placemark.thoroughfare; //nil
//        NSString *s22= placemark.subThoroughfare;        
//        NSString *s3 = placemark.locality;
//        NSString *s4 = placemark.subLocality;
//        NSString *s5 = placemark.administrativeArea; //Minsk Минская область
//        NSString *s6 = placemark.subAdministrativeArea; //Мiнск Минск
//        NSString *s7 = placemark.name; //Мiнск Минск
//        NSString *s8 = placemark.postalCode;
//        NSString *s9 = placemark.ISOcountryCode; //BY BY
        
//        @property (nonatomic, readonly) NSString *name; // eg. Apple Inc.
//        @property (nonatomic, readonly) NSString *thoroughfare; // street address, eg. 1 Infinite Loop
//        @property (nonatomic, readonly) NSString *subThoroughfare; // eg. 1
//        @property (nonatomic, readonly) NSString *locality; // city, eg. Cupertino
//        @property (nonatomic, readonly) NSString *subLocality; // neighborhood, common name, eg. Mission District
//        @property (nonatomic, readonly) NSString *administrativeArea; // state, eg. CA
//        @property (nonatomic, readonly) NSString *subAdministrativeArea; // county, eg. Santa Clara
//        @property (nonatomic, readonly) NSString *postalCode; // zip code, eg. 95014
//        @property (nonatomic, readonly) NSString *ISOcountryCode; // eg. US
//        @property (nonatomic, readonly) NSString *country; // eg. United States
//        @property (nonatomic, readonly) NSString *inlandWater; // eg. Lake Tahoe
//        @property (nonatomic, readonly) NSString *ocean; // eg. Pacific Ocean
//        @property (nonatomic, readonly) NSArray *areasOfInterest; // eg. Golden Gate Park        
    }];    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Could not find location: %@", error);
    [manager stopUpdatingLocation];
    [activityIndicator_ stopAnimating];    
}


//--------------------actions---------------------------------------------------
-(void)findPosition
{
    [locationManager_ startUpdatingLocation];
    [activityIndicator_ startAnimating];
    
}

- (void)foundLocation:(CLLocation *)loc
{
    CLLocationCoordinate2D coord = [loc coordinate];
    NSLog(@"found_loc: %f %f",coord.latitude,coord.longitude);
    
    // Create an instance of MapPoint with the current data
    NSString *str = [NSString stringWithFormat:@"Я здесь:%d",++scPos];
    MapPoint *mp = [[MapPoint alloc] initWithCoordinate:coord title:str subtitle:@"вызвать такси сюда"];
    mp.tag = 104;
    // Add it to the map view 
    [mapView_ addAnnotation:mp];
    
    // Zoom the region to this location
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 1000, 1000);
    [mapView_ setRegion:region animated:YES];
    
//    [locationTitleField setText:@""];
    [activityIndicator_ stopAnimating];
//    [locationTitleField setHidden:NO];
    [locationManager_ stopUpdatingLocation];
    
    

}


-(void)handleLongPressGesture:(UIGestureRecognizer*)sender 
{
    // This is important if you only want to receive one tap and hold event
    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateChanged)
        return;
    
//    if (sender.state == UIGestureRecognizerStateEnded)
//    {
//        [mapView_ removeGestureRecognizer:sender];
//    }
//    else
//    {
        // Here we get the CGPoint for the touch and convert it to latitude and longitude coordinates to display on the map
        CGPoint point = [sender locationInView:mapView_];
        CLLocationCoordinate2D locCoord = [mapView_ convertPoint:point toCoordinateFromView:mapView_];
        // Then all you have to do is create the annotation and add it to the map
        
        MapPoint *mp = [[MapPoint alloc] initWithCoordinate:locCoord title:@"my pin" subtitle:nil];
        mp.tag = 103;
        
//        MapPoint *dropPin = [[MapPoint alloc] init];
//        dropPin.coordinate.latitude = [NSNumber numberWithDouble:locCoord.latitude];
//        dropPin.longitude = [NSNumber numberWithDouble:locCoord.longitude];
        
        [mapView_ addAnnotation:mp];
        NSLog(@"add annot");
//    }
}

//------------------------------press actions-----------------------------------
- (IBAction)pressButtonPosition:(id)sender 
{
    NSLog(@"set position");
//    [mapView_ setShowsUserLocation:NO];
    
    [self findPosition];
}

- (IBAction)pressButtonTest:(id)sender {
    NSLog(@"press test");
    
    [mapView_ setShowsUserLocation:NO];
    
//    [mapView_ setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
//    [mapView_ setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    [geocoder geocodeAddressString:@"Москва" completionHandler:^(NSArray *placemarks, NSError *error) {
//        //Error checking
//        
//        CLPlacemark *placemark = [placemarks objectAtIndex:0];
//        MKCoordinateRegion region;
//        region.center.latitude = placemark.region.center.latitude;
//        region.center.longitude = placemark.region.center.longitude;
//        MKCoordinateSpan span;
//        double radius = placemark.region.radius / 1000; // convert to km
//        
//        NSLog(@"Radius is %f", radius);
//        span.latitudeDelta = radius / 112.0;
//        
//        region.span = span;
//        
//        [mapView_ setRegion:region animated:YES];
//    }];        
}


- (IBAction)pressTest2:(id)sender {
//    [mapView_ setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
//    [mapView_ setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
//    MapPoint *mp = [[MapPoint alloc] initWithCoordinate:mapView_.centerCoordinate title:@"my pin" subtitle:nil];
//    mp.tag = 100;    
//    [mapView_ addAnnotation:mp];
    
}



- (IBAction)changeMapType:(id)sender {
    NSInteger num = [sender selectedSegmentIndex];
    NSLog(@"change type %d",num);
    
    [[NSUserDefaults standardUserDefaults] 
     setInteger:num 
     forKey:kMapTypePrefKey];
    [[NSUserDefaults standardUserDefaults] synchronize]; 
    
    switch(num)
    {
        case 0:
        {
            [mapView_ setMapType:MKMapTypeStandard];
        } break;
        case 1:
        {
            [mapView_ setMapType:MKMapTypeSatellite];
        } break;
        case 2:
        {
            [mapView_ setMapType:MKMapTypeHybrid];
        } break;
    }

}


@end






