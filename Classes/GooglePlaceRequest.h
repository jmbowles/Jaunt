//
//  GooglePlaceRequest.h
//  Jaunt
//
//  Created by  on 12/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface GooglePlaceRequest : NSObject {

    NSString *placeLocation;
    NSString *title;
    NSString *placeType;
    NSString *placeFilter;
    NSInteger radius;
    CLLocation *currentLocation;

}

@property (nonatomic, retain) NSString *placeLocation;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *placeType;
@property (nonatomic, retain) NSString *placeFilter;
@property (nonatomic, assign) NSInteger radius;
@property (nonatomic, retain) CLLocation *currentLocation;

-(id) initWithPlace:(NSString *) aPlaceLocation title:(NSString *) aTitle placeType:(NSString *) aPlaceType 
        placeFilter:(NSString *) aPlaceFilter radius:(NSInteger) aRadius currentLocation:(CLLocation *) aCurrentLocation;
-(NSString *) getQuery;

@end
