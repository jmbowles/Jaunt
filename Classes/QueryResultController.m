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
#import "GoogleEntry.h"
#import "QueryDetailController.h"
#import "QueryDetailWebViewController.h"
#import "JauntAppDelegate.h"


@implementation QueryResultController

@synthesize googleEntry;
@synthesize currentLocation;
@synthesize googleQuery;
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
	
	NSString *aQuery = [self.googleEntry getQuery];
	[GoogleServices executeQueryUsingDelegate:self selector:@selector(ticket:finishedWithFeed:error:) query:aQuery];
}

#pragma mark -
#pragma mark Google Base Query Callbacks

-(void)ticket:(GDataServiceTicket *) aTicket finishedWithFeed:(GDataFeedBase *) aFeed error:(NSError *) anError {
	
	NSMutableArray *queryResults = [NSMutableArray array];
	
	for (GDataEntryGoogleBase *entry in [aFeed entries]) {
	
		GoogleQuery *aResult = [[GoogleQuery alloc] init];
		
		aResult.title = [self.googleEntry formatTitleWithEntry:entry];
		aResult.subTitle = [self.googleEntry formatSubTitleWithEntry:entry];
		aResult.detailedDescription = [self.googleEntry formatDetailsWithEntry:entry];
		aResult.address = [entry location];
		aResult.href = [[entry alternateLink] href];
		aResult.mapsURL = [GoogleServices mapsURLWithAddress:[entry location] andLocation:self.currentLocation];
		
		[queryResults addObject:aResult];
		[aResult release];
	}
	
	[queryResults sortUsingSelector:@selector(compareQuery:)];
	
	[self.activityManager hideActivity];
	[self setResults: queryResults];
	[self.tableView reloadData];
	
	if ([[aFeed entries] count] == 0) {
	
		UIAlertView *anAlert = [[UIAlertView alloc] initWithTitle:[self.googleEntry getTitle] message:@"No results found"
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
	cell.textLabel.text = [aQuery.title capitalizedString];	
	cell.detailTextLabel.text = [aQuery.subTitle capitalizedString];
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
		JauntAppDelegate *aDelegate = [[UIApplication sharedApplication] delegate];
		QueryDetailWebViewController *aController = [[QueryDetailWebViewController alloc] init];
		[aController setTitle:self.googleQuery.title];
		[aController setQueryDetailUrl:self.googleQuery.href];
		[aDelegate.navigationController pushViewController:aController animated:YES];
		[aController release];
	}
}

#pragma mark -
#pragma mark Memory Management

-(void)dealloc {
    
	[googleEntry release];
	[currentLocation release];
	[googleQuery release];
	[results release];
	[activityManager release];
	[super dealloc];
}

@end
