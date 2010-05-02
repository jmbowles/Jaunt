//
//  WeatherController.h
//  Jaunt
//
//  Created by John Bowles on 10/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Trip;
@class ActivityManager;
@class Forecast;

@interface WeatherController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {

	Trip *trip;
	NSMutableArray *forecasts;

@private
	ActivityManager *activityManager;
	NSMutableDictionary *iconDictionary;
	NSOperationQueue *queue;
	Forecast *selectedForecast;
}

@property (nonatomic, retain) Trip *trip;
@property (nonatomic, retain) NSMutableArray *forecasts;
@property (nonatomic, retain) ActivityManager *activityManager;
@property (nonatomic, retain) NSMutableDictionary *iconDictionary;
@property (nonatomic, retain) NSOperationQueue *queue;
@property (nonatomic, retain) Forecast *selectedForecast;

@end
