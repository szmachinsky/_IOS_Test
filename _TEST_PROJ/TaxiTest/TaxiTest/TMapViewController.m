//
//  TMapViewController.m
//  Test_2
//
//  Created by Admin on 24.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TMapViewController.h"
#import "MapPoint.h"

#define kMaxRoutePoints 100

#define kHomeAnn    200 
#define kFromAnn    111
#define kToAnn      112
#define kTraceAnn   202
#define kAddrAnn    100

@interface TMapViewController ()
- (void)findPosition;
- (void)foundLocation:(CLLocation *)loc;
- (void)draggingImage:(UIPanGestureRecognizer*) sender; 

- (void)pressSearch;
- (void)showSearchBar;
- (void)hideSearchBar;

- (void)addLocation:(CLLocationCoordinate2D)coord tag:(NSInteger)tag title:(NSString*)ttl subtitle:(NSString*)sttl;

- (void)deselectAnnot:(id <MKAnnotation>)annotation;

- (void)getInfoForPlace:(CLLocation *)loc;
- (void)getInfoForCoord:(CLLocationCoordinate2D)coord;

- (void)printLocaleInfo:(CLPlacemark *)placemark;

- (void)geokodingForAddress:(NSString*)addr;
- (void)geokodingForCoorg:(CLLocationCoordinate2D)coord;
- (void)geoPathFrom:(CLLocationCoordinate2D)coordFrom to:(CLLocationCoordinate2D)coordTo;

@end



//==============================================================================
@implementation TMapViewController
{
    
    __weak IBOutlet MKMapView *mapView_;    
    __weak IBOutlet UIImageView *imageFrom_;
    __weak IBOutlet UIImageView *imageTo_;
    
    __weak IBOutlet UIButton *butonMyPlace_;
    __weak IBOutlet UITextView *textInfo_;
    __weak IBOutlet UISearchBar *searchBar_;
    
    CLLocationManager *locationManager_;
    
    MapPoint *mapPointFrom_;
    MapPoint *mapPointTo_;
    
    MapPoint *initPoint_;
    CLLocationCoordinate2D initCoord;
    
    CLPlacemark *myPlacemark_;
    CLGeocoder *geoCoder_;
    
	CLLocationCoordinate2D  routeArr[kMaxRoutePoints];
    NSInteger scPoints;
    NSMutableArray *routeAnnot;
    
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"--init-- начало работы");
        
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
        routeAnnot = [[NSMutableArray alloc] initWithCapacity:100];
        
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"--dealloc--");
    
    [mapView_ setShowsUserLocation:NO];  
    
    [locationManager_ setDelegate:nil];
    [locationManager_ stopUpdatingLocation];
    
//    [activityIndicator_ stopAnimating];    
}


- (void)viewDidUnload
{
    mapView_ = nil;
    imageFrom_ = nil;
    imageTo_ = nil;
    butonMyPlace_ = nil;
    textInfo_ = nil;
    searchBar_ = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [mapView_ setShowsUserLocation:YES];
    
    UIPanGestureRecognizer* p1 = [[UIPanGestureRecognizer alloc]
                                    initWithTarget:self
                                    action:@selector(draggingImage:)];
    UIPanGestureRecognizer* p2 = [[UIPanGestureRecognizer alloc]
                                  initWithTarget:self
                                  action:@selector(draggingImage:)];
    [imageFrom_ addGestureRecognizer:p1];
    imageFrom_.tag = 1;
    [imageTo_ addGestureRecognizer:p2];
    imageTo_.tag = 2;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(pressSearch)];
    searchBar_.alpha = 0;
}
 

//------------------------------------------------------------------------------
#pragma mark - drag image (gesture)
- (void) draggingImage: (UIPanGestureRecognizer*) sender 
{
    UIView* vv = sender.view;
    if (sender.state == UIGestureRecognizerStateBegan ||
        sender.state == UIGestureRecognizerStateChanged) 
    {
        CGPoint delta = [sender translationInView: vv.superview];
        CGPoint c = vv.center;
        c.x += delta.x; c.y += delta.y;
        vv.center = c;
        [sender setTranslation:CGPointZero inView:vv.superview];
    }
    if (sender.state ==UIGestureRecognizerStateEnded) 
    {
// /       NSLog(@"gesture:set point");
//        CGPoint point1 = [sender locationInView:mapView_];
        CGPoint point2 = vv.center;
//        point2.y +=23;
//        point2.x -=1;
        point2.y -=8;
        point2.x -=1;
        CLLocationCoordinate2D locCoord = [mapView_ convertPoint:point2 toCoordinateFromView:mapView_];
        NSLog(@"gesture:set point %f %f",locCoord.latitude, locCoord.longitude);
        // Then all you have to do is create the annotation and add it to the map
        
        NSInteger tag = vv.tag;
        if (tag == 1) {            
//            MapPoint *mp = [[MapPoint alloc] initWithCoordinate:locCoord title:@"my pin" subtitle:nil];
//            mp.tag = 101;
            [mapView_ removeAnnotation:mapPointFrom_];
            mapPointFrom_.coordinate = locCoord;
            [mapView_ addAnnotation:mapPointFrom_];
        }
        if (tag == 2) {            
            [mapView_ removeAnnotation:mapPointTo_];
            mapPointTo_.coordinate = locCoord;
            [mapView_ addAnnotation:mapPointTo_];
       }
        
//        NSLog(@"add annot %d",tag);
//        [self getInfoForCoord:locCoord];
        [self geokodingForCoorg:locCoord];
    }
}



//----------------------------map's delegate------------------------------------
#pragma mark - Map's delegate methods
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)u
{
    //    CLLocationCoordinate2D l = u.location.coordinate;
    //    NSLog(@"map_location: %f %f",l.latitude,l.longitude);    
    CLLocationCoordinate2D loc = [u coordinate];
    NSLog(@"map_location: %f %f",loc.latitude,loc.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 1000, 1000);
    [mapView_ setRegion:region animated:YES];
        
    initCoord = loc;
    initPoint_ = [[MapPoint alloc] initWithCoordinate:loc title:@"я здесь" subtitle:nil];
    initPoint_.tag = kHomeAnn;
    
    mapPointFrom_ = [[MapPoint alloc] initWithCoordinate:loc title:@"oткуда" subtitle:nil];
    mapPointFrom_.tag = kFromAnn;
    CGPoint to = imageFrom_.center;
    mapPointFrom_.center = to;
    mapPointFrom_.image = imageFrom_;
    
    mapPointTo_ = [[MapPoint alloc] initWithCoordinate:loc title:@"куда" subtitle:nil];
    mapPointTo_.tag = kToAnn;
    mapPointTo_.center = imageTo_.center;    
    mapPointTo_.image = imageTo_;
    
    [mapView_ setShowsUserLocation:NO];  
    
    [self findPosition];
}



- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views 
{ 
    for (MKAnnotationView* aView in views) 
    {
        if ([aView.reuseIdentifier isEqualToString:@"fromPin1"] || 
            [aView.reuseIdentifier isEqualToString:@"toPin1"] ) 
        { 
            aView.alpha = 0;
//            [UIView beginAnimations:nil context:NULL];
//            [UIView setAnimationDuration:0.5];
//            CGPoint to = [(MapPoint*)aView.annotation center];
//            ((MapPoint*)(aView.annotation)).image.center = to;
//            aView.alpha = 1;
//            [UIView commitAnimations];
            
//            [UIView animateWithDuration:0.5 animations:^{
//                CGPoint to = [(MapPoint*)aView.annotation center];
//                ((MapPoint*)(aView.annotation)).image.center = to;
//                aView.alpha = 1;
//                [mapView_ selectAnnotation:(MapPoint*)(aView.annotation) animated:YES];
//            }];
            
            [UIView animateWithDuration:0.5 animations:^{
                CGPoint to = [(MapPoint*)aView.annotation center];
                ((MapPoint*)(aView.annotation)).image.center = to;
                aView.alpha = 1;
            } completion:^(BOOL finished) {
///                NSLog(@"+select");
                [mapView_ selectAnnotation:(MapPoint*)(aView.annotation) animated:YES];
//                sleep(2);
//                NSLog(@"+deselect");
//                [mapView_ deselectAnnotation:(MapPoint*)(aView.annotation) animated:YES];
                [self performSelector:@selector(deselectAnnot:) withObject:(aView.annotation) afterDelay:1.0];
            }];
        }
        
    }   
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
//    NSString *reuse = view.reuseIdentifier;
    if ([view.reuseIdentifier isEqualToString:@"tracePin"]) {
//        NSString *str1 = [view.annotation title];
        NSString *str2 = [view.annotation subtitle];
        textInfo_.text = str2;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView 
                didChangeDragState:(MKAnnotationViewDragState)newState 
                      fromOldState:(MKAnnotationViewDragState)oldState 
{
    if (newState == MKAnnotationViewDragStateEnding)
    {
//        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
///        NSLog(@"Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
        annotationView.alpha = 1.0;

    }
    if (newState == MKAnnotationViewDragStateCanceling)
    {
        annotationView.alpha = 1.0;
    }
    if (newState == MKAnnotationViewDragStateStarting)
    {
///        NSLog(@"Pin drag start");
//        CGPoint offset = annotationView.centerOffset;
//        offset.y -=10;
//        annotationView.centerOffset = offset;
        annotationView.alpha = 0.6;
//        ((MapPoint*)annotationView.annotation).title = @"можно перенести";
//        annotationView.canShowCallout = YES;
//        [mapView_ selectAnnotation:annotationView.annotation animated:YES];        
    }
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation 
{
    MKAnnotationView* v = nil;
    NSString *ttl = annotation.title;
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
                //                v.animatesDrop = YES;
                v.draggable = YES;  
                ((MKPinAnnotationView*)v).animatesDrop = YES;                
            } 
            v.annotation = annotation; 
        }
 
        if (tag == 200) {
            static NSString* ident = @"homePin00";            
            v = [mapView dequeueReusableAnnotationViewWithIdentifier:ident]; 
            if (v == nil) {
                v = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                 reuseIdentifier:ident];                
//                v.image = [UIImage imageNamed:@"__Maps-green-48.png"];                
//                v.centerOffset = CGPointMake(4,-14);                                                 
                v.image = [UIImage imageNamed:@"_Maps-green-32.png"];                
                v.centerOffset = CGPointMake(2,-10);                                                 
                v.canShowCallout = YES;
//              v.draggable = YES;                                
            } 
            //            CGPoint to = [(MapPoint*)annotation center];
            v.annotation = annotation; 
        }
        if (tag == 201) {
            static NSString* ident = @"customPin01";            
            v = [mapView dequeueReusableAnnotationViewWithIdentifier:ident]; 
            if (v == nil) {
                v = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                 reuseIdentifier:ident];                
                v.image = [UIImage imageNamed:@"Cross-32.png"];                
                v.centerOffset = CGPointMake(0,-1);                                                 
                v.canShowCallout = YES;
//              v.draggable = YES;                                
            } 
             v.annotation = annotation; 
        }
        if (tag == 202) { //trace
            static NSString* ident = @"tracePin";            
            v = [mapView dequeueReusableAnnotationViewWithIdentifier:ident]; 
            if (v == nil) {
                v = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                 reuseIdentifier:ident];                
//                v.image = [UIImage imageNamed:@"Map-Marker-Drawing-Pin-Right-Chartreuse-32.png"];                
                v.image = [UIImage imageNamed:@"Map-Marker-Drawing-Pin-Right-Pink-32.png"];                
                v.centerOffset = CGPointMake(-1,-13);                                                 
//                v.canShowCallout = YES;
                //              v.draggable = YES;                                
            } 
            v.annotation = annotation; 
        }
        
   
        if (tag == 111) {
            static NSString* ident = @"fromPin1";            
            v = [mapView dequeueReusableAnnotationViewWithIdentifier:ident]; 
            if (v == nil) {
                v = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                 reuseIdentifier:ident];                
//                v.image = [UIImage imageNamed:@"Map-Marker-Marker-Inside-Chartreuse-48.png"];                
//                v.centerOffset = CGPointMake(1,-23);   
                v.image = [UIImage imageNamed:@"Map-Marker-Marker-Inside-Chartreuse-32.png"];                
                v.centerOffset = CGPointMake(1,-15);   
                
                v.canShowCallout = YES;
                v.draggable = YES;                                
            } 
