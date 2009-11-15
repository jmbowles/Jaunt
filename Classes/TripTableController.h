//
//  TripTableController.h
//  Jaunt
//
//  Created by John Bowles on 10/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface TripTableController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {

	NSMutableArray *tripsCollection;
	UINavigationController *navigationController;
}

@property (nonatomic, retain) NSMutableArray *tripsCollection;
@property (nonatomic, retain) UINavigationController *navigationController;

- (void) addTrip;
- (void) loadTrips;

@end
