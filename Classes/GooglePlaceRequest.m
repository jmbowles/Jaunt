//
//  GooglePlaceRequest.m
//  Jaunt
//
//  Created by  on 12/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GooglePlaceRequest.h"
#import "GoogleServices.h"

@implementation GooglePlaceRequest

@synthesize placeLocation, title, placeType, placeFilter, defaultImageName, radius, currentLocation;

#pragma mark -
#pragma mark Construction

-(id) initWithPlace:(NSString *) aPlaceLocation title:(NSString *) aTitle placeType:(NSString *) aPlaceType 
        placeFilter:(NSString *) aPlaceFilter defaultImage:(NSString *) defaultImage radius:(NSInteger) aRadius currentLocation:(CLLocation *) aCurrentLocation {
	
	if (self = [super init]) {
		
		self.placeLocation = aPlaceLocation;
		self.title = aTitle;
		self.placeType = aPlaceType;
        self.placeFilter = aPlaceFilter;
        self.defaultImageName = defaultImage;
        self.radius = aRadius;
		self.currentLocation = aCurrentLocation;
	}
	return self;
}

#pragma mark -
#pragma mark Method Implementations

-(NSString *) getQuery {	
    
	return [GoogleServices placesQueryWithLocation:self.placeLocation placeType:self.placeType placeFilter:self.placeFilter radius:self.radius];
    
}

#pragma mark -
#pragma mark Memory Management

-(void)dealloc {
    
	[placeLocation release];
	[title release];
	[placeType release];
    [placeFilter release];
    [defaultImageName release];
	[currentLocation release];
	[super dealloc];
}

@end
