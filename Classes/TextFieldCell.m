//
//  TextFieldCell.m
//  Jaunt
//
//  Created by John Bowles on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TextFieldCell.h"


@implementation TextFieldCell

@synthesize leftTitleLabel;
@synthesize textField;

-(void) textFieldDoneEditing {
	
	[self.textField resignFirstResponder];
}

- (void) dealloc {
	
	[leftTitleLabel release];
	[textField release];
	[super dealloc];
}

@end
