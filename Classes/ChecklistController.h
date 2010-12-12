//
//  ChecklistController.h
//  Jaunt
//
//  Created by John Bowles on 10/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Trip;
@class ChecklistGroup;

@interface ChecklistController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {

	Trip *trip;

@private
	
	NSArray	*sortedGroups;
	ChecklistGroup *selectedGroup;
}

@property (nonatomic, retain) Trip *trip;
@property (nonatomic, retain) NSArray *sortedGroups;
@property (nonatomic, retain) ChecklistGroup *selectedGroup;

-(void) addItem;

@end
