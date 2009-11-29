//
//  DestinationController.h
//  Jaunt
//
//  Created by John Bowles on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class CellManager;
@class Trip;
@class Destination;


@interface DestinationController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {

	Trip *trip;
	Destination *destination;

@private 
	NSArray *titles;
	NSMutableArray *values;
	CellManager *cellManager;
}

@property (nonatomic, retain) NSArray *titles;
@property (nonatomic, retain) NSMutableArray *values;
@property (nonatomic, retain) Trip *trip;
@property (nonatomic, retain) Destination *destination;
@property (nonatomic, retain) CellManager *cellManager;

-(void) save;
-(void) loadTitles;
-(void) loadCells;
-(void) loadValues;

@end
