//
//  ForecastDetail.m
//  Jaunt
//
//  Created by John Bowles on 4/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ForecastDetail.h"


@implementation ForecastDetail

@synthesize summary;
@synthesize dayOfWeek;
@synthesize date;
@synthesize maxTemp;
@synthesize minTemp;
@synthesize probabilityOfPrecipitation;

#pragma mark -
#pragma mark Implementaton

-(NSComparisonResult)compareDate:(ForecastDetail *) aDetail
{
    return [self.date compare:aDetail.date];
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	
	[summary release];
	[dayOfWeek release];
	[date release];
	[maxTemp release];
	[minTemp release];
	[probabilityOfPrecipitation release];
    [super dealloc];
}

@end