//            CGPoint to = [(MapPoint*)annotation center];
            v.annotation = annotation; 
        }
        
        if (tag == 112) {
            static NSString* ident = @"toPin1";            
            v = [mapView dequeueReusableAnnotationViewWithIdentifier:ident]; 
            if (v == nil) {
                v = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                 reuseIdentifier:ident];                           
//                v.image = [UIImage imageNamed:@"Map-Marker-Marker-Inside-Pink-48.png"];                                                         
//                v.centerOffset = CGPointMake(1,-23);
                v.image = [UIImage imageNamed:@"Map-Marker-Marker-Inside-Pink-32.png"];                                                         
                v.centerOffset = CGPointMake(1,-15);
                
                v.canShowCallout = YES;
                v.draggable = YES;  
            } 
            v.annotation = annotation; 
        }
        
        
    }
    return v; 
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isMemberOfClass:[MKPolyline class]])
    {
        //        MKCircleView *aView = (MKCircleView *)[[[MKPolylineView alloc] initWithPolyline:(MKPolyline *)overlay] autorelease];
        MKPolylineView *aView = [[MKPolylineView alloc] initWithPolyline:(MKPolyline *)overlay];
		[aView setStrokeColor:[UIColor redColor]];
		[aView setLineWidth:3];
        
        return aView;
    }
    if ([overlay isMemberOfClass:[MKCircle class]])
    {
        MKCircleView *aView = [[MKCircleView alloc] initWithCircle:overlay];
		[aView setStrokeColor:[UIColor blueColor]];
		[aView setLineWidth:3];
        
        return aView;
        
    }
    
    return nil;
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
        NSLog(@">>ignore cache location!");
        return;
    }    
    [self foundLocation:newLocation];    
}


//--------------------location actions------------------------------------------
#pragma mark - location actions (find,found)
- (void)findPosition
{
    [locationManager_ startUpdatingLocation];
    //    [activityIndicator_ startAnimating];
}


