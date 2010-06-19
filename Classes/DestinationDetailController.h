//
//  DestinationDetailController.h
//  Jaunt
//
//  Created by John Bowles on 3/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class Destination;


@interface DestinationDetailController : UITableViewController {

	Destination *destination;
	CLLocation *currentLocation;
	
@private
	NSArray *actions;
	NSArray *icons;
}

@property (nonatomic, retain) Destination *destination;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) NSArray *actions;
@property (nonatomic, retain) NSArray *icons;

@end
