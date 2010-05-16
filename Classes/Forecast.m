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

@interface Forecast (PrivateMethods)

+(NSString *) buildPointsForDestinations:(NSSet *) destinations;
+(NSString *) buildPointForDestination:(Destination *) destination;

@end


@implementation Forecast

@synthesize latitude;
@synthesize longitude;
@synthesize city;
@synthesize state;
@synthesize currentTemperature;
@synthesize imageKey;
@synthesize image;
@synthesize forecastDetails;
@synthesize hourlyDetails;


#pragma mark -
#pragma mark Construction

-(id) init {
	
	if (self = [super init]) {
		
		self.forecastDetails = [NSMutableArray array];
		self.hourlyDetails = [NSMutableArray array];
	}
	return self;
}

#pragma mark -
#pragma mark Implementaton

+(NSString *) noaaUrlForDestinations:(NSSet *) destinations {
	
	NSString *baseUrl = @"http://www.weather.gov/forecasts/xml/sample_products/browser_interface/ndfdBrowserClientByDay.php?listLatLon=";
	NSString *products = @"&format=24+hourly&numDays=7";
	NSString *points = [Forecast buildPointsForDestinations:destinations];
	NSString *url = [NSString stringWithFormat:@"%@%@%@", baseUrl, points, products];
	
	return url;
}

+(NSString *) noaaHourlyUrlForLatitude:(NSString *) latitude andLongitude:(NSString *) longitude {
	
	NSDate *now = [NSDate date];
	NSCalendar *aCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *hourlyComponents = [[NSDateComponents alloc] init];
	[hourlyComponents setHour: 24];
	NSDate *endingDate = [aCalendar dateByAddingComponents:hourlyComponents toDate:now options:0];
	NSDateComponents *endingHourComponents = [aCalendar components:NSHourCalendarUnit fromDate:endingDate];
	
	NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
	[aFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *lastHour = [NSString stringWithFormat:@"&end=%@T%i:00:00", [aFormatter stringFromDate:endingDate], [endingHourComponents hour]];

	[aFormatter release];
	[aCalendar release];
	[hourlyComponents release];
	
	NSString *baseUrl = [NSString stringWithFormat:@"http://www.weather.gov/forecasts/xml/sample_products/browser_interface/ndfdXMLclient.php?lat=%@&lon=%@", latitude, longitude];
	NSString *products = @"&product=time-series&appt=appt&wspd=wspd&wdir=wdir&icons=icons";
	NSString *url = [NSString stringWithFormat:@"%@%@%@", baseUrl, lastHour, products];
	
	[Logger logMessage:url withTitle:@"Hourly URL"];
	return url;
}

+(NSString *) buildPointsForDestinations:(NSSet *) destinations {
	
	NSString *points = @"";
	
	NSArray *anArray = [destinations allObjects];
	int totalItems = [anArray count];
	
	for (int i = 0; i < totalItems; i++) {
		
		Destination *aDestination = [anArray objectAtIndex:i];
		
		if ([aDestination.latitude doubleValue] > 0) {
			
			NSString *point = [Forecast buildPointForDestination:aDestination];
			
			if (i + 1 < totalItems) {
				
				point = [point stringByAppendingString:@"+"];
				points = [points stringByAppendingString:point];
				
			} else {
				
				points = [points stringByAppendingString:point];
			}
		}
	}
	return points;
}

+(NSString *) buildPointForDestination:(Destination *) destination {
	
	NSString *point = nil;
	
	if ([destination.latitude doubleValue] > 0) {
		
		point = [NSString stringWithFormat:@"%1.3f,%1.3f", [destination.latitude doubleValue], [destination.longitude doubleValue]];
	}
	return point;
}

+(NSMutableDictionary *) currentTemperaturesForDestinations:(NSSet *) destinations {
	
	NSMutableDictionary *temperatures = [NSMutableDictionary dictionaryWithCapacity:[destinations count]];
	NSString *baseUrl = @"http://www.weather.gov/forecasts/xml/sample_products/browser_interface/ndfdXMLclient.php?listLatLon=";
	NSString *points = [Forecast buildPointsForDestinations:destinations];
	NSString *products = nil;
	NSString *temperature = nil;
	
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
	
	NSString *noaaUrl = [NSString stringWithFormat:@"%@%@%@", baseUrl, points, products];
	
	ASIHTTPRequest *aRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:noaaUrl]];
	[aRequest startSynchronous];
	NSError *error = [aRequest error];
	
	if (!error) {
		
		NSData *xmlData = [aRequest responseData];
		NSError *error;
		GDataXMLDocument *aDocument = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
		NSArray *locations = [aDocument nodesForXPath:@"//location" error:&error];
		
		for (GDataXMLElement *aLocation in locations) {
			
			GDataXMLElement *key = [[aLocation elementsForName:@"location-key"] objectAtIndex:0];
			NSString *currentTempXPath = [NSString stringWithFormat:@"/dwml/data/parameters[@applicable-location='%@']/temperature[@type='apparent']/value", [key stringValue]];
			temperature = [[[aDocument nodesForXPath:currentTempXPath error:&error] objectAtIndex:0] stringValue];
			[temperatures setValue:temperature forKey:[key stringValue]];
		}
		[aDocument release];
	}
	return temperatures;
}

+(NSString *) windDirectionUsingBearing:(NSUInteger) aBearing {

	NSString *direction = @"";
	
	if (aBearing == 0 || aBearing == 360) {
		direction = @"N";
	}
	if (aBearing == 90) {
		direction = @"E";
	}
	if (aBearing == 180) {
		direction = @"S";
	}
	if (aBearing == 270) {
		direction = @"W";
	}
	if (aBearing > 0 && aBearing < 90) {
		direction = @"NE";
	}
	if (aBearing > 90 && aBearing < 180) {
		direction = @"SE";
	}
	if (aBearing > 180 && aBearing < 270) {
		direction = @"SW";
	}
	if (aBearing > 270 && aBearing < 360) {
		direction = @"NW";
	}
	return direction;
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
	[hourlyDetails release];
	[super dealloc];
}

@end