- (void)foundLocation:(CLLocation *)loc
{
    NSInteger count = mapView_.annotations.count;
    
    CLLocationCoordinate2D coord = [loc coordinate];
    NSLog(@"------>>>>:%d  found_loc: %f %f",count,coord.latitude,coord.longitude);
    
    initCoord = coord;
    if ( (initPoint_.coordinate.latitude == coord.latitude) && 
        (initPoint_.coordinate.longitude ==coord.longitude) ) {
    } else {
        initPoint_.coordinate = coord;
        [mapView_ removeAnnotation:initPoint_];
    };
    [mapView_ addAnnotation:initPoint_];
    
    if ( (mapPointFrom_.coordinate.latitude == coord.latitude) && 
        (mapPointFrom_.coordinate.longitude ==coord.longitude) ) {    
    } else {
        mapPointFrom_.coordinate = coord;
        [mapView_ removeAnnotation:mapPointFrom_]; 
    }
    [mapView_ addAnnotation:mapPointFrom_]; 
    
    [mapView_ selectAnnotation:mapPointFrom_ animated:YES];
    [self performSelector:@selector(deselectAnnot:) withObject:mapPointFrom_ afterDelay:1.0];
    
    // Zoom the region to this location
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 500, 500);
    [mapView_ setRegion:region animated:YES];
    
    //    [activityIndicator_ stopAnimating];
    [locationManager_ stopUpdatingLocation];
    [mapView_ setShowsUserLocation:NO];  
    
    count = mapView_.annotations.count;
    NSLog(@"------>>>>:%d",count);   
    
    
    //    [self getInfoForPlace:loc];
    //    [self getInfoForCoord:coord];
    [self geokodingForCoorg:coord];
}



//---------------------------my map's-------------------------------------------
#pragma mark - my map's methods

- (void)deselectAnnot:(id <MKAnnotation>)annotation
{
    ///    NSLog(@"+deselect");
    [mapView_ deselectAnnotation:annotation animated:YES];     
    //    [mapView_ selectAnnotation:annotation animated:NO];     
    //    [UIView animateWithDuration:1.0 animations:^{
    //        [mapView_ deselectAnnotation:annotation animated:YES]; 
    //    }];
    
//    if ([annotation isMemberOfClass:[MapPoint class]]) {
//        if (((MapPoint*)annotation).tag == kFromAnn) {            
////            (MapPoint*)annotation).
//        }

}


- (void)addLocation:(CLLocationCoordinate2D)coord tag:(NSInteger)tag title:(NSString*)ttl subtitle:(NSString*)sttl
{
    MapPoint *mapPoint = [[MapPoint alloc] initWithCoordinate:coord title:ttl subtitle:sttl];
    mapPoint.tag = tag;
    [mapView_ addAnnotation:mapPoint];                                                                                          
}


- (NSInteger)removeAnnotationsWithTag:(NSInteger)tg
{
    NSInteger res = 0;
    NSArray *arr = mapView_.annotations;
    for (id <MKAnnotation> p in arr) {
        if ([p isMemberOfClass:[MapPoint class]]) {
            if (((MapPoint*)p).tag == tg) {
                [mapView_ removeAnnotation:p];
                res ++;
            }
        }
    } 
    return res;
}

- (void)removeAllAnnotations
{
    NSArray *ann = mapView_.annotations;
    [mapView_ removeAnnotations:ann];     
}

- (void)removeAllOverlays
{
    NSArray *over = mapView_.overlays;
    [mapView_ removeOverlays:over];
}


- (void)showPlace:(CLLocationCoordinate2D)coord descr:(NSString*)desc
{
    textInfo_.text = desc;    
    
    MapPoint *mp = [[MapPoint alloc] initWithCoordinate:coord title:desc subtitle:nil];
    [self removeAnnotationsWithTag:kAddrAnn];
    mp.tag = kAddrAnn;
    [mapView_ addAnnotation:mp];                                                                                      
    [mapView_ setRegion: MKCoordinateRegionMakeWithDistance(mp.coordinate, 1000, 1000)                                                                                              animated: YES];      
}


- (void)resizeMapInRect:(double)lat1 lng1:(double)lng1 lat2:(double)lat2 lng2:(double)lng2
{
    //    NSLog(@"resize of = %f %f %f %f",lat1,lng1,lat2,lng2);
    if ((lat1 == lat2)&&(lng1 == lng2))
        return;
    double dlat = (lat1 + lat2)/2;
    double dlng = (lng1 + lng2)/2;
    CLLocation *l1 = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    CLLocation *l2 = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    CLLocation *l3 = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng2];
    
    CLLocationDistance d1 = [l1 distanceFromLocation:l2];
    if (d1 > 1000000)
        return;
    CLLocationDistance d2 = [l1 distanceFromLocation:l3];
    CLLocationDistance d3 = [l3 distanceFromLocation:l2];
    double dd = MAX(d2,d3);
    long ddl = dd;
    long del = 200;
    if (ddl >=1000) del = 250;
    if (ddl >= 2000) del = 500;
    if (ddl >= 5000) del = 1000;
    ddl = ((ddl /del) * del) + del;
    NSLog(@"resize : %lf %lf %lf  max = %f   res = %ld",d1,d2,d3,dd,ddl);
    
    CLLocationCoordinate2D cent =CLLocationCoordinate2DMake(dlat,dlng);
    //  MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(cent, d1/1.25, d1/1.25);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(cent, ddl, ddl);
    [mapView_ setRegion:region animated:YES];    
}



