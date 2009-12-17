//
//  AddTripController.h
//  Jaunt
//
//  Created by John Bowles on 10/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CameraControllerDelegate.h"

@class Trip;
@class CellManager;
@class ActivityManager;
@class CameraController;


@interface AddTripController : UITableViewController <UITableViewDataSource, UITextFieldDelegate, CameraControllerDelegate> {
	
@private
	CameraController *cameraController;													  
	ActivityManager *activityManager;
	NSString *tripName;
	CellManager *cellManager;
}

@property (nonatomic, retain) CameraController *cameraController;
@property (nonatomic, retain) ActivityManager *activityManager;
@property (nonatomic, retain) NSString *tripName;
@property (nonatomic, retain) CellManager *cellManager;

-(void) initializeDelegates;
-(void) save;
-(void) asyncSave;
-(void) finishedSaving;
-(void) loadCells;
-(void) createHeader;
-(void) setTripImage:(id) sender;

@end
