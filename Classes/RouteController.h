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

@interface RouteController : UIViewController <MKMapViewDelegate> {

	IBOutlet MKMapView *mapView;
	Trip *trip;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) Trip *trip;

-(void) loadAnnotations;
-(void) adjustMapRegion;

@end