//-----------------------------buttons-------------------------------------------------
#pragma mark - press buttons
- (IBAction)pressMyPlace:(id)sender {
    NSLog(@"go to where i'm");
    
    // Zoom the region to this location
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(initCoord, 500, 500);
    [mapView_ setRegion:region animated:YES];
    
    [mapView_ selectAnnotation:initPoint_ animated:YES];
    [self performSelector:@selector(deselectAnnot:) withObject:initPoint_ afterDelay:1.0];

}

- (IBAction)pressBounds:(id)sender {
    
    [self resizeMapInRect:mapPointFrom_.coordinate.latitude lng1:mapPointFrom_.coordinate.longitude
                     lat2:mapPointTo_.coordinate.latitude lng2:mapPointTo_.coordinate.longitude];
}


- (IBAction)pressTest1:(id)sender {
    //    [self geokodingForAddress:@"Плющиха 10 Москва"];
    //    [self geokodingForAddress:@"Минск Кошевого 10"];
    
    [self geoPathFrom:mapPointFrom_.coordinate to:mapPointTo_.coordinate];
    return;    
}


- (IBAction)pressTest2:(id)sender 
{
    //    [self geokodingForAddress:@"Минск Кошевого 10"];
    
    //53.8879021,27.6109781    
    //    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(53.8879021,27.6109781);
    //    [self geokodingForCoorg:coord];
    
    NSInteger col = [self removeAnnotationsWithTag:kTraceAnn];

    if (col == 0) {
        for (MapPoint *mapPoint in routeAnnot) {
            [mapView_ addAnnotation:mapPoint];
        }
    }
    return;
}


- (IBAction)pressGoTo:(id)sender {
    //40.767323 -73.966722    NY
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:40.767323 longitude:-73.966722];  
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc.coordinate, 1000, 1000);
    [mapView_ setRegion:region animated:YES];
    
}

- (IBAction)pressGoTo2:(id)sender {
    //55.756492 37.622222  MSK
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:55.756492 longitude:37.622222];  
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc.coordinate, 1000, 1000);
    [mapView_ setRegion:region animated:YES];
    
}

- (IBAction)pressGoTo3:(id)sender {
    //53.8879 27.6111  MINSK
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:53.8879 longitude:27.6111];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc.coordinate, 1000, 1000);
    [mapView_ setRegion:region animated:YES];
    
}


//---------------------------------searchBar------------------------------------
#pragma mark - search bar

- (void)pressSearch
{
    
    if (searchBar_.alpha < 0.5) {
        [self showSearchBar];
    }   else {
        [self hideSearchBar];
    }
}

- (void)showSearchBar
{
    //    searchBar_.alpha = 0.0;
    [UIView animateWithDuration:0.7 animations:^{
        searchBar_.alpha = 0.9; 
        //        CGPoint pp = imageFrom_.center;
        //        pp.y = pp.y + 50;
        //        imageFrom_.center = pp;        
    }];
}

- (void)hideSearchBar
{
    //    searchBar_.alpha = 0.8;    
    [UIView animateWithDuration:0.7 animations:^{
        searchBar_.alpha = 0.0;    
    }];
    
}


//-----------------------------searchBar delegates------------------------------
#pragma mark - search bar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (searchBar.text == nil)
        searchBar.text=@"BY Минск ";
    return YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar 
{ 
    NSString* s = searchBar.text;
    [searchBar resignFirstResponder]; 
    
    if ([s length] > 10)
        [self geokodingForAddress:s]; //google API
    return;
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar 
{
    [searchBar resignFirstResponder];
    [self hideSearchBar];
}


//---------------------------------Apple API------------------------------------------------------
#pragma mark - geocoding (Apple API)
- (void)getInfoForPlace:(CLLocation *)loc
{
    __block CLPlacemark *myPlacemark;
    [geoCoder_ reverseGeocodeLocation:loc 
                    completionHandler:^(NSArray *placemarks, NSError *error) {
                        NSLog(@"place1 (%d)",[placemarks count]);
                        CLPlacemark *placemark = [placemarks objectAtIndex:0];
                        myPlacemark=placemark; 
                        NSLog(@"place1 is =(%@)",[placemark description]);
                        [self printLocaleInfo:placemark];
                    }];
}


- (void)getPlace:(NSString*)s
{
    //    [geoCoder_ geocodeAddressString:s 
    //            completionHandler:^(NSArray *placemarks, NSError *error) {
    //                    if (nil == placemarks) {
    //                        NSLog(@"%@", error.localizedDescription);
    //                        return; 
    //                    }
    //                    NSInteger col = [placemarks count];
    //                    CLPlacemark* p = [placemarks objectAtIndex:0];
    //                NSLog(@"found:%d",col);
    //                    [self printLocaleInfo:p];
    //                
    //                    MKPlacemark* mp = [[MKPlacemark alloc] initWithPlacemark:p];                                                                                      
    //                    [mapView_ removeAnnotations:mapView_.annotations]; 
    //                    [mapView_ addAnnotation:mp];                                                                                      
    //                    [mapView_ setRegion: MKCoordinateRegionMakeWithDistance(mp.coordinate, 1000, 1000)                                                                                              animated: YES];
    //            }];
    
}

- (void)getInfoForCoord:(CLLocationCoordinate2D)coord
{
    __block CLPlacemark *myPlacemark;
    //    CLLocationCoordinate2D c = coord;
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];    
    [geoCoder_ reverseGeocodeLocation:loc
                    completionHandler:^(NSArray *placemarks, NSError *error) {
                        NSLog(@"place2 (%d)",[placemarks count]);
                        CLPlacemark *placemark = [placemarks objectAtIndex:0];
                        myPlacemark=placemark; 
                        NSLog(@"place2 is =(%@)",[placemark description]);
                        [self printLocaleInfo:placemark];
                    }];
}


- (void)printLocaleInfo:(CLPlacemark *)placemark
{
    NSString *s1 = placemark.country; //Belarus Белоруссия
    NSString *s2 = placemark.thoroughfare; //nil
    NSString *s22= placemark.subThoroughfare;        
    NSString *s3 = placemark.locality;
    NSString *s4 = placemark.subLocality;
    NSString *s5 = placemark.administrativeArea; //Minsk Минская область
    NSString *s6 = placemark.subAdministrativeArea; //Мiнск Минск
    NSString *s7 = placemark.name; //Мiнск Минск
    NSString *s8 = placemark.postalCode;
    NSString *s9 = placemark.ISOcountryCode; //BY BY
    if (s1 != nil) NSLog(@"s1=(%@)",s1);
    if (s2 != nil) NSLog(@"s2=(%@)",s2);
    if (s22 != nil) NSLog(@"s22=(%@)",s22);
    if (s3 != nil) NSLog(@"s3=(%@)",s3);
    if (s4 != nil) NSLog(@"s4=(%@)",s4);
    if (s5 != nil) NSLog(@"s5=(%@)",s5);
    if (s6 != nil) NSLog(@"s6=(%@)",s6);
    if (s7 != nil) NSLog(@"s7=(%@)",s7);
    if (s8 != nil) NSLog(@"s8=(%@)",s8);
    if (s9 != nil) NSLog(@"s9=(%@)",s9);
    
    //    textInfo_.text = [placemark.addressDictionary description];
    //    NSLog(@"%@",[placemark.addressDictionary description]);
    
    NSString *str =  ABCreateStringWithAddressDictionary(placemark.addressDictionary,YES);
    NSLog(@"(%@)",str);
    textInfo_.text = str;
    
}



//--------------------------------help methods ------------------------------------------------------
#pragma mark - help methods
- (NSString *)escapedStringFromString:(NSString *)string 
{
//    NSString * result = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, /* allocator */
//                                                                            (CFStringRef)string,
//                                                                            NULL, /* charactersToLeaveUnescaped */
//                                                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
//                                                                            kCFStringEncodingUTF8);    
    NSString *res = (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)string, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    return res;
}


//----------------------------------TRACE---------------------------------------
#pragma mark - trace build
- (void)initTrace
{
//  routeArr[kMaxRoutePoints];
    scPoints = 0; 
    [self removeAnnotationsWithTag:kTraceAnn];
    
    [routeAnnot removeAllObjects];

}

- (void)addPointToTrace:(CLLocationCoordinate2D)coord title:(NSString*)ttl
{
    if (scPoints >= kMaxRoutePoints) return;
    if (scPoints > 0) 
    {
        CLLocationCoordinate2D c = routeArr[scPoints-1];
        if ((c.latitude == coord.latitude)&&(c.longitude == coord.longitude)) {
            NSInteger cnt = [routeAnnot count];
            MapPoint *mapPoint = [routeAnnot objectAtIndex:cnt -1];
            mapPoint.subtitle = ttl;
            return;  
        }
    }
    routeArr[scPoints] = coord;
    scPoints++;    
    
    MapPoint *mapPoint = [[MapPoint alloc] initWithCoordinate:coord title:@":" subtitle:ttl];
    mapPoint.tag = kTraceAnn;
    [routeAnnot addObject:mapPoint];
//    NSLog(@"add point: (%f,%f)",coord.latitude,coord.longitude);
}

- (void)showTrace
{
    if (scPoints < 2)
        return;
    NSLog(@"show trace (%d) points",scPoints);
    [self removeAllOverlays];
    
    MKPolyline *poly = [MKPolyline polylineWithCoordinates:routeArr count:scPoints];
    [poly setTitle:@"Маршрут"];
    [mapView_ addOverlay:poly]; 
    
}


