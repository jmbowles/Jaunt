//
//  RouteController.h
//  Jaunt
//
//  Created by John Bowles on 10/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ReachabilityDelegate.h"

@class Trip;
@class Destination;
@class ActivityManager;
@class ReachabilityManager;


@interface RouteController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, ReachabilityDelegate> {

	IBOutlet MKMapView *mapView;
	Trip *trip;
	
@private
	CLLocationManager *locationManager;
	ActivityManager *activityManager;
	CLLocation *currentLocation;
	ReachabilityManager *reachability;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) Trip *trip;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) ActivityManager *activityManager;
@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, retain) ReachabilityManager *reachability;

-(void) loadAnnotations:(CLLocation *)aCurrentLocation;
-(void) adjustMapRegion;
-(void) performRefresh;
-(NSString *) titleFromCurrentLocation:(CLLocation *) aCurrentLocation toDestination:(Destination *) aDestination;

@end
