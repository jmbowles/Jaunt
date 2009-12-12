//
//  AddTripController.h
//  Jaunt
//
//  Created by John Bowles on 10/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class Trip;
@class CellManager;

@interface AddTripController : UITableViewController <UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	
	Trip *trip;
	
@private
	NSOperationQueue *queue;
	UIActivityIndicatorView *activityIndicator;
	NSString *tripName;
	UIButton *photoButton;
	CellManager *cellManager;
}

@property (nonatomic, retain) NSOperationQueue *queue;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) Trip *trip;
@property (nonatomic, retain) NSString *tripName;
@property (nonatomic, retain) CellManager *cellManager;
@property (nonatomic, retain) UIButton *photoButton;

-(void) showActivity;
-(void) hideActivity;
-(void) save;
-(void) asyncSave;
-(void) finishedSaving;
-(void) loadCells;
-(void) createHeader;
-(void) setTripImage:(id) sender;

@end
