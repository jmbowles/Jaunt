//
//  QueryResultController.m
//  Jaunt
//
//  Created by John Bowles on 3/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "QueryResultController.h"
#import "ActivityManager.h"
#import "GDataGoogleBase.h"
#import "GDataUtilities.h"
#import "GoogleServices.h"
#import "GoogleQuery.h"
#import "QueryDetailController.h"
#import "JauntAppDelegate.h"
#import "Logger.h"



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
	
		if ([[entry itemType]isEqualToString:[self.googleQuery itemType]]) {
			
			NSString *title = [[entry title] contentStringValue];
			NSString *address = [entry location];
			NSString *price = [[entry attributeWithName:@"price" type:kGDataGoogleBaseAttributeTypeText] textValue];
			
			GoogleQuery *aResult = [[GoogleQuery alloc] initWithTitle:title andAddress:address];
			[aResult setDetailedDescription:[[entry content] stringValue]];
			[aResult setPrice: price];
			[aResult setHref:[[entry alternateLink] href]];
			[aResult setMapsURL:[GoogleServices mapsURLWithAddress:address andLocation:self.currentLocation]];
			[queryResults addObject:aResult];
			[aResult release];
		}
	}
	
	[self.activityManager hideActivity];
	[self setResults: queryResults];
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
		
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifer] autorelease];
	}
	
	GoogleQuery *aQuery = [self.results objectAtIndex: [indexPath row]];
	
	cell.textLabel.text = aQuery.title;	
	cell.detailTextLabel.text = [NSString stringWithFormat:@"$%@", aQuery.price];
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	
	return cell;
}

#pragma mark -
#pragma mark Table Delegate Methods

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath 
{
	[self.tableView deselectRowAtIndexPath:indexPath animated: NO];
	
	self.googleQuery = [self.results objectAtIndex:indexPath.row];
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
													otherButtonTitles:@"Directions", @"Website", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	actionSheet.cancelButtonIndex = 2;
	[actionSheet showInView: self.view];
	[actionSheet release];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	[self.tableView deselectRowAtIndexPath:indexPath animated: NO];
	
	GoogleQuery *aQuery = [self.results objectAtIndex:indexPath.row];
	
	JauntAppDelegate *aDelegate = [[UIApplication sharedApplication] delegate];
	QueryDetailController *aController = [[QueryDetailController alloc] init];
	[aController setTitle:aQuery.title];
	[aController setGoogleQuery:aQuery];
	[aDelegate.navigationController pushViewController:aController animated:YES];
	[aController release];
}

#pragma mark -
#pragma mark ActionSheet Navigation 

- (void) actionSheet:(UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex
{
	if (buttonIndex == 0)
	{
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.googleQuery.mapsURL]];
	}
	if (buttonIndex == 1)
	{
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.googleQuery.href]];
	}
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
