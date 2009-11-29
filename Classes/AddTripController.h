//
//  AddTripController.h
//  Jaunt
//
//  Created by John Bowles on 10/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class CellManager;

@interface AddTripController : UITableViewController <UITableViewDataSource, UITextFieldDelegate> {
	
	NSString *tripName;
	CellManager *cellManager;
}

@property (nonatomic, retain) NSString *tripName;
@property (nonatomic, retain) CellManager *cellManager;

-(void) save;
-(void) loadCells;

@end
