//
//  GoogleServices.h
//  Jaunt
//
//  Created by John Bowles on 3/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface GoogleServices : NSObject {

}

+(NSString *) placesQueryWithLocation:(NSString *) aLocation placeType:(NSString *) aPlaceType placeFilter:(NSString *) aPlaceFilter radius:(NSInteger) aRadius;
+(NSString *) placesDetailQueryWithReference:(NSString *) aReference;
+(NSString *) formatLatitude:(NSNumber *) aLatitude andLongitude:(NSNumber *) aLongitude;
+(NSString *) mapsURLWithAddress:(NSString *) anAddress andLocation:(CLLocation *) aLocation;
+(NSString *) orderByLocation:(CLLocation *) aLocation;
+(NSString *) calculateDistanceFromLatitude:(NSString *) aLatitude fromLongitude:(NSString *) aLongitude toLocation:(CLLocation *) aLocation;

@end
