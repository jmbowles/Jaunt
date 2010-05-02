//
//  HourlyDetail.h
//  Jaunt
//
//  Created by John Bowles on 5/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HourlyDetail : NSObject {

	NSString *hour;
	NSString *temperature;
	NSString *windSpeed;
	NSString *windDirection;
	NSString *imageKey;
}

@property (nonatomic, retain) NSString *hour;
@property (nonatomic, retain) NSString *temperature;
@property (nonatomic, retain) NSString *windSpeed;
@property (nonatomic, retain) NSString *windDirection;
@property (nonatomic, retain) NSString *imageKey;

@end
