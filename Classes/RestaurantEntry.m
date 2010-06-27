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


@implementation RestaurantEntry

@synthesize location;
@synthesize filter;
@synthesize name;

#pragma mark -
#pragma mark Construction

-(id) initWithLocation:(NSString *) aLocation withName:(NSString *) aName andFilter:(NSString *) aFilter {
	
	if (self = [super init]) {
		
		self.location = aLocation;
		self.filter = aFilter;
		self.name = aName;
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
	
	return [NSString stringWithFormat:@"[item type:Restaurants] [location: @%@ + 20mi]", self.location];
}

-(NSString *) formatTitleWithEntry:(GDataEntryGoogleBase *) anEntry {
	
	return [[anEntry title] contentStringValue];
}

-(NSString *) formatSubTitleWithEntry:(GDataEntryGoogleBase *) anEntry {
	
	return @"";
}

-(NSString *) formatDetailsWithEntry:(GDataEntryGoogleBase *) anEntry {
	
	return @"";
}

#pragma mark -
#pragma mark Memory Management

-(void)dealloc {
    
	[location release];
	[filter release];
	[name release];
	[super dealloc];
}

@end

