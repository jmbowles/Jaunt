//
//  AddTripController.h
//  Jaunt
//
//  Created by John Bowles on 10/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#define kNumberOfRows	1
#define kLabelTag		4096

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AddTripController : UITableViewController <UITableViewDataSource, UITextFieldDelegate> {
	
	NSMutableArray *tripsCollection;
	UITextField *tripNameTextField;
	
	NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSMutableArray *tripsCollection;
@property (nonatomic, retain) UITextField *tripNameTextField;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void) save;

@end
