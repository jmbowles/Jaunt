//
//  LodgingEntry.m
//  Jaunt
//
//  Created by John Bowles on 3/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LodgingEntry.h"
#import "GDataGoogleBase.h"

@implementation LodgingEntry

@synthesize location;
@synthesize filter;
@synthesize name;
@synthesize itemType;


#pragma mark -
#pragma mark Construction

-(id) initWithLocation:(NSString *) aLocation withName:(NSString *) aName itemType:(NSString *) anItemType andFilter:(NSString *) aFilter {
	
	if (self = [super init]) {
		
		self.location = aLocation;
		self.filter = aFilter;
		self.name = aName;
		self.itemType = anItemType;
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
	
	return [NSString stringWithFormat:@"[item type: %@] [location: @%@ + 20mi]", self.itemType, self.location];
}

-(NSString *) formatTitleWithEntry:(GDataEntryGoogleBase *) anEntry {

	return [[anEntry title] contentStringValue];
}

-(NSString *) formatSubTitleWithEntry:(GDataEntryGoogleBase *) anEntry {

	NSString *price = [[anEntry attributeWithName:@"price" type:kGDataGoogleBaseAttributeTypeText] textValue];
	
	if (price != nil && [price isEqualToString:@""] == NO) {
		
		return [NSString stringWithFormat:@"$%@", price];
		
	} else {
		
		return @"";
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
	[super dealloc];
}

@end
