#import "MapPoint.h"

@implementation MapPoint

@synthesize coordinate, title, subtitle, tag, center, image;

- (id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t
{
    self = [super init];
    if (self) {
        coordinate = c;
        [self setTitle:t];
    }
    return self;
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t subtitle:(NSString *)s
{
    self = [super init];
    if (self) {
        coordinate = c;
        [self setTitle:t];
        [self setSubtitle:s];
    }
    return self;
}


@end