//-----------------------------GOOGLE API------------------------------------------------------------
#pragma mark - Google API

- (void)fetchedDataRoutes:(NSData *)data goTo:(BOOL)goOk
{
    NSError *error = nil;
    NSDictionary *dic = nil;
    if ([data length] > 0)
        dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error]; 
    if (dic == nil)
        return;
    
    
    NSString *stat = [dic objectForKey:@"status"];
    NSArray *routes = [dic objectForKey:@"routes"];
    NSInteger count = [routes count];
    NSLog(@"\nstatus = (%@) \n routes=[%d]",stat,count);
    NSDictionary *route = [routes objectAtIndex:0];
    if (![stat isEqualToString:@"OK"])
        return;
    if (route == nil)
        return;
    
//    NSDictionary *d = [route valueForKeyPath:@"bounds"];
//    NSLog(@"%@",d);    
    NSString *blat1 = [route valueForKeyPath:@"bounds.northeast.lat"];
    NSString *blng1 = [route valueForKeyPath:@"bounds.northeast.lng"];  
    NSString *blat2 = [route valueForKeyPath:@"bounds.southwest.lat"];
    NSString *blng2 = [route valueForKeyPath:@"bounds.southwest.lng"];         
    NSLog(@"%@ %@ %@ %@",blat1,blng1,blat2,blng2);
    double dlat1 = [blat1 doubleValue];
    double dlng1 = [blng1 doubleValue];
    double dlat2 = [blat2 doubleValue];
    double dlng2 = [blng2 doubleValue];
    [self resizeMapInRect:dlat1 lng1:dlng1 lat2:dlat2 lng2:dlng2]; 
    
    
    NSString *summary = [route objectForKey:@"summary"];
    NSArray *legs = [route objectForKey:@"legs"];
    NSLog(@" summary = %@ legs = %d",summary,[legs count]);
    NSDictionary *leg = [legs objectAtIndex:0];
    if (leg == nil)
        return;
// one leg    
    NSString *start_addr = [leg objectForKey:@"start_address"];
    NSDictionary *start_loc = [leg objectForKey:@"start_location"];
    NSString *val1 = [start_loc objectForKey:@"lat"];
    double lat1 = [val1 doubleValue];
    val1 = [start_loc objectForKey:@"lng"];
    double lng1 = [val1 doubleValue];    
    NSLog(@"(%@) (%f,%f)",start_addr,lat1,lng1); 
///    CLLocationCoordinate2D coord1 = CLLocationCoordinate2DMake(lat1,lng1);
///    [self addLocation:coord1 tag:201];

    NSString *end_address = [leg objectForKey:@"end_address"];
    NSDictionary *end_loc = [leg objectForKey:@"end_location"];
    NSString *val2 = [end_loc objectForKey:@"lat"];
    double lat2 = [val2 doubleValue];
    val2 = [end_loc objectForKey:@"lng"];
    double lng2 = [val2 doubleValue];    
    NSLog(@"(%@) (%f,%f)",end_address,lat2,lng2); 
///    CLLocationCoordinate2D coord2 = CLLocationCoordinate2DMake(lat2,lng2);
///    [self addLocation:coord2 tag:201];
    
    NSDictionary *distance = [leg objectForKey:@"distance"];
    NSString *dtxt = [distance objectForKey:@"text"];
    NSString *dval = [distance objectForKey:@"value"];
    
    NSDictionary *duration = [leg objectForKey:@"duration"];
    NSString *drtxt = [duration objectForKey:@"text"];
    NSString *drval = [duration objectForKey:@"value"];
    NSLog(@"(%@)(%@)(%@)(%@)",dtxt,dval,drtxt,drval);
    
    NSString *descr = [NSString stringWithFormat:@" %@\n %@\n                      %@ %@",start_addr, end_address, dtxt, drtxt];
    textInfo_.text = descr;
    
    NSArray *steps = [leg objectForKey:@"steps"];
    NSInteger sc = [steps count];
    if (sc == 0)
        return;
    [self initTrace];
    NSDictionary *step;
    for (NSInteger idd = 0; idd < sc; idd++) {
        step = [steps objectAtIndex:idd];
 
        
        NSDictionary *distance = [step objectForKey:@"distance"];
        NSString *dtxt = [distance objectForKey:@"text"];
        NSString *dval = [distance objectForKey:@"value"];
        
        NSDictionary *duration = [step objectForKey:@"duration"];
        NSString *drtxt = [duration objectForKey:@"text"];
        NSString *drval = [duration objectForKey:@"value"];
        NSLog(@" > step %d (%@)(%@)(%@)(%@)",idd,dtxt,dval,drtxt,drval);
        
        NSDictionary *s_loc = [step objectForKey:@"start_location"];
        NSString *val11 = [s_loc objectForKey:@"lat"];
        double lat11 = [val11 doubleValue];
        val11 = [s_loc objectForKey:@"lng"];
        double lng11 = [val11 doubleValue];    
//        NSLog(@" (%@) (%f,%f)",s_loc,lat11,lng11); 

        NSDictionary *e_loc = [step objectForKey:@"end_location"];
        NSString *val22 = [e_loc objectForKey:@"lat"];
        double lat22 = [val22 doubleValue];
        val22 = [e_loc objectForKey:@"lng"];
        double lng22 = [val22 doubleValue];    
        NSLog(@" >    (%f,%f) (%f,%f)",lat11,lng11,lat22,lng22); 
        CLLocationCoordinate2D coord11 = CLLocationCoordinate2DMake(lat11,lng11);
///        [self addLocation:coord11 tag:kTraceAnn];
        CLLocationCoordinate2D coord22 = CLLocationCoordinate2DMake(lat22,lng22);
        
///        [self addLocation:coord22 tag:101];
        
        NSString *html_instructions = [step objectForKey:@"html_instructions"];
//        NSLog(@" >    html_instr1 = (%@)",html_instructions);
        NSMutableString *str = [[NSMutableString alloc] initWithString:html_instructions];
        
        
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<[^>]*>"
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        [regex replaceMatchesInString:str options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [str length]) withTemplate:@" "];
        NSLog(@" >    html_instr = (%@)",str);
                
        
        [self addPointToTrace:coord11 title:str];
        [self addPointToTrace:coord22 title:@"вы приехали"];
        
