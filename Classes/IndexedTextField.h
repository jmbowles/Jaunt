//
//  IndexedTextField.h
//  Jaunt
//
//  Created by John Bowles on 11/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IndexedTextField : UITextField {
	
	NSIndexPath *fieldIndexPath;
}

@property (nonatomic, retain) NSIndexPath *fieldIndexPath;

@end
