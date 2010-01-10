//
//  TripTableController.h
//  Jaunt
//
//  Created by John Bowles on 10/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Trip;

@interface TripTableController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {

	NSMutableArray *tripsCollection;
	UINavigationController *navigationController;
@private
	Trip *selectedTrip;
}

@property (nonatomic, retain) NSMutableArray *tripsCollection;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) Trip *selectedTrip;

- (void) addTrip;
- (void) loadTrips;

@end
