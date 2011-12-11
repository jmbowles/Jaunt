//
//  QueryResultController.h
//  Jaunt
//
//  Created by John Bowles on 3/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ReachabilityDelegate.h"
#import "RatingTableViewCell.h"
#import "GooglePlaceRequest.h"

@class GoogleEntry;
@class GoogleQuery;
@class ActivityManager;
@class ReachabilityManager;

@interface QueryResultController : UITableViewController <UITableViewDelegate, UIActionSheetDelegate, ReachabilityDelegate> {

	GoogleEntry *googleEntry;
    GooglePlaceRequest *placeRequest;
	CLLocation *currentLocation;
    RatingTableViewCell *ratingCell;
    UINib *ratingCellNib;

@private
	GoogleQuery *googleQuery;
	NSMutableArray *results;
	ActivityManager *activityManager;
	ReachabilityManager *reachability;
}

@property (nonatomic, retain) GoogleEntry *googleEntry;
@property (nonatomic, retain) GooglePlaceRequest *placeRequest;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) GoogleQuery *googleQuery;
@property (nonatomic, retain) NSArray *results;
@property (nonatomic, retain) ActivityManager *activityManager;
@property (nonatomic, retain) ReachabilityManager *reachability;
@property (nonatomic, retain) IBOutlet RatingTableViewCell *ratingCell;
@property (nonatomic, retain) UINib *ratingCellNib;

@end