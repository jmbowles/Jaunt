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
@synthesize query;
@synthesize address;


#pragma mark -
#pragma mark Construction

-(id) initWithTitle:(NSString *) aTitle andQuery:(NSString *) aQuery {

	if (self = [super init]) {
		
		self.title = aTitle;
		self.query = aQuery;
	}
	return self;
}

-(id) initWithTitle:(NSString *) aTitle andAddress:(NSString *) anAddress {
	
	if (self = [super init]) {
		
		self.title = aTitle;
		self.address = anAddress;
	}
	return self;
}

#pragma mark -
#pragma mark Memory Management

- (void) dealloc {
	
	[title release];
	[query release];
	[address release];
	[super dealloc];
}

@end
