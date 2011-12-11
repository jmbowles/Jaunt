//
//  DestinationAnnotation.h
//  Jaunt
//
//  Created by John Bowles on 1/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class Destination;

@interface MapAnnotation : NSObject <MKAnnotation> {

	CLLocationCoordinate2D coordinate;	
	NSString *title;
	NSString *subtitle;
	Destination *destination;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, retain) Destination *destination;

-(id) initWithCoordinate: (CLLocationCoordinate2D) aCoordinate;

@end
