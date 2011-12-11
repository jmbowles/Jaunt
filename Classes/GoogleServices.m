//
//  GoogleServices.m
//  Jaunt
//
//  Created by John Bowles on 3/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GoogleServices.h"
#import "Logger.h"
#import "GData.h"



@interface GoogleServices (PrivateMethods) 

+(GDataServiceGoogle *) googleBaseService;

@end


@implementation GoogleServices

#pragma mark -
#pragma mark Google Base

+(void) executeQueryUsingDelegate:(id) aDelegate selector:(SEL) aSelector baseQuery:(NSString *) baseQuery orderBy:(NSString *) orderBy; {
	
	NSURL *aURL = [NSURL URLWithString:@"http://www.google.com/base/feeds/snippets"];
	GDataQuery *aQuery = [GDataQuery queryWithFeedURL:aURL];
	[aQuery setFullTextQueryString:baseQuery];
	[aQuery setOrderBy:orderBy];
	[aQuery setMaxResults:30];
	[aQuery addCustomParameterWithName:@"content" value:@"geocodes"];
	
	GDataServiceGoogle *service = [GoogleServices googleBaseService];
    [service fetchFeedWithQuery:aQuery delegate:aDelegate didFinishSelector:aSelector];
}

+(NSString *) placesQueryWithLocation:(NSString *)aLocation placeType:(NSString *)aPlaceType radius:(NSInteger)aRadius {
    
    //https://maps.googleapis.com/maps/api/place/search/xml?location=39.71755,-82.95285&radius=500&types=restaurant&sensor=false&key=AIzaSyAAq2wxK50A-3FrhWRtNaB_gvVYUXAZYzM
    
    NSString *aPlacesQuery = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/xml?location=%@&radius=%@&types=%@&sensor=true&key=AIzaSyAAq2wxK50A-3FrhWRtNaB_gvVYUXAZYzM", aLocation, [NSString stringWithFormat:@"%d", aRadius], aPlaceType];
    
  [Logger logMessage:aPlacesQuery withTitle:@"Query"];
    return aPlacesQuery;
}

+(GDataServiceGoogle *) googleBaseService {
	
	return [[[GDataServiceGoogle alloc] init] autorelease];
}

+(NSString *) formatLatitude:(NSNumber *) aLatitude andLongitude:(NSNumber *) aLongitude {
	
	NSNumberFormatter *aNumberFormatter = [[NSNumberFormatter alloc] init];
	[aNumberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[aNumberFormatter setMaximumFractionDigits:5];
	[aNumberFormatter setMaximumIntegerDigits:3];
	
	NSString *lat = [aNumberFormatter stringFromNumber:aLatitude]; 
	
	[aNumberFormatter setMinimumIntegerDigits:3];
	NSString *lng = [aNumberFormatter stringFromNumber:aLongitude]; 
	NSString *latlong = [NSString stringWithFormat:@"%@,%@", lat, lng];
	
	[aNumberFormatter release];
	
	return latlong;
}

+(NSString *) mapsURLWithAddress:(NSString *) anAddress andLocation:(CLLocation *) aLocation {
	
	CLLocationCoordinate2D start = aLocation.coordinate;
	NSString *encoded = [GDataUtilities stringByURLEncodingForURI:anAddress];
	NSString *googleMapsURLString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%1.6f,%1.6f&daddr=%@",
									 start.latitude, start.longitude, encoded];
	
	return googleMapsURLString;
	
}

+(NSString *) orderByLocation:(CLLocation *) aLocation {
	
	NSNumberFormatter *aNumberFormatter = [[NSNumberFormatter alloc] init];
	[aNumberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[aNumberFormatter setMaximumFractionDigits:4];
	[aNumberFormatter setMaximumIntegerDigits:3];
	[aNumberFormatter setPositivePrefix:@"+"];
	
	NSNumber *latNumber = [[NSNumber alloc] initWithDouble:[aLocation coordinate].latitude];
	NSString *lat = [aNumberFormatter stringFromNumber:latNumber]; 
	[latNumber release];
	
	[aNumberFormatter setMinimumIntegerDigits:3];
    
	NSNumber *lngNumber = [[NSNumber alloc] initWithDouble:[aLocation coordinate].longitude];
	NSString *lng = [aNumberFormatter stringFromNumber:lngNumber]; 
	[lngNumber release];
	[aNumberFormatter release];
	
	NSString *latlong = [NSString stringWithFormat:@"%@%@", lat, lng];
	NSString *orderBy = [NSString stringWithFormat:@"[x = location(location): neg(min(dist(x, @%@)))]", latlong];
	
	return orderBy;
}

+(NSString *) calculateDistanceWithEntry:(GDataEntryBase *) anEntry fromLocation:(CLLocation *) aLocation {
	
	NSString *distance = @"";
    return distance;
}

+(NSString *) calculateDistanceFromLatitude:(NSString *) aLatitude fromLongitude:(NSString *) aLongitude toLocation:(CLLocation *) aLocation {
    
    NSString *distance = @"";
     
    if (aLatitude != nil && aLongitude != nil) {
        
        double latitude = [aLatitude doubleValue];
        double longitude = [aLongitude doubleValue];
        
        CLLocation *anEntryLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        CLLocationDistance miles = ([aLocation distanceFromLocation:anEntryLocation] * 3.28f) / 5280;
        [anEntryLocation release];
        
        NSNumberFormatter *aNumberFormatter = [[NSNumberFormatter alloc] init];
        [aNumberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [aNumberFormatter setMaximumFractionDigits:1];
        NSString *mileage = [aNumberFormatter stringFromNumber:[NSNumber numberWithDouble:miles]];
        [aNumberFormatter release];
        
        distance = [NSString stringWithFormat:@"%@ mi", mileage];
    }
     
	return distance;
}

@end
