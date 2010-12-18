//
//  WeatherHourlyController.h
//  Jaunt
//
//  Created by John Bowles on 5/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReachabilityDelegate.h"

@class Forecast;
@class ActivityManager;
@class ReachabilityManager;

@interface WeatherHourlyController : UITableViewController <UITableViewDataSource, ReachabilityDelegate> {
	
	Forecast *forecast;
	
@private
	ActivityManager *activityManager;
	NSMutableDictionary *iconDictionary;
	NSOperationQueue *queue;
	ReachabilityManager *reachability;
}

@property (nonatomic, retain) Forecast *forecast;
@property (nonatomic, retain) NSMutableDictionary *iconDictionary;
@property (nonatomic, retain) ActivityManager *activityManager;
@property (nonatomic, retain) NSOperationQueue *queue;
@property (nonatomic, retain) ReachabilityManager *reachability;

@end
