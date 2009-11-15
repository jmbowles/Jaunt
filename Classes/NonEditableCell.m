//
//  NonEditableCell.m
//  Jaunt
//
//  Created by John Bowles on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NonEditableCell.h"


@implementation NonEditableCell

@synthesize leftLabel;

#pragma mark -
#pragma mark CellExtension Category Methods

-(void) setValueForCell:(NSString *) aCellValue {
}

-(NSString *) valueForCell {
	
	return nil;
}

-(void) setTitleForCell:(NSString *) aCellTitle {
	
	self.leftLabel.text = aCellTitle;
}

-(NSString *) titleForCell {
	
	return self.leftLabel.text;
}

-(void) setCellExtensionDelegate:(id) aDelegate {
}

#pragma mark -
#pragma mark Memory Management

- (void) dealloc {
	
	[leftLabel release];
	[super dealloc];
}

@end
