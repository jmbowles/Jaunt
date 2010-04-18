//
//  Forecast.h
//  Jaunt
//
//  Created by John Bowles on 4/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ForecastDetail;
@class Destination;

@interface Forecast : NSObject {

	NSString *latitude;
	NSString *longitude;
	NSString *city;
	NSString *state;
	NSString *currentTemperature;
	NSString *imageKey;
	UIImage *image;
	NSMutableArray *forecastDetails;
}

@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *currentTemperature;
@property (nonatomic, retain) NSString *imageKey;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSMutableArray *forecastDetails;

+(NSString *) noaaUrlForDestinations:(NSSet *) destinations;
+(NSString *) currentTemperatureForDestination:(Destination *) aDestination;
-(id) init;
-(ForecastDetail *) todaysForecast;
-(NSComparisonResult)compareCity:(Forecast *) aForecast;

@end
