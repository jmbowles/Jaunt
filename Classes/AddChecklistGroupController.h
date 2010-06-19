//
//  AddChecklistGroupController.h
//  Jaunt
//
//  Created by John Bowles on 6/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CameraControllerDelegate.h"

@class Trip;
@class CellManager;


@interface AddChecklistGroupController : UITableViewController <UITableViewDataSource, UITextFieldDelegate>  {

	Trip *trip;
	
@private
														  
	NSString *groupName;
	CellManager *cellManager;
}

@property (nonatomic, retain) Trip *trip;
@property (nonatomic, retain) NSString *groupName;
@property (nonatomic, retain) CellManager *cellManager;

-(void) loadCells;
-(void) save;

@end

