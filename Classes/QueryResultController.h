//
//  QueryResultController.h
//  Jaunt
//
//  Created by John Bowles on 3/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class GoogleQuery;
@class ActivityManager;

@interface QueryResultController : UITableViewController {

	GoogleQuery *googleQuery;
	CLLocation *currentLocation;

@private
	NSMutableArray *results;
	ActivityManager *activityManager;
}

@property (nonatomic, retain) GoogleQuery *googleQuery;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) NSArray *results;
@property (nonatomic, retain) ActivityManager *activityManager;

@end