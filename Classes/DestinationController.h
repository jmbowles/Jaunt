//
//  DestinationController.h
//  Jaunt
//
//  Created by John Bowles on 11/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class CellManager;
@class Trip;
@class Destination;
@class ActivityManager;


@interface DestinationController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchBarDelegate, 
															UISearchDisplayDelegate, NSFetchedResultsControllerDelegate, UIActionSheetDelegate, 
														    CLLocationManagerDelegate, MKReverseGeocoderDelegate> {

	Trip *trip;
	Destination *destination;

@private 
	UIToolbar *toolBar;															
    NSArray *titles;
	NSMutableArray *values;
	CellManager *cellManager;
	UISearchDisplayController *searchDisplayController;
	NSMutableArray *cities;		
	NSFetchedResultsController *fetchedResultsController;
    CLLocationManager *locationManager;
	ActivityManager *activityManager;
    MKReverseGeocoder *reverseGeocoder;
}

@property (nonatomic, retain) UIToolbar *toolBar;
@property (nonatomic, retain) NSArray *titles;
@property (nonatomic, retain) NSMutableArray *values;
@property (nonatomic, retain) Trip *trip;
@property (nonatomic, retain) Destination *destination;
@property (nonatomic, retain) CellManager *cellManager;
@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;
@property (nonatomic, retain) NSMutableArray *cities;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) ActivityManager *activityManager;
@property (nonatomic, retain) MKReverseGeocoder *reverseGeocoder;


-(void) save;
-(void) loadTitles;
-(void) loadCells;
-(void) loadValues;
-(void) configureSearchDisplay;
-(void) configureToolBar;
-(void) showActions:(id) sender;

@end
