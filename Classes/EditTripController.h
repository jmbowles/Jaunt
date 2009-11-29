//
//  EditTripController.h
//  Jaunt
//
//  Created by John Bowles on 11/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class Trip;
@class CellManager;


@interface EditTripController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {

	Trip *trip;
@private 
	NSArray *titles;
	NSString *tripName;
	CellManager *cellManager;
	BOOL isEditingTrip;
}

@property (nonatomic, retain) NSArray *titles;
@property (nonatomic, retain) Trip *trip;
@property (nonatomic, retain) NSString *tripName;
@property (nonatomic, retain) CellManager *cellManager;

-(void) save;
-(void) loadTitles;
-(void) loadCells;
-(NSUInteger) currentRowAtIndexPath: (NSIndexPath *) indexPath;

@end
