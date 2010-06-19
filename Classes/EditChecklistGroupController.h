//
//  EditChecklistGroupController.h
//  Jaunt
//
//  Created by John Bowles on 6/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class Trip;
@class CellManager;
@class ChecklistGroup;

@interface EditChecklistGroupController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>  {
	
	Trip *trip;
	ChecklistGroup *group;
	
@private 
	
	NSArray *titles;
	NSString *groupName;
	CellManager *cellManager;
	BOOL isEditing;
}

@property (nonatomic, retain) NSArray *titles;
@property (nonatomic, retain) Trip *trip;
@property (nonatomic, retain) ChecklistGroup *group;
@property (nonatomic, retain) NSString *groupName;
@property (nonatomic, retain) CellManager *cellManager;

-(void) save;
-(void) loadTitles;
-(void) loadCells;
-(NSUInteger) currentRowAtIndexPath: (NSIndexPath *) indexPath;

@end