//        if (idd == 0)
//            textInfo_.text = str;
    }
    [self showTrace];
}


- (void)geoPathFrom:(CLLocationCoordinate2D)coordFrom to:(CLLocationCoordinate2D)coordTo
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *place1 = [NSString stringWithFormat:@"%f,%f",coordFrom.latitude,coordFrom.longitude];
        NSString *place2 = [NSString stringWithFormat:@"%f,%f",coordTo.latitude,coordTo.longitude];
        NSString *requestUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&language=ru&sensor=false",place1,place2];
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]
                                                           cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                       timeoutInterval:60];
        NSError *error = nil;
        NSLog(@"route from (%@) to (%@)", place1,place2);
        NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fetchedDataRoutes:data goTo:NO];
        });
    });
    
}



- (void)fetchedDataGeocoder:(NSData *)data goTo:(BOOL)goOk
{
    NSError *error = nil;
    NSDictionary *dic = nil;
    if ([data length] > 0)
        dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error]; 
    if (dic) {
        //        NSLog(@">>>[%@]",dic);
        NSString *stat = [dic objectForKey:@"status"];
        NSArray *res = [dic objectForKey:@"results"];
        NSInteger count = [res count];
        NSLog(@"stat = (%@) \n res_count = [%d]",stat,count);
        for (NSInteger idd = 0; idd < 1/*count*/; idd++) {
            NSDictionary *rdic = [res objectAtIndex:idd];
            NSString *res_addr = [rdic objectForKey:@"formatted_address"];
            NSDictionary *loc = [[rdic objectForKey:@"geometry"] objectForKey:@"location"];
            //            NSLog(@">%d> (%@) (%@)",idd,res_addr,loc);
            NSString *val = [loc objectForKey:@"lat"];
            double lat = [val doubleValue];
            val = [loc objectForKey:@"lng"];
            double lng = [val doubleValue];
            NSString *desc = [NSString stringWithFormat:@"%@\n(%f,%f)",res_addr,lat,lng];
            NSLog(@"%@",desc);
            
            CLLocationCoordinate2D res_coord = CLLocationCoordinate2DMake(lat,lng);
            //            CLLocation *res_loc = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
            
            if (goOk)
                [self showPlace:res_coord descr:desc];
        }
        
    }
}


- (void)geokodingForAddress:(NSString*)addr
{    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{        
        NSString *place = [addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *requestUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&language=ru&sensor=false",place];
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl] 
                                                           cachePolicy:NSURLRequestReturnCacheDataElseLoad 
                                                       timeoutInterval:30];          
        NSError *error = nil;
        NSLog(@"request for (%@) (%@)",addr, place);
        NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];       
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fetchedDataGeocoder:data goTo:YES];
        });                                
    });    
}

- (void)geokodingForCoorg:(CLLocationCoordinate2D)coord
{    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{        
        NSString *place = [NSString stringWithFormat:@"%f,%f",coord.latitude,coord.longitude];
        NSString *requestUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%@&language=ru&sensor=false",place];
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl] 
                                                           cachePolicy:NSURLRequestReturnCacheDataElseLoad 
                                                       timeoutInterval:30];          
        NSError *error = nil;
        NSLog(@"request for (%@)", place);
        NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:nil error:&error];       
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fetchedDataGeocoder:data goTo:NO];
        });                                
    });    
}





@end



//https://developers.google.com/maps/faq?hl=ru#languagesupport
//https://developers.google.com/maps/documentation/directions/?hl=ru#Routes
//https://developers.google.com/maps/documentation/geocoding/?hl=ru#ReverseGeocoding

