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
@synthesize nibNames;
@synthesize reusableIdentifiers;
@synthesize owner;

#pragma mark -
#pragma mark Constructors

-(id) init {

	return [self initWithNibs:nil withIdentifiers:nil forOwner:nil];
}

- (id) initWithNibs:(NSArray*) names withIdentifiers:(NSArray *) identifiers forOwner:(id) anOwner {
	
	if (self = [super init]) {
		
		self.nibs = [NSMutableArray arrayWithCapacity:names.count];
		self.nibNames = names;
		self.reusableIdentifiers = identifiers;
		self.owner = anOwner;
	}
	return self;
}

#pragma mark -
#pragma mark Cell Manager Methods

-(UITableViewCell *) cellForSection:(NSUInteger) section {

	if (self.nibs.count == 0) {
		
		for (int i=0; i < self.nibNames.count; i++) {
			
			NSString *aNibName = [self.nibNames objectAtIndex: i];
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:aNibName owner:self.owner options:nil];
			UITableViewCell *cell = [nib objectAtIndex: 0];
			
			[self.nibs insertObject:cell atIndex:i];
		}
	}
	return [self.nibs objectAtIndex: section];
}

-(NSString *) reusableIdentifierForSection:(NSUInteger) section {
	
	return [self.reusableIdentifiers objectAtIndex:section];
}

#pragma mark -
#pragma mark Memory Management

- (void) dealloc {
	
	[nibs release];
	[nibNames release];
	[reusableIdentifiers release];
	[owner release];
	[super dealloc];
}

@end
