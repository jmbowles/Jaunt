//
//  WeatherController.h
//  Jaunt
//
//  Created by John Bowles on 10/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReachabilityDelegate.h"


@class Trip;
@class ActivityManager;
@class Forecast;
@class ReachabilityManager;

@interface WeatherController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, ReachabilityDelegate> {

	Trip *trip;
	NSMutableArray *forecasts;

@private
	ActivityManager *activityManager;
	NSMutableDictionary *iconDictionary;
	NSOperationQueue *queue;
	Forecast *selectedForecast;
	ReachabilityManager *reachability;
}

@property (nonatomic, retain) Trip *trip;
@property (nonatomic, retain) NSMutableArray *forecasts;
@property (nonatomic, retain) ActivityManager *activityManager;
@property (nonatomic, retain) NSMutableDictionary *iconDictionary;
@property (nonatomic, retain) NSOperationQueue *queue;
@property (nonatomic, retain) Forecast *selectedForecast;
@property (nonatomic, retain) ReachabilityManager *reachability;

@end
