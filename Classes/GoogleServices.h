//
//  GoogleServices.h
//  Jaunt
//
//  Created by John Bowles on 3/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class GDataEntryGoogleBase;

@interface GoogleServices : NSObject {

}

+(void) executeQueryUsingDelegate:(id) aDelegate selector:(SEL) aSelector query:(NSString *) aQueryString;
+(NSString *) formatLatitude:(NSNumber *) aLatitude andLongitude:(NSNumber *) aLongitude;
+(NSString *) mapsURLWithAddress:(NSString *) anAddress andLocation:(CLLocation *) aLocation;
+(NSString *) concatenateWith:(NSString *) aConcatenator forEntry:(GDataEntryGoogleBase *) anEntry usingSearchName:(NSString *) aName;

@end
