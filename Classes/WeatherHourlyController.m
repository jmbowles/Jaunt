//
//  WeatherHourlyController.m
//  Jaunt
//
//  Created by John Bowles on 5/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WeatherHourlyController.h"
#import "Forecast.h"
#import "HourlyDetail.h"
#import "GDataXMLNode.h"
#import "Destination.h"
#import "ASIHTTPRequest.h"
#import "Logger.h"
#import "ActivityManager.h"
#import "DateUtils.h"
#import "ImageKeyValue.h"
#import "ReachabilityManager.h"

@interface WeatherHourlyController (PrivateMethods)

-(void) performRefresh;

@end


@implementation WeatherHourlyController

@synthesize forecast;
@synthesize iconDictionary;
@synthesize activityManager;
@synthesize queue;
@synthesize reachability;


#pragma mark -
#pragma mark View Management

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	ActivityManager *anActivityManager = [[ActivityManager alloc] initWithView:self.tableView];
	self.activityManager = anActivityManager;
	[anActivityManager release];
	
	NSOperationQueue *aQueue = [[NSOperationQueue alloc] init];
	[aQueue setMaxConcurrentOperationCount:3];
	self.queue = aQueue;
	[aQueue release];
	
	self.iconDictionary = [NSMutableDictionary dictionary];
	
	ReachabilityManager *aReachability = [[ReachabilityManager alloc] initWithInternet];
	aReachability.delegate = self;
	self.reachability = aReachability;
	[aReachability release];
	
	[self performRefresh];
}

-(void) viewWillAppear:(BOOL)animated {
	
	[self.reachability startListener];
}

-(void) viewWillDisappear:(BOOL)animated {
	
	[self.reachability stopListener];
	[self.forecast.hourlyDetails removeAllObjects];
}

#pragma mark -
#pragma mark ReachabilityDelegate Callback

-(void) notReachable {
	
	[self.activityManager hideActivity];
	
	NSString *aMessage = @"Unable to connect to the network to display the weather hourly forecast.";
	UIAlertView *anAlert = [[UIAlertView alloc] initWithTitle:@"Network Unavailable" message:aMessage
													 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[anAlert show];	
	[anAlert release];
}

-(void) reachable {
	
	[self.activityManager showActivity];
	
	NSURL *url = [NSURL URLWithString:[Forecast noaaHourlyUrlForLatitude:self.forecast.latitude andLongitude:self.forecast.longitude]];
	ASIHTTPRequest *aRequest = [ASIHTTPRequest requestWithURL:url];
	[aRequest setTimeOutSeconds:20];
	[aRequest setDelegate:self];
	[aRequest startAsynchronous];
}

-(void) performRefresh {
	
	if ([self.reachability isCurrentlyReachable] == YES) {
		
		[self reachable];
		
	} else {
		
		[self notReachable];
	}
}

#pragma mark -
#pragma mark ASIHTTP / Async Callbacks

- (void) downloadImage:(NSString *) urlString
{
    NSAutoreleasePool *pool  = [[NSAutoreleasePool alloc] init];
	
	NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
	UIImage *anImage = [[UIImage alloc] initWithData:data];
	ImageKeyValue *anImageKeyValuePair = [[ImageKeyValue alloc] init];
	[anImageKeyValuePair setKeyName:urlString];
	[anImageKeyValuePair setImageValue:anImage];
	[anImage release];
    [self performSelectorOnMainThread:@selector(imageLoaded:) withObject:anImageKeyValuePair waitUntilDone:YES];
    [anImageKeyValuePair release];
	
    [pool release];
}

- (void)downloadImages:(NSDictionary *) aDictionary
{
	for (NSString *urlKey in aDictionary) {
		
		NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImage:) object:urlKey];
		[self.queue addOperation:operation];
		[operation release];
	}
}

