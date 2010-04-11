//
//  Forecast.m
//  Jaunt
//
//  Created by John Bowles on 4/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Forecast.h"
#import "ForecastDetail.h"
#import "Destination.h"
#import "Logger.h"

@implementation Forecast

@synthesize latitude;
@synthesize longitude;
@synthesize city;
@synthesize state;
@synthesize forecastDetails;

#pragma mark -
#pragma mark Construction

-(id) init {
	
	if (self = [super init]) {
		
		self.forecastDetails = [NSMutableArray array];
	}
	return self;
}

#pragma mark -
#pragma mark Implementaton

+(NSString *) noaaUrlForDestinations:(NSSet *) destinations {
	
	NSString *baseUrl = @"http://www.weather.gov/forecasts/xml/sample_products/browser_interface/ndfdBrowserClientByDay.php?listLatLon=";
	NSString *products = @"&format=24+hourly&numDays=7";
	NSString *points = @"";
	
	NSArray *anArray = [destinations allObjects];
	int totalItems = [anArray count];
	
	for (int i = 0; i < totalItems; i++) {
		
		Destination *aDestination = [anArray objectAtIndex:i];
		
		if ([aDestination.latitude doubleValue] > 0) {
			
			NSString *point = [NSString stringWithFormat:@"%1.3f,%1.3f", [aDestination.latitude doubleValue], [aDestination.longitude doubleValue]];
			
			[Logger logMessage:point withTitle:@"Point"];
		
			if (i + 1 < totalItems) {
			
				point = [point stringByAppendingString:@"+"];
				points = [points stringByAppendingString:point];
			
			} else {
			
				points = [points stringByAppendingString:point];
			}
		}
	}
	
	NSString *url = [NSString stringWithFormat:@"%@%@%@", baseUrl, points, products];
	
	return url;
}

-(ForecastDetail *) todaysForecast {

	NSArray *sortedArray =[self.forecastDetails sortedArrayUsingSelector:@selector(compareDate:)];
	return [sortedArray objectAtIndex:0];
}

-(NSComparisonResult)compareCity:(Forecast *) aForecast {
	
	return [self.city compare:aForecast.city];
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	
	[latitude release];
	[longitude release];
	[city release];
	[state release];
	[forecastDetails release];
	[super dealloc];
}

@end
