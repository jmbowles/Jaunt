//
//  CellManager.m
//  Jaunt
//
//  Created by John Bowles on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CellManager.h"


@implementation CellManager

@synthesize nibs;

#pragma mark -
#pragma mark Constructors

- (id) initWithNibs:(NSArray*) nibNames forOwner:(id) anOwner {
	
	self = [super init];
	
	if (self != nil) {
		
		self.nibs = [NSMutableArray arrayWithCapacity:nibNames.count];
		
		for (int i = 0; i < nibNames.count; i++) {
	
			NSString *nibName = [nibNames objectAtIndex:i];
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:anOwner options:nil];
			UITableViewCell *cell = [nib objectAtIndex: 0];
			
			[self.nibs insertObject:cell atIndex:i];
		}
	}
	return self;
}

#pragma mark -
#pragma mark Cell Manager Methods

-(UITableViewCell *) cellForSection:(NSUInteger) section {

	return [self.nibs objectAtIndex: section];
}

#pragma mark -
#pragma mark Memory Management

- (void) dealloc {
	
	[nibs release];
	[super dealloc];
}

@end