- (void)imageLoaded:(ImageKeyValue *) anImageKeyValuePair
{
    [self.iconDictionary setValue:[anImageKeyValuePair imageValue] forKey:[anImageKeyValuePair keyName]];
	
	// The operations count will be 0 AFTER this method exists, since it is the designated callback
	if ([[self.queue operations] count] == 1) {
		
		[self.activityManager hideActivity];
	}
	[self.tableView reloadData];
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
	[Logger logMessage:[request responseString] withTitle:@"NOAA Hourly Response"];
	
	NSData *xmlData = [request responseData];
	NSError *error;
	GDataXMLDocument *aDocument = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
	GDataXMLElement *aLocation = [[aDocument nodesForXPath:@"//location" error:&error] objectAtIndex:0];
	
	NSArray *icons = [aDocument nodesForXPath:@"//conditions-icon/icon-link" error:&error];
	
	for(GDataXMLElement *anIcon in icons) {
		
		if ([self.iconDictionary objectForKey:[anIcon stringValue]] == nil) {
			
			[self.iconDictionary setValue:[UIImage imageNamed:@"bkn.jpg"] forKey:[anIcon stringValue]];
		}
	}
	
	[self downloadImages:self.iconDictionary];
	
	GDataXMLElement *key = [[aLocation elementsForName:@"location-key"] objectAtIndex:0];
	NSString *totalNodesXPath = [NSString stringWithFormat:@"/dwml/data/parameters[@applicable-location='%@']/temperature[@type='apparent']", [key stringValue]];
	NSUInteger totalNodes = [[[aDocument nodesForXPath:totalNodesXPath error:&error] objectAtIndex:0] childCount]-1;
	int hoursPerNode = 3;
	int totalHours = totalNodes * hoursPerNode;
	
	NSString *dayOfWeek = @"";
	NSDate *now = [NSDate date];
	NSCalendar *aCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *hourlyComponents = [[NSDateComponents alloc] init];
	
	for(int i=1; i <= totalHours; i++) {
		
		int index = ceil(i / hoursPerNode) == 0 ? 1 : ceil(i / hoursPerNode);
		
		NSString *currentTempXPath = [NSString stringWithFormat:@"/dwml/data/parameters[@applicable-location='%@']/temperature[@type='apparent']/value[position()=%i]", [key stringValue], index];
		NSString *temperature = [[[aDocument nodesForXPath:currentTempXPath error:&error] objectAtIndex:0] stringValue];
		NSString *windSpeedXPath = [NSString stringWithFormat:@"/dwml/data/parameters[@applicable-location='%@']/wind-speed[@type='sustained']/value[position()=%i]", [key stringValue], index];
		NSString *windSpeed = [[[aDocument nodesForXPath:windSpeedXPath error:&error] objectAtIndex:0] stringValue];
		NSString *windDirectionXPath = [NSString stringWithFormat:@"/dwml/data/parameters[@applicable-location='%@']/direction[@type='wind']/value[position()=%i]", [key stringValue], index];
		NSString *windDirection = [[[aDocument nodesForXPath:windDirectionXPath error:&error] objectAtIndex:0] stringValue];
		NSString *iconXPath = [NSString stringWithFormat:@"/dwml/data/parameters[@applicable-location='%@']/conditions-icon/icon-link[position()=%i]", [key stringValue], index];
		NSString *iconName = [[[aDocument nodesForXPath:iconXPath error:&error] objectAtIndex:0] stringValue];
		
		HourlyDetail *anHourlyDetail = [[HourlyDetail alloc] init];
		
		[hourlyComponents setHour: i];
		NSDate *endingDate = [aCalendar dateByAddingComponents:hourlyComponents toDate:now options:0];
		NSDateComponents *endingHourComponents = [aCalendar components:NSHourCalendarUnit fromDate:endingDate];
		NSInteger endingHour = [endingHourComponents hour];
		
		if (endingHour == 0) {
		
			NSDateFormatter *aDateFormatter = [[NSDateFormatter alloc] init];
			[aDateFormatter setDateFormat:@"EEEE"];
			dayOfWeek = [aDateFormatter stringFromDate:endingDate];
			[aDateFormatter release];
			
		} else {
		
			dayOfWeek = @"";
		}
		
		[anHourlyDetail setHour:[NSString stringWithFormat:@"%i:00 %@", endingHour, dayOfWeek]];
		[anHourlyDetail setWindDirection:windDirection];
		[anHourlyDetail setWindSpeed:windSpeed];
		[anHourlyDetail setTemperature:temperature];
		[anHourlyDetail setImageKey:iconName];
		
		[self.forecast.hourlyDetails addObject:anHourlyDetail];
		[anHourlyDetail release];
	}
	
	[hourlyComponents release];
	[aCalendar release];
	[aDocument release];
	[self.activityManager hideActivity];
	[self.tableView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	[self.activityManager hideActivity];
	
	UIAlertView *anAlert = [[UIAlertView alloc] initWithTitle:@"Hourly Weather Status" message:@"Unable to determine hourly forecast"
													 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[anAlert show];	
	[anAlert release];
}

#pragma mark -
#pragma mark Table Data Source Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [self.forecast.hourlyDetails count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *reuseIdentifer = @"HourlyForecastCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdentifer];
	
	if (cell == nil) {
		
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifer] autorelease];
	}
	
	cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
	cell.detailTextLabel.numberOfLines = 0;
	
	HourlyDetail *anHourlyDetail = [self.forecast.hourlyDetails objectAtIndex: [indexPath row]];

	cell.textLabel.text = [NSString stringWithFormat:@"%@", anHourlyDetail.hour];	
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\u2070 F, Wind: %@ MPH, Direction: %@", anHourlyDetail.temperature, anHourlyDetail.windSpeed, [Forecast windDirectionUsingBearing:[anHourlyDetail.windDirection intValue]]];
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.imageView.image = [self.iconDictionary objectForKey:anHourlyDetail.imageKey];
	
	return cell;
}


#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
    
	[forecast release];
	[iconDictionary release];
	[activityManager release];
	[queue release];
	[reachability release];
	[super dealloc];
}

@end
