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


#pragma mark -
#pragma mark Method Implementation 

-(NSComparisonResult)compareQuery:(GoogleQuery *) aQuery
{
    return [self.title caseInsensitiveCompare:aQuery.title];
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
	[super dealloc];
}

@end
