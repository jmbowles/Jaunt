//
//  QueryResultController.m
//  Jaunt
//
//  Created by John Bowles on 3/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "QueryResultController.h"
#import "ActivityManager.h"
#import "GoogleServices.h"
#import "GoogleQuery.h"
#import "JauntAppDelegate.h"
#import "Logger.h"
#import "ReachabilityManager.h"
#import "ImageKeyValue.h"
#import "UIImageView+WebCache.h"
#import "PlaceViewController.h"
#import "GData.h"

#define DARK_BACKGROUND  [UIColor colorWithRed:203.0/255.0 green:204.0/255.0 blue:206.0/255.0 alpha:1.0]
#define LIGHT_BACKGROUND [UIColor colorWithRed:224.0/255.0 green:225.0/255.0 blue:227.0/255.0 alpha:1.0]

@interface QueryResultController (PrivateMethods)

-(void) performRefresh;

@end

@implementation QueryResultController


@synthesize placeRequest;
@synthesize currentLocation;
@synthesize googleQuery;
@synthesize results;
@synthesize activityManager;
@synthesize reachability;
@synthesize ratingCell;
@synthesize ratingCellNib;
@synthesize httpRequest;


#pragma mark -
#pragma mark View Management

-(void)viewDidLoad {
	
    [super viewDidLoad];
    
    self.ratingCellNib = [UINib nibWithNibName:@"RatingTableViewCell" bundle:nil];
    self.tableView.rowHeight = 78.0;
    
	ActivityManager *anActivityManager = [[ActivityManager alloc] initWithView:self.tableView];
	self.activityManager = anActivityManager;
	[anActivityManager release];
	[self.activityManager showActivity];
	
	ReachabilityManager *aReachability = [[ReachabilityManager alloc] initWithInternet];
	aReachability.delegate = self;
	self.reachability = aReachability;
	[aReachability release];
    
    [self performRefresh];
}

-(void) viewWillAppear:(BOOL)animated {
	
    [super viewWillAppear:animated];
	[self.reachability startListener];
}

-(void) viewWillDisappear:(BOOL)animated {
	
    [super viewWillDisappear:animated];
	[self.reachability stopListener];
    [self.activityManager hideActivity];
    [self.httpRequest clearDelegatesAndCancel];
    [self.httpRequest setDidFailSelector:nil];
    [self.httpRequest setDidFinishSelector:nil];
}

#pragma mark -
#pragma mark ReachabilityDelegate Callback

