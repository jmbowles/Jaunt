//
//  Destination.h
//  Jaunt
//
//  Created by John Bowles on 11/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/NSManagedObject.h>

@class Trip;

@interface Destination : NSManagedObject {

}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSNumber *zipCode;
@property (nonatomic, retain) Trip *trip;

@end
