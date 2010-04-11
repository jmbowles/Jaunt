//
//  DateUtils.m
//  Jaunt
//
//  Created by John Bowles on 4/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DateUtils.h"

@interface DateUtils (PrivateMethods)

+(NSString *) dayOfWeekName:(NSInteger) weekDay;

@end

@implementation DateUtils


+(NSString *) dayOfWeek:(NSDate *) aDate {
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:aDate];
	[gregorian release];
	
	return [DateUtils dayOfWeekName:[weekdayComponents weekday]];
}

+(NSString *) dayOfWeekName:(NSInteger) weekDay {
	
	NSString *dayOfWeekName = nil;
	
	switch (weekDay) {
		case 1:
			dayOfWeekName = @"Sunday";
			break;
		case 2:
			dayOfWeekName = @"Monday";
			break;
		case 3:
			dayOfWeekName = @"Tuesday";
			break;
		case 4:
			dayOfWeekName = @"Wednesday";
			break;
		case 5:
			dayOfWeekName = @"Thursday";
			break;
		case 6:
			dayOfWeekName = @"Friday";
			break;
		case 7:
			dayOfWeekName = @"Saturday";
			break;
		default:
			break;
	}
	return dayOfWeekName;
}

@end
