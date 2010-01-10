//
//  DestinationAnnotation.m
//  Jaunt
//
//  Created by John Bowles on 1/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MapAnnotation.h"


@implementation MapAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;


#pragma mark -
#pragma mark Construction and Initialization

-(id) initWithCoordinate: (CLLocationCoordinate2D) aCoordinate  {

	if (self = [super init]) {
		
		coordinate = aCoordinate;
	}
	return self;
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	
	[title release];
	[subtitle release];
    [super dealloc];
}

@end
