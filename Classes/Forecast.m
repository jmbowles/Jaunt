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
#import "ASIHTTPRequest.h"
#import "GDataXMLNode.h"
#import "Logger.h"

@implementation Forecast

@synthesize latitude;
@synthesize longitude;
@synthesize city;
@synthesize state;
@synthesize currentTemperature;
@synthesize imageKey;
@synthesize image;
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

+(NSString *) currentTemperatureForDestination:(Destination *) aDestination {
	
	NSString *baseUrl = @"http://www.weather.gov/forecasts/xml/sample_products/browser_interface/ndfdXMLclient.php?listLatLon=";
	NSString *products = nil;
	NSString *point = nil;
	NSString *temperature = nil;
	
	if ([aDestination.latitude doubleValue] > 0) {
		
		point = [NSString stringWithFormat:@"%1.3f,%1.3f", [aDestination.latitude doubleValue], [aDestination.longitude doubleValue]];
		
		NSDate *now = [NSDate date];
		NSCalendar *aCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *components = [[NSDateComponents alloc] init];
		[components setHour: 1];
		NSDate *nextHour = [aCalendar dateByAddingComponents:components toDate:now options:0];
		[aCalendar release];
		[components release];
		
		NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
		[aFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
		NSString *beginDate = [aFormatter stringFromDate:now];
		NSString *endDate = [aFormatter stringFromDate:nextHour];
		[aFormatter release];
		
		products = [NSString stringWithFormat:@"&begin=%@&end=%@&product=time-series&appt=appt", beginDate, endDate];
		
		NSString *noaaUrl = [NSString stringWithFormat:@"%@%@%@", baseUrl, point, products];
		ASIHTTPRequest *aRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:noaaUrl]];
		[aRequest startSynchronous];
		NSError *error = [aRequest error];
		
		if (!error) {
			
			NSData *xmlData = [aRequest responseData];
			NSError *error;
			GDataXMLDocument *aDocument = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
			GDataXMLElement *aLocation = [[aDocument nodesForXPath:@"//location" error:&error] objectAtIndex:0];
			GDataXMLElement *key = [[aLocation elementsForName:@"location-key"] objectAtIndex:0];
			NSString *currentTempXPath = [NSString stringWithFormat:@"/dwml/data/parameters[@applicable-location='%@']/temperature[@type='apparent']/value", [key stringValue]];
			temperature = [[[aDocument nodesForXPath:currentTempXPath error:&error] objectAtIndex:0] stringValue];
			
			[aDocument release];
		}
	}
	return temperature;
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
	[currentTemperature release];
	[imageKey release];
	[image release];
	[forecastDetails release];
	[super dealloc];
}

@end
