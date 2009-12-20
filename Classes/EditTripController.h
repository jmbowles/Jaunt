//
//  EditTripController.h
//  Jaunt
//
//  Created by John Bowles on 11/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CameraControllerDelegate.h"

@class Trip;
@class CellManager;
@class ActivityManager;
@class CameraController;


@interface EditTripController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CameraControllerDelegate> {

	Trip *trip;
@private 
	CameraController *cameraController;													  
	ActivityManager *activityManager;
	NSArray *titles;
	NSString *tripName;
	CellManager *cellManager;
	BOOL isEditingTrip;
}

@property (nonatomic, retain) CameraController *cameraController;
@property (nonatomic, retain) ActivityManager *activityManager;
@property (nonatomic, retain) NSArray *titles;
@property (nonatomic, retain) Trip *trip;
@property (nonatomic, retain) NSString *tripName;
@property (nonatomic, retain) CellManager *cellManager;

-(void) initializeDelegates;
-(void) save;
-(void) asyncSave;
-(void) finishedSaving;
-(void) loadTitles;
-(void) loadCells;
-(void) createHeader;
-(void) setTripImage:(id) sender;
-(NSUInteger) currentRowAtIndexPath: (NSIndexPath *) indexPath;

@end
