//
//  GoogleQuery.m
//  Jaunt
//
//  Created by John Bowles on 3/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GoogleQuery.h"


@implementation GoogleQuery

@synthesize title;
@synthesize subTitle;
@synthesize detailedDescription;
@synthesize address;
@synthesize href;
@synthesize mapsURL;
@synthesize iconHref;
@synthesize placeReference;
@synthesize phoneNumber;
@synthesize website;


#pragma mark -
#pragma mark Method Implementation 

-(NSComparisonResult)compareQuery:(GoogleQuery *) aQuery
{
    return [self.title caseInsensitiveCompare:aQuery.title];
}
	
+(NSString *) formatDateTimeRangeFromStartingDate:(NSDate *) startingDate andEndingDate:(NSDate *) endingDate {

	NSDateFormatter *aFormatter = [[NSDateFormatter alloc] init];
	[aFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *dateTimeRange = [NSString stringWithFormat:@"%@..%@", [aFormatter stringFromDate:startingDate], [aFormatter stringFromDate:endingDate]];
	
	[aFormatter release];
	
	return dateTimeRange;
}

#pragma mark -
#pragma mark Memory Management

- (void) dealloc {
	
	[title release];
	[subTitle release];
	[detailedDescription release];
	[address release];
	[href release];
	[mapsURL release];
    [iconHref release];
    [placeReference release];
    [phoneNumber release];
    [website release];
	[super dealloc];
}

@end
