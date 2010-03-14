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
#import "Logger.h"

@implementation EventEntry

@synthesize location;

#pragma mark -
#pragma mark Construction

-(id) initWithLocation:(NSString *) aLocation {
	
	if (self = [super init]) {
		
		self.location = aLocation;
	}
	return self;
}

#pragma mark -
#pragma mark GoogleEntry Protocol

-(NSString *) getTitle {
	
	return @"Events and Activities";
}

-(NSString *) getItemType {
	
	return @"Events and Activities";
}

-(NSString *) getQuery {
	
	return [NSString stringWithFormat:@"[item type:Events and Activities] [location: @%@ + 10mi]", self.location];
}

-(NSString *) formatTitleWithEntry:(GDataEntryGoogleBase *) anEntry {
	
	return [[anEntry title] contentStringValue];
}

-(NSString *) formatSubTitleWithEntry:(GDataEntryGoogleBase *) anEntry {
	
	NSString *genre = [GoogleServices concatenateWith:@"," forEntry:anEntry usingSearchName:@"genre"];
	NSString *event = [[anEntry attributeWithName:@"event type" type:kGDataGoogleBaseAttributeTypeText] textValue];
	NSString *formatted = [NSString stringWithFormat:@"%@: %@", event, genre];
	
	return formatted;
}

-(NSString *) formatDetailsWithEntry:(GDataEntryGoogleBase *) anEntry {
	
	NSString *eventDate = [[anEntry attributeWithName:@"event date range" type:kGDataGoogleBaseAttributeTypeDateTime] textValue];
	eventDate = [eventDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
	
	NSDateFormatter *aDateFormatter = [[NSDateFormatter alloc] init];
	[aDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSDate *aDate = [aDateFormatter dateFromString:eventDate];
	
	[aDateFormatter setDateStyle:NSDateFormatterFullStyle];
	[aDateFormatter setTimeStyle:NSDateFormatterShortStyle];
	NSString *when = [aDateFormatter stringFromDate:aDate];
	[aDateFormatter release];
	
	NSString *where = [anEntry location];
	NSString *venue = [[anEntry attributeWithName:@"venue name" type:kGDataGoogleBaseAttributeTypeText] textValue];

	return [NSString stringWithFormat:@"Venue: %@ \nWhen: %@ \nWhere: %@", venue, when, where];
}

#pragma mark -
#pragma mark Memory Management

-(void)dealloc {
    
	[location release];
	[super dealloc];
}

@end
