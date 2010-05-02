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



@implementation WeatherHourlyController

@synthesize forecast;
@synthesize iconDictionary;
@synthesize activityManager;


#pragma mark -
#pragma mark View Management

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	ActivityManager *anActivityManager = [[ActivityManager alloc] initWithView:self.tableView];
	self.activityManager = anActivityManager;
	[anActivityManager release];
	
	[self.activityManager showActivity];
	
	NSURL *url = [NSURL URLWithString:[Forecast noaaHourlyUrlForLatitude:self.forecast.latitude andLongitude:self.forecast.longitude]];
	ASIHTTPRequest *aRequest = [ASIHTTPRequest requestWithURL:url];
	[aRequest setTimeOutSeconds:20];
	[aRequest setDelegate:self];
	[aRequest startAsynchronous];
}


#pragma mark -
#pragma mark ASIHTTP / Async Callbacks

- (void)requestFinished:(ASIHTTPRequest *)request
{
	[Logger logMessage:[request responseString] withTitle:@"NOAA Hourly Response"];
	
	NSData *xmlData = [request responseData];
	NSError *error;
	GDataXMLDocument *aDocument = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
	GDataXMLElement *aLocation = [[aDocument nodesForXPath:@"//location" error:&error] objectAtIndex:0];
	
	GDataXMLElement *key = [[aLocation elementsForName:@"location-key"] objectAtIndex:0];
	NSString *totalNodesXPath = [NSString stringWithFormat:@"/dwml/data/parameters[@applicable-location='%@']/temperature[@type='apparent']", [key stringValue]];
	NSUInteger totalNodes = [[[aDocument nodesForXPath:totalNodesXPath error:&error] objectAtIndex:0] childCount]-1;
	int hoursPerNode = 3;
	NSUInteger totalHours = totalNodes * hoursPerNode;
	[Logger logMessage:[NSString stringWithFormat:@"%i", totalNodes] withTitle:@"Total Nodes"];
	
	for(int i=1; i <= totalHours; i++) {
		
		int index = ceil(i / hoursPerNode) == 0 ? 1 : ceil(i / hoursPerNode);
		
		[Logger logMessage:[NSString stringWithFormat:@"%i", index] withTitle:@"Ceiling"];
		
		NSString *currentTempXPath = [NSString stringWithFormat:@"/dwml/data/parameters[@applicable-location='%@']/temperature[@type='apparent']/value[position()=%i]", [key stringValue], index];
		NSString *temperature = [[[aDocument nodesForXPath:currentTempXPath error:&error] objectAtIndex:0] stringValue];
		NSString *windSpeedXPath = [NSString stringWithFormat:@"/dwml/data/parameters[@applicable-location='%@']/wind-speed[@type='sustained']/value[position()=%i]", [key stringValue], index];
		NSString *windSpeed = [[[aDocument nodesForXPath:windSpeedXPath error:&error] objectAtIndex:0] stringValue];
		NSString *windDirectionXPath = [NSString stringWithFormat:@"/dwml/data/parameters[@applicable-location='%@']/direction[@type='wind']/value[position()=%i]", [key stringValue], index];
		NSString *windDirection = [[[aDocument nodesForXPath:windDirectionXPath error:&error] objectAtIndex:0] stringValue];
		NSString *iconXPath = [NSString stringWithFormat:@"/dwml/data/parameters[@applicable-location='%@']/conditions-icon/icon-link[position()=%i]", [key stringValue], index];
		NSString *iconName = [[[aDocument nodesForXPath:iconXPath error:&error] objectAtIndex:0] stringValue];
		
		HourlyDetail *anHourlyDetail = [[HourlyDetail alloc] init];
		[anHourlyDetail setHour:[NSString stringWithFormat:@"%i", i]];
		[anHourlyDetail setWindDirection:windDirection];
		[anHourlyDetail setWindSpeed:windSpeed];
		[anHourlyDetail setTemperature:temperature];
		[anHourlyDetail setImageKey:iconName];
		
		[self.forecast.hourlyDetails addObject:anHourlyDetail];
		[anHourlyDetail release];
	}
	
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
	
	cell.textLabel.text = [NSString stringWithFormat:@"Temperature: %@\u2070 F", anHourlyDetail.temperature];	
	cell.detailTextLabel.text = [NSString stringWithFormat:@"Wind Speed: %@, Direction: %@", anHourlyDetail.windSpeed, anHourlyDetail.windDirection];
	cell.accessoryType = UITableViewCellAccessoryNone;
	[Logger logMessage:anHourlyDetail.imageKey withTitle:@"ImageKey"];
	//cell.imageView.image = [self.iconDictionary objectForKey:anHourlyDetail.imageKey];
	cell.imageView.image = [UIImage imageNamed:@"bkn.jpg"];
	
	return cell;
}


#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
    
	[forecast release];
	[iconDictionary release];
	[activityManager release];
	[super dealloc];
}

@end
