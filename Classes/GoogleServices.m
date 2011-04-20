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

+(void) executeQueryUsingDelegate:(id) aDelegate selector:(SEL) aSelector baseQuery:(NSString *) baseQuery orderBy:(NSString *) orderBy; {
	
	NSURL *aURL = [NSURL URLWithString:kGDataGoogleBaseSnippetsFeed];
	GDataQueryGoogleBase *aQuery = [GDataQueryGoogleBase googleBaseQueryWithFeedURL:aURL];
	[aQuery setGoogleBaseQuery:baseQuery];
	[aQuery setOrderBy:orderBy];
	[aQuery setMaxResults:30];
	[aQuery addCustomParameterWithName:@"content" value:@"geocodes"];
	
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

+(NSString *) concatenateWith:(NSString *) aConcatenator forEntry:(GDataEntryGoogleBase *) anEntry usingSearchName:(NSString *) aName {

	NSString *attributes = @"";
	
	for (GDataGoogleBaseAttribute *attrib in [anEntry attributesWithName:aName type:kGDataGoogleBaseAttributeTypeText]) {
		
		attributes = [attributes stringByAppendingFormat:@"%@%@", [attrib textValue], aConcatenator];
	}
	
	if ([attributes isEqualToString:@""] == NO) {
		
		NSRange aRange = NSMakeRange([attributes length] - 1, 1);
		attributes = [attributes stringByReplacingCharactersInRange:aRange withString:@""];
	}
	return [attributes capitalizedString];
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

+(NSString *) calculateDistanceWithEntry:(GDataEntryGoogleBase *) anEntry fromLocation:(CLLocation *) aLocation {
	
	NSString *distance = @"";
	GDataGoogleBaseAttribute *attr = [anEntry attributeWithName:@"location" type:kGDataGoogleBaseAttributeTypeLocation];
	
	if (attr != nil) {
		
		NSString *aStringLat = [[[attr subAttributes] objectAtIndex:0] textValue];
		NSString *aStringLong = [[[attr subAttributes] objectAtIndex:1] textValue];
		
		if (aStringLat != nil && aStringLong != nil) {
			
			double latitude = [aStringLat doubleValue];
			double longitude = [aStringLong doubleValue];
			
			CLLocation *anEntryLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
			CLLocationDistance miles = ([aLocation distanceFromLocation:anEntryLocation] * 3.28f) / 5280;
			[anEntryLocation release];
			
			NSNumberFormatter *aNumberFormatter = [[NSNumberFormatter alloc] init];
			[aNumberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
			[aNumberFormatter setMaximumFractionDigits:1];
			NSString *mileage = [aNumberFormatter stringFromNumber:[NSNumber numberWithDouble:miles]];
			[aNumberFormatter release];
			
			distance = [NSString stringWithFormat:@"%@ miles", mileage];
		}
	} 
	
	return distance;
}

@end
