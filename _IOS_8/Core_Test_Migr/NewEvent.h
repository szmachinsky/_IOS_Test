//
//  NewEvent.h
//  Core_Test
//
//  Created by Zmachinsky Sergei on 09.03.15.
//  Copyright (c) 2015 Zmachinsky Sergei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NewEvent : NSManagedObject

@property (nonatomic, retain) NSString * detail_1;
@property (nonatomic, retain) NSString * detail_2;
@property (nonatomic, retain) NSDate * when;
@property (nonatomic, retain) NSNumber * x;
@property (nonatomic, retain) NSNumber * f;

@end
