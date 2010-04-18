//
//  ForecastDetail.h
//  Jaunt
//
//  Created by John Bowles on 4/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ForecastDetail : NSObject {

	NSString *summary;
	NSDate *date;
	NSString *dayOfWeek;
	NSString *maxTemp;
	NSString *minTemp;
	NSString *probabilityOfPrecipitation;
	NSString *imageKey;
	UIImage *image;
}

@property (nonatomic, retain) NSString *summary;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *dayOfWeek;
@property (nonatomic, retain) NSString *maxTemp;
@property (nonatomic, retain) NSString *minTemp;
@property (nonatomic, retain) NSString *probabilityOfPrecipitation;
@property (nonatomic, retain) NSString *imageKey;
@property (nonatomic, retain) UIImage *image;

-(NSComparisonResult)compareDate:(ForecastDetail *) aDetail;

@end
