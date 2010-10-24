//
//  LodgingEntry.m
//  Jaunt
//
//  Created by John Bowles on 3/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LodgingEntry.h"
#import "GoogleServices.h"
#import "GDataGoogleBase.h"

@implementation LodgingEntry

@synthesize location;
@synthesize filter;
@synthesize name;
@synthesize itemType;
@synthesize currentLocation;


#pragma mark -
#pragma mark Construction

-(id) initWithLocation:(NSString *) aLocation withName:(NSString *) aName itemType:(NSString *) anItemType 
			 andFilter:(NSString *) aFilter andCurrentLocation:(CLLocation *) aCurrentLocation {
	
	if (self = [super init]) {
		
		self.location = aLocation;
		self.filter = aFilter;
		self.name = aName;
		self.itemType = anItemType;
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
	
	return self.itemType;
}

-(NSString *) getQuery {
	
	return [NSString stringWithFormat:@"[item type: %@] [location: @%@ + 10mi]", self.itemType, self.location];
}

-(NSString *) getOrderBy {
	
	return [GoogleServices orderByLocation:self.currentLocation];
}

-(NSString *) formatTitleWithEntry:(GDataEntryGoogleBase *) anEntry {

	return [[anEntry title] contentStringValue];
}

-(NSString *) formatSubTitleWithEntry:(GDataEntryGoogleBase *) anEntry andAddress:(NSString *) anAddress {

	NSString *price = [[anEntry attributeWithName:@"price" type:kGDataGoogleBaseAttributeTypeText] textValue];
	NSString *miles = [GoogleServices calculateDistanceWithEntry:anEntry fromLocation:self.currentLocation];
	
	if (price != nil && [price isEqualToString:@""] == NO) {
		
		return [NSString stringWithFormat:@"$%@, %@", price, miles];
		
	} else {
		
		return miles;
	}
}

-(NSString *) formatDetailsWithEntry:(GDataEntryGoogleBase *) anEntry {

	return [[anEntry content] stringValue];
}

#pragma mark -
#pragma mark Memory Management

-(void)dealloc {
    
	[location release];
	[filter release];
	[name release];
	[itemType release];
	[currentLocation release];
	[super dealloc];
}

@end
