//
//  RestaurantEntry.h
//  Jaunt
//
//  Created by John Bowles on 3/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoogleEntry.h"


@interface RestaurantEntry : NSObject <GoogleEntry> {
	
	NSString *location;
	NSString *filter;
	NSString *name;
}

@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *filter;
@property (nonatomic, retain) NSString *name;

-(id) initWithLocation:(NSString *) aLocation withName:(NSString *) aName andFilter:(NSString *) aFilter;

@end