//
//  PlaceTableViewCell.m
//  Jaunt
//
//  Created by  on 12/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceTableViewCell.h"

@implementation PlaceTableViewCell

@synthesize phoneNumber, directions, website;


#pragma mark -
#pragma mark Button Handlers

-(IBAction)makePhoneCall:(id)sender {
    
    NSString *cleanedString = [[self.phoneNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", escapedPhoneNumber]];
    
    [[UIApplication sharedApplication] openURL:telURL];
}

-(IBAction)invokeWithDirections:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.directions]];
}

-(IBAction)invokeWithWebsite:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.website]];
}

#pragma mark -
#pragma mark Memory Management

- (void) dealloc {
	
	[phoneNumber release];
	[directions release];
	[website release];
	
	[super dealloc];
}

@end
