//
//  TextFieldExtension.m
//  Jaunt
//
//  Created by John Bowles on 11/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TextFieldExtension.h"


@implementation UITextField (TextFieldExtension)

- (void) setIndexPathForField:(NSIndexPath*) anIndexPath {

}

- (NSIndexPath*) indexPathForField {
	
	return [NSIndexPath indexPathForRow:0 inSection:0];
}

@end