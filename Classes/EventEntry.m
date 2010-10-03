//
//  EventEntry.m
//  Jaunt
//
//  Created by John Bowles on 3/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EventEntry.h"
#import "GDataGoogleBase.h"
#import "GoogleServices.h"
#import "DateUtils.h"
#import "GoogleQuery.h"


@implementation EventEntry

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
	
	return @"Events and Activities";
}

-(NSString *) getQuery {
	
	NSDate *startingDate = [NSDate date];
	NSDate *endingDate = [DateUtils addDays:7 toDate:startingDate];
	NSString *dateRange = [GoogleQuery formatDateTimeRangeFromStartingDate:startingDate andEndingDate:endingDate];
	
	return [NSString stringWithFormat:@"[item type:Events and Activities] [event date range:%@] [location: @%@ + 10mi] %@", dateRange, self.location, self.filter];
}

-(NSString *) formatTitleWithEntry:(GDataEntryGoogleBase *) anEntry {
	
	return [[anEntry title] contentStringValue];
}

-(NSString *) formatSubTitleWithEntry:(GDataEntryGoogleBase *) anEntry {
	
	NSString *price = [[anEntry attributeWithName:@"price" type:kGDataGoogleBaseAttributeTypeText] textValue];
	
	if (price != nil && [price isEqualToString:@""] == NO) {
		
		return [NSString stringWithFormat:@"$%@", price];
		
	} else {
		
		NSString *where = [[anEntry attributeWithName:@"venue name" type:kGDataGoogleBaseAttributeTypeText] textValue];
		
		if (where != nil) {
		
			return where;
			
		} else {
			
			return @"";
		}
	}
}

-(NSString *) formatDetailsWithEntry:(GDataEntryGoogleBase *) anEntry {
	
	NSString *when = @"";
	NSString *where = [anEntry location];
	NSString *venue = [[anEntry attributeWithName:@"venue name" type:kGDataGoogleBaseAttributeTypeText] textValue];
	NSString *summary = [[anEntry content] contentStringValue] == nil ? @"No details found" : [[anEntry content] contentStringValue];
	NSString *eventDate = [[anEntry attributeWithName:@"event date range" type:kGDataGoogleBaseAttributeTypeDateTime] textValue];
	
	if (eventDate != nil) {
		
		eventDate = [eventDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
		
		NSDateFormatter *aDateFormatter = [[NSDateFormatter alloc] init];
		[aDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		NSDate *aDate = [aDateFormatter dateFromString:eventDate];
		
		[aDateFormatter setDateStyle:NSDateFormatterFullStyle];
		[aDateFormatter setTimeStyle:NSDateFormatterShortStyle];
		when = [aDateFormatter stringFromDate:aDate];
		[aDateFormatter release];
	} 
	
	return [NSString stringWithFormat:@"Summary:\n\n%@\n\nVenue: %@\n\nWhen: %@\n\nWhere: %@", summary, venue, when, where];
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
