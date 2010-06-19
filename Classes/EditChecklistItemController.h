//
//  EditChecklistItemController.h
//  Jaunt
//
//  Created by John Bowles on 6/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class CellManager;
@class ChecklistGroup;
@class ChecklistItem;
@class ActivityManager;


@interface EditChecklistItemController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate, 
																UISearchDisplayDelegate, NSFetchedResultsControllerDelegate> {
	
	ChecklistItem *checklistItem;
	
@private 
														
    NSArray *titles;
	NSMutableArray *values;
	CellManager *cellManager;
	UISearchDisplayController *searchDisplayController;
	NSMutableArray *items;		
	NSFetchedResultsController *fetchedResultsController;
	NSOperationQueue *queue;
}

@property (nonatomic, retain) NSArray *titles;
@property (nonatomic, retain) NSMutableArray *values;
@property (nonatomic, retain) ChecklistItem *checklistItem;
@property (nonatomic, retain) CellManager *cellManager;
@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSOperationQueue *queue;


-(void) save;
-(void) loadTitles;
-(void) loadCells;
-(void) loadValues;
-(void) configureSearchDisplay;
-(void) asyncSearch:(id) anArray;
-(void) finishedSearching:(NSArray *) results;
-(void) addValueToChecklist:(NSString *) aChecklistValue;


@end