-(void) notReachable {
	
	[self.activityManager hideActivity];
	
	NSString *aMessage = @"Unable to connect to the network to display the Google search results.";
	UIAlertView *anAlert = [[UIAlertView alloc] initWithTitle:@"Network Unavailable" message:aMessage
													 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[anAlert show];	
	[anAlert release];
}

-(void) reachable {
	
	[self.activityManager showActivity];
	
    NSURL *url = [NSURL URLWithString:[self.placeRequest getQuery]];
	ASIHTTPRequest *aRequest = [[ASIHTTPRequest alloc] initWithURL:url];
    self.httpRequest = aRequest;
    
    [self.httpRequest setTimeOutSeconds:20];
	[self.httpRequest setDelegate:self];
	[self.httpRequest startAsynchronous];
    
    [aRequest release];
}

-(void) performRefresh {
	
	if ([self.reachability isCurrentlyReachable] == YES) {
		
		[self reachable];
		
	} else {
		
		[self notReachable];
	}
}

#pragma mark -
#pragma mark ASIHttpRequest Callbacks

- (void)requestFinished:(ASIHTTPRequest *)request
{
	NSData *xmlData = [request responseData];
    
	NSError *error;
	GDataXMLDocument *aDocument = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    NSString *status = [[[[aDocument rootElement] elementsForName:@"status"] objectAtIndex:0] stringValue];
	NSArray *places = [aDocument nodesForXPath:@"//PlaceSearchResponse/result" error:&error];
    NSMutableArray *queryResults = [NSMutableArray array];
    
    if ([status caseInsensitiveCompare:@"ok"] == NSOrderedSame) {
       
        for (GDataXMLElement *place in places) {
            
            GDataXMLElement *name = [[place elementsForName:@"name"] objectAtIndex:0];
            GDataXMLElement *address = [[place elementsForName:@"vicinity"] objectAtIndex:0];
            GDataXMLElement *rating = [[place elementsForName:@"rating"] objectAtIndex:0];
            GDataXMLElement *icon = [[place elementsForName:@"icon"] objectAtIndex:0];
            GDataXMLElement *placeReference = [[place elementsForName:@"reference"] objectAtIndex:0];
            GDataXMLElement *location = [[place nodesForXPath:@"geometry/location" error:&error] objectAtIndex:0];
            GDataXMLElement *lat = [[location elementsForName:@"lat"] objectAtIndex:0];
            GDataXMLElement *lng = [[location elementsForName:@"lng"] objectAtIndex:0];
            NSString *miles = [GoogleServices calculateDistanceFromLatitude:[lat stringValue] fromLongitude:[lng stringValue] toLocation:[self currentLocation]];
            
            GoogleQuery *aResult = [[GoogleQuery alloc] init];
            aResult.title = [name stringValue];
            aResult.iconHref = [icon stringValue];
            aResult.placeReference = [placeReference stringValue];
            aResult.subTitle = miles;
            aResult.detailedDescription = [rating stringValue];
            aResult.address = [address stringValue];
            aResult.mapsURL = [GoogleServices mapsURLWithAddress:[NSString stringWithFormat:@"%@,%@", [lat stringValue], [lng stringValue]] andLocation:[self currentLocation]];
            
            [queryResults addObject:aResult];
            [aResult release];
        }
        
    } else {
      
        UIAlertView *anAlert = [[UIAlertView alloc] initWithTitle:self.placeRequest.title message:@"No results found"
                                                         delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[anAlert show];	
		[anAlert release];
    }
    
    [aDocument release];
    [self.activityManager hideActivity];
	[self setResults: queryResults];
	[self.tableView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	[self.activityManager hideActivity];
	
	UIAlertView *anAlert = [[UIAlertView alloc] initWithTitle:self.placeRequest.title message:@"No results found"
													 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[anAlert show];	
	[anAlert release];
}


#pragma mark -
#pragma mark Table Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [self.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *identifier = @"RatingCellReuseIdentifier";
    RatingTableViewCell *cell = (RatingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];

	if (cell == nil) {
		
        [self.ratingCellNib instantiateWithOwner:self options:nil];
		cell = self.ratingCell;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		self.ratingCell = nil;
    }
 
	GoogleQuery *aQuery = [self.results objectAtIndex: [indexPath row]];
    cell.nameLabel.text = aQuery.title;	
	cell.milesLabel.text = aQuery.subTitle;
    cell.addressLabel.text = aQuery.address;
    [cell.ratingView setRating:[aQuery.detailedDescription floatValue]];
    [cell.icon setImageWithURL:[NSURL URLWithString:aQuery.iconHref] placeholderImage:[UIImage imageNamed:self.placeRequest.defaultImageName]];

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = (indexPath.row % 2 == 0) ? LIGHT_BACKGROUND : DARK_BACKGROUND;
}

#pragma mark -
#pragma mark Table Delegate Methods

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath 
{
	[self.tableView deselectRowAtIndexPath:indexPath animated: NO];
	
	self.googleQuery = [self.results objectAtIndex:indexPath.row];
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
													otherButtonTitles:@"Directions", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	actionSheet.cancelButtonIndex = 1;
	[actionSheet showInView: self.view];
	[actionSheet release];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	
	[self.tableView deselectRowAtIndexPath:indexPath animated: NO];
	
	GoogleQuery *aQuery = [self.results objectAtIndex:indexPath.row];
	JauntAppDelegate *aDelegate = [[UIApplication sharedApplication] delegate];

    PlaceViewController *aController = [[PlaceViewController alloc] initWithNibName:@"PlaceViewController" bundle:[NSBundle mainBundle]];
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
}

#pragma mark -
#pragma mark Memory Management

-(void)dealloc {
    
    [placeRequest release];
	[currentLocation release];
	[googleQuery release];
	[results release];
	[activityManager release];
	[reachability release];
    [ratingCell release];
    [ratingCellNib release];
    [httpRequest release];
	[super dealloc];
}

@end
