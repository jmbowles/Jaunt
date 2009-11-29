//
//  Cell.h
//  Jaunt
//
//  Created by John Bowles on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITableViewCell (CellExtension)

-(void) setValueForCell:(NSString *) aCellValue;
-(NSString *) valueForCell;
	
-(void) setTitleForCell:(NSString *) aCellTitle;
-(NSString *) titleForCell;
	
-(void) setCellExtensionDelegate:(id) aDelegate;
-(IndexedTextField*) indexedTextField;

@end
