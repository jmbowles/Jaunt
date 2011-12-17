//
//  PlaceViewController.h
//  Jaunt
//
//  Created by  on 12/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingTableViewCell.h"
#import "PlaceTableViewCell.h"
#import "ReachabilityDelegate.h"

@class GoogleQuery;
@class ActivityManager;
@class ReachabilityManager;
@class ASIHTTPRequest;
@class GooglePlaceRequest;

@interface PlaceViewController : UITableViewController <ReachabilityDelegate> {

    RatingTableViewCell *ratingCell;
    PlaceTableViewCell *placeCell;
    GoogleQuery *googleQuery;
    
@private
	
    UINib *ratingCellNib;
    UINib *placeCellNib;
	NSMutableArray *results;
	ActivityManager *activityManager;
	ReachabilityManager *reachability;
    ASIHTTPRequest *httpRequest;
}

@property (nonatomic, retain) GoogleQuery *googleQuery;
@property (nonatomic, retain) NSArray *results;
@property (nonatomic, retain) ActivityManager *activityManager;
@property (nonatomic, retain) ReachabilityManager *reachability;
@property (nonatomic, retain) IBOutlet RatingTableViewCell *ratingCell;
@property (nonatomic, retain) IBOutlet PlaceTableViewCell *placeCell;
@property (nonatomic, retain) UINib *ratingCellNib;
@property (nonatomic, retain) UINib *placeCellNib;
@property (nonatomic, retain) ASIHTTPRequest *httpRequest;

@end