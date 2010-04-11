//
//  Forecast.h
//  Jaunt
//
//  Created by John Bowles on 4/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ForecastDetail;

@interface Forecast : NSObject {

	NSString *latitude;
	NSString *longitude;
	NSString *city;
	NSString *state;
	NSMutableArray *forecastDetails;
}

@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSMutableArray *forecastDetails;

+(NSString *) noaaUrlForDestinations:(NSSet *) destinations;
-(id) init;
-(ForecastDetail *) todaysForecast;
-(NSComparisonResult)compareCity:(Forecast *) aForecast;

@end
