//
//  RestaurantEntry.m
//  Jaunt
//
//  Created by John Bowles on 3/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RestaurantEntry.h"
#import "GDataGoogleBase.h"
#import "GoogleServices.h"
#import "Logger.h"


@implementation RestaurantEntry

@synthesize location;
@synthesize filter;
@synthesize name;
@synthesize currentLocation;


#pragma mark -
#pragma mark Construction

-(id) initWithLocation:(NSString *) aLocation withName:(NSString *) aName 
			 andFilter:(NSString *) aFilter andCurrentLocation:(CLLocation *) aCurrentLocation {
	
	if (self = [super init]) {
		
		self.location = aLocation;
		self.filter = aFilter;
		self.name = aName;
		self.currentLocation = aCurrentLocation;
	}
	return self;
}

#pragma mark -
#pragma mark GoogleEntry Protocol

-(NSString *) getTitle {
	
	return self.name;
}

-(NSString *) getItemType {
	
	return @"Restaurants";
}

-(NSString *) getQuery {
	
	NSString *baseSnippet = [NSString stringWithFormat:@"[item type:Restaurants] [location: @%@ + 3mi]", self.location];
	return baseSnippet;
}

-(NSString *) getOrderBy {
	
	return [GoogleServices orderByLocation:self.currentLocation];
}

-(CLLocation *) getCurrentPosition {
	
	return self.currentLocation;
}

-(NSString *) formatTitleWithEntry:(GDataEntryGoogleBase *) anEntry {
	
	return [[anEntry title] contentStringValue];
}

-(NSString *) formatSubTitleWithEntry:(GDataEntryGoogleBase *) anEntry andAddress:(NSString *) anAddress {
	
	return [GoogleServices calculateDistanceWithEntry:anEntry fromLocation:self.currentLocation];
}

-(NSString *) formatDetailsWithEntry:(GDataEntryGoogleBase *) anEntry {
	
	NSString *content = @"";
	
	if ([anEntry content] != nil && [[anEntry content] stringValue] != nil) {
		
		content = [[anEntry content] stringValue];
	}
	return content;
}

#pragma mark -
#pragma mark Memory Management

-(void)dealloc {
    
	[location release];
	[filter release];
	[name release];
	[currentLocation release];
	[super dealloc];
}

@end

