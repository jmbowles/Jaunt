//
//  DestinationDetailController.m
//  Jaunt
//
//  Created by John Bowles on 3/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DestinationDetailController.h"
#import "GDataGoogleBase.h"
#import "GoogleServices.h"
#import "GoogleQuery.h"
#import "Destination.h"
#import "QueryResultController.h"
#import "JauntAppDelegate.h"
#import "Logger.h"


@interface DestinationDetailController (PrivateMethods) 

-(void) loadActions;

@end


@implementation DestinationDetailController

@synthesize destination;
@synthesize currentLocation;
@synthesize actions;


#pragma mark -
#pragma mark View Management

-(void)viewDidLoad {
	
    [super viewDidLoad];
	[self loadActions];
}

#pragma mark -
#pragma mark Table Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [self.actions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *reuseIdentifer = @"ActionCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdentifer];
	
	if (cell == nil) {
		
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifer] autorelease];
	}
	
	GoogleQuery *aQuery = [self.actions objectAtIndex: [indexPath row]];
	
	cell.textLabel.text = aQuery.title;	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
}


- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath 
{
	[self.tableView deselectRowAtIndexPath:indexPath animated: NO];
	
	GoogleQuery *aQuery = [self.actions objectAtIndex:indexPath.row];
	JauntAppDelegate *aDelegate = [[UIApplication sharedApplication] delegate];
	QueryResultController *aController = [[QueryResultController alloc] init];
	
	[aController setTitle:aQuery.title];
	[aController setGoogleQuery:aQuery];
	[aController setCurrentLocation: self.currentLocation];
	[aDelegate.navigationController pushViewController:aController animated:YES];
	[aController release];
}

#pragma mark -
#pragma mark Private Methods

-(void) loadActions {
	
	NSString *latLong = [GoogleServices formatLatitude:self.destination.latitude andLongitude:self.destination.longitude];
	NSString *hotels = [NSString stringWithFormat:@"hotels [location: @%@ + 10mi]", latLong];
	
	GoogleQuery *hotelQuery = [[GoogleQuery alloc] initWithTitle:@"Lodging" andQuery:hotels];
	[hotelQuery setItemType:@"Hotels"];
	NSArray *anArray = [[NSArray alloc] initWithObjects:hotelQuery, nil];
	[self setActions: anArray];
	[hotelQuery release];
	[anArray release];
}


#pragma mark -
#pragma mark Memory Management

-(void)dealloc {
    
	[destination release];
	[currentLocation release];
	[actions release];
	[super dealloc];
}

@end
