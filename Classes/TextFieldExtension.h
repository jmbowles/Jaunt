//
//  TextFieldExtension.h
//  Jaunt
//
//  Created by John Bowles on 11/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITextField (TextFieldExtension) 

- (void) setIndexPathForField:(NSIndexPath*) anIndexPath;
- (NSIndexPath*) indexPathForField;

@end
