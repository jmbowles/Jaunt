//
//  QueryResultController.m
//  Jaunt
//
//  Created by John Bowles on 3/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "QueryResultController.h"
#import "ActivityManager.h"
#import "GDataGoogleBase.h"
#import "GDataUtilities.h"
#import "GoogleServices.h"
#import "GoogleQuery.h"
#import "Logger.h"


@interface QueryResultController (PrivateMethods) 


@end


@implementation QueryResultController

@synthesize googleQuery;
@synthesize currentLocation;
@synthesize results;
@synthesize activityManager;


#pragma mark -
#pragma mark View Management

-(void)viewDidLoad {
	
    [super viewDidLoad];
	
	ActivityManager *anActivityManager = [[ActivityManager alloc] initWithView:self.tableView];
	self.activityManager = anActivityManager;
	[anActivityManager release];
	[self.activityManager showActivity];
	
	NSString *aQuery = self.googleQuery.query;
	[GoogleServices executeQueryUsingDelegate:self selector:@selector(ticket:finishedWithFeed:error:) query:aQuery];
}

#pragma mark -
#pragma mark Google Base Query Callbacks

-(void)ticket:(GDataServiceTicket *) aTicket finishedWithFeed:(GDataFeedBase *) aFeed error:(NSError *) anError {
	
	NSMutableArray *queryResults = [NSMutableArray array];
	
	for (GDataEntryGoogleBase *entry in [aFeed entries]) {
	
		NSString *title = [[entry title] contentStringValue];
		NSString *address = [entry location];
		GoogleQuery *aResult = [[GoogleQuery alloc] initWithTitle:title andAddress:address];
		[queryResults addObject:aResult];
		[aResult release];
		
		//NSArray *attributes = [entry i:@"Hotels" type:nil];
		
		//for (GDataGoogleBaseAttribute *value in attributes) {
		
		//	[Logger logMessage:[value description] withTitle:@"TextValue"];
		//}
		
	}
	
	[self.activityManager hideActivity];
	self.results = queryResults;
	[self.tableView reloadData];
	
	if ([[aFeed entries] count] == 0) {
	
		UIAlertView *anAlert = [[UIAlertView alloc] initWithTitle:self.googleQuery.title message:@"No results found"
													 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[anAlert show];	
		[anAlert release];
	}
}

#pragma mark -
#pragma mark Table Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [self.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *reuseIdentifer = @"ActionCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdentifer];
	
	if (cell == nil) {
		
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifer] autorelease];
	}
	
	GoogleQuery *aQuery = [self.results objectAtIndex: [indexPath row]];
	
	cell.textLabel.text = aQuery.title;	
	cell.accessoryType = UITableViewCellAccessoryNone;
	
	return cell;
}


- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath 
{
	[self.tableView deselectRowAtIndexPath:indexPath animated: NO];
	
	GoogleQuery *aQuery = [self.results objectAtIndex:indexPath.row];
	CLLocationCoordinate2D start = self.currentLocation.coordinate;
	
	NSString *encoded = [GDataUtilities stringByURLEncodingForURI:aQuery.address];
	
	NSString *googleMapsURLString = [NSString stringWithFormat:@"http://maps.google.com/?saddr=%1.6f,%1.6f&daddr=%@",
									 start.latitude, start.longitude, encoded];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapsURLString]];
}

#pragma mark -
#pragma mark Memory Management

-(void)dealloc {
    
	[googleQuery release];
	[currentLocation release];
	[results release];
	[activityManager release];
	[super dealloc];
}

@end
