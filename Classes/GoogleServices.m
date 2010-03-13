//
//  GoogleServices.m
//  Jaunt
//
//  Created by John Bowles on 3/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GoogleServices.h"
#import "GDataGoogleBase.h"


@interface GoogleServices (PrivateMethods) 

+(GDataServiceGoogleBase *) googleBaseService;

@end


@implementation GoogleServices

#pragma mark -
#pragma mark Google Base

+(void) executeQueryUsingDelegate:(id) aDelegate selector:(SEL) aSelector query:(NSString *) aQueryString {
	
	NSURL *aURL = [NSURL URLWithString:kGDataGoogleBaseSnippetsFeed];
	GDataQueryGoogleBase *aQuery = [GDataQueryGoogleBase googleBaseQueryWithFeedURL:aURL];
	[aQuery setGoogleBaseQuery:aQueryString];
	GDataServiceGoogleBase *service = [GoogleServices googleBaseService];
    [service fetchFeedWithQuery:aQuery delegate:aDelegate didFinishSelector:aSelector];
}

+(GDataServiceGoogleBase *) googleBaseService {
	
	static GDataServiceGoogleBase* aService = nil;
	
	if (! aService) {
		
		aService = [[GDataServiceGoogleBase alloc] init];
		[aService setShouldCacheDatedData:YES];
		[aService setUserCredentialsWithUsername:nil password:nil];
	}
	return aService;
}

+(NSString *) formatLatitude:(NSNumber *) aLatitude andLongitude:(NSNumber *) aLongitude {
	
	NSNumberFormatter *aNumberFormatter = [[NSNumberFormatter alloc] init];
	[aNumberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[aNumberFormatter setMaximumFractionDigits:3];
	[aNumberFormatter setMaximumIntegerDigits:3];
	[aNumberFormatter setPositivePrefix:@"+"];
	
	NSString *lat = [aNumberFormatter stringFromNumber:aLatitude]; 
	
	[aNumberFormatter setMinimumIntegerDigits:3];
	NSString *lng = [aNumberFormatter stringFromNumber:aLongitude]; 
	NSString *latlong = [NSString stringWithFormat:@"%@%@", lat, lng];
	
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

@end
