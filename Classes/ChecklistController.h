//
//  ChecklistController.h
//  Jaunt
//
//  Created by John Bowles on 10/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChecklistController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {

	NSMutableArray *items;
}

@property (nonatomic, retain) NSMutableArray *items;

-(void) addItem;
-(void) loadItems; 

@end
