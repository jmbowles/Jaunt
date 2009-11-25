//
//  TextFieldCell.m
//  Jaunt
//
//  Created by John Bowles on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TextFieldCell.h"
#import "TextFieldExtension.h"

@implementation TextFieldCell


@synthesize leftLabel;
@synthesize textField;


#pragma mark -
#pragma mark Methods

-(void) textFieldDoneEditing {
	
	[self.textField resignFirstResponder];
}

#pragma mark -
#pragma mark CellExtension Category Methods

-(void) setValueForCell:(NSString *) aCellValue {
	
	[self.textField setText: aCellValue];
}

-(NSString *) valueForCell {
	
	return [self.textField text];
}

-(void) setTitleForCell:(NSString *) aCellTitle {
	
	self.leftLabel.text = aCellTitle;
}

-(NSString *) titleForCell {
	
	return self.leftLabel.text;
}

-(void) setCellExtensionDelegate:(id) aDelegate {
		
	[self.textField setDelegate: aDelegate];
}

-(IndexedTextField*) indexedTextField {
		
	return [self textField];
}

#pragma mark -
#pragma mark Memory Management

- (void) dealloc {
	
	[leftLabel release];
	[textField release];
	[super dealloc];
}

@end
