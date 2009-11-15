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

	NSArray *list;
	NSMutableArray *tripsCollection;
	Trip *trip;
	NSManagedObjectContext *managedObjectContext;
@private 
	NSString *tripName;
	CellManager *cellManager;
}

@property (nonatomic, retain) NSArray *list;
@property (nonatomic, retain) NSMutableArray *tripsCollection;
@property (nonatomic, retain) Trip *trip;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSString *tripName;
@property (nonatomic, retain) CellManager *cellManager;

- (void) save;
- (void) loadCells;

@end
