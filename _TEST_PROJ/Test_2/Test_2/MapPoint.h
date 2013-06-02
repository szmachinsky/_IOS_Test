#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapPoint : NSObject <MKAnnotation>
{    
    NSString *title;
    NSString *subtitle;
    CLLocationCoordinate2D coordinate;
    NSInteger tag;
    CGPoint center;
    __weak UIImageView *image;
}

// A new designated initializer for instances of MapPoint
- (id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t;
- (id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t subtitle:(NSString *)s;

// This is a required property from MKAnnotation
@property (nonatomic) CLLocationCoordinate2D coordinate;

// This is an optional property from MKAnnotation
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) CGPoint center;
@property (nonatomic, weak) UIImageView *image;

@end
