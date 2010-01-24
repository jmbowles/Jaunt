//
//  RouteController.h
//  Jaunt
//
//  Created by John Bowles on 10/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class Trip;
@class Destination;


@interface RouteController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {

	IBOutlet MKMapView *mapView;
	Trip *trip;
	CLLocationManager *locationManager;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) Trip *trip;
@property (nonatomic, retain) CLLocationManager *locationManager;

-(void) loadAnnotations:(CLLocation *)aCurrentLocation;
-(void) adjustMapRegion;
-(void) performRefresh;
-(NSString *) titleFromCurrentLocation:(CLLocation *) aCurrentLocation toDestination:(Destination *) aDestination;

@end
