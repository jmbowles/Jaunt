//
//  PlaceViewController.m
//  Jaunt
//
//  Created by  on 12/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceViewController.h"
#import "GoogleQuery.h"
#import "ASIHTTPRequest.h"
#import "ActivityManager.h"
#import "GoogleServices.h"
#import "GoogleQuery.h"
#import "JauntAppDelegate.h"
#import "ReachabilityManager.h"
#import "GData.h"
#import "GooglePlaceRequest.h"
#import "GoogleServices.h"
#import "UIImageView+WebCache.h"
#import "Logger.h"

#define LIGHT_BACKGROUND [UIColor colorWithRed:224.0/255.0 green:225.0/255.0 blue:227.0/255.0 alpha:1.0]

@interface PlaceViewController (PrivateMethods)

-(void) performRefresh;

@end


@implementation PlaceViewController

@synthesize googleQuery, results, activityManager, reachability, ratingCell, placeCell, ratingCellNib, placeCellNib, httpRequest;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.ratingCellNib = [UINib nibWithNibName:@"RatingTableViewCell" bundle:nil];
    self.placeCellNib = [UINib nibWithNibName:@"PlaceTableViewCell" bundle:nil];
    
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
	
    NSURL *url = [NSURL URLWithString:[GoogleServices placesDetailQueryWithReference:self.googleQuery.placeReference]];
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
	GDataXMLElement *place = [[aDocument nodesForXPath:@"//PlaceDetailsResponse/result" error:&error] objectAtIndex:0];
    
    if ([status caseInsensitiveCompare:@"ok"] == NSOrderedSame) {
        
        GDataXMLElement *phone = [[place elementsForName:@"international_phone_number"] objectAtIndex:0];
        GDataXMLElement *icon = [[place elementsForName:@"icon"] objectAtIndex:0];
        GDataXMLElement *website = [[place elementsForName:@"url"] objectAtIndex:0];
        self.googleQuery.iconHref = [icon stringValue];
        self.googleQuery.phoneNumber = [phone stringValue];
        self.googleQuery.website = [website stringValue];
        
      } else {
        
        UIAlertView *anAlert = [[UIAlertView alloc] initWithTitle:self.googleQuery.title message:@"No results found"
                                                         delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[anAlert show];	
		[anAlert release];
    }
    
    [aDocument release];
    [self.activityManager hideActivity];
	[self.tableView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	[self.activityManager hideActivity];
	
	UIAlertView *anAlert = [[UIAlertView alloc] initWithTitle:self.googleQuery.title message:@"No results found"
													 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[anAlert show];	
	[anAlert release];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
       
        static NSString *identifier = @"RatingCellReuseIdentifier";
        RatingTableViewCell *cell = (RatingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            
            [self.ratingCellNib instantiateWithOwner:self options:nil];
            cell = self.ratingCell;
            cell.accessoryType = UITableViewCellAccessoryNone;
            self.ratingCell = nil;
        }
        
        cell.nameLabel.text = self.googleQuery.title;	
        cell.milesLabel.text = self.googleQuery.subTitle;
        cell.addressLabel.text = self.googleQuery.address;
        [cell.ratingView setRating:[self.googleQuery.detailedDescription floatValue]];
        [cell.icon setImageWithURL:[NSURL URLWithString:self.googleQuery.iconHref] placeholderImage:[UIImage imageNamed:@"atm.png"]];
        
        return cell;
        
    } else {
        
        static NSString *identifier = @"PlaceCellReuseIdentifier";
        PlaceTableViewCell *cell = (PlaceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            
            [self.placeCellNib instantiateWithOwner:self options:nil];
            cell = self.placeCell;
            cell.accessoryType = UITableViewCellAccessoryNone;
            self.placeCell = nil;
        }
        
        cell.phoneNumber = self.googleQuery.phoneNumber;
        cell.directions = self.googleQuery.mapsURL;
        cell.website = self.googleQuery.website;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return 78;
        
    } else {
        
        return 68;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
		
        cell.backgroundColor = LIGHT_BACKGROUND;
        
    } else {
        
        cell.backgroundColor = [UIColor clearColor];
    }
}


#pragma mark -
#pragma mark Memory Management

-(void)dealloc {

	[googleQuery release];
	[results release];
	[activityManager release];
	[reachability release];
    [ratingCell release];
    [placeCell release];
    [ratingCellNib release];
    [placeCellNib release];
    [httpRequest release];
   	[super dealloc];
}

@end
