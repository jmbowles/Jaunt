//
//  HourlyDetail.m
//  Jaunt
//
//  Created by John Bowles on 5/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HourlyDetail.h"


@implementation HourlyDetail

@synthesize hour;
@synthesize temperature;
@synthesize windSpeed;
@synthesize windDirection;
@synthesize imageKey;


#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	
	[hour release];
	[temperature release];
	[windSpeed release];
	[windDirection release];
	[imageKey release];
    [super dealloc];
}

@end