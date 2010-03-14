//
//  QueryDetailController.m
//  Jaunt
//
//  Created by John Bowles on 3/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "QueryDetailController.h"
#import "GoogleQuery.h"

@interface QueryDetailController (PrivateMethods) 

-(void) setupTextView;

@end


@implementation QueryDetailController

@synthesize textView;
@synthesize googleQuery;


#pragma mark -
#pragma mark View Management

-(void)viewDidLoad {
	
    [super viewDidLoad];
	[self setupTextView];
}

- (void)setupTextView
{
	NSString *details = self.googleQuery.detailedDescription;
	
	self.textView = [[[UITextView alloc] initWithFrame:self.view.frame] autorelease];
	self.textView.textColor = [UIColor blackColor];
	self.textView.font = [UIFont fontWithName:@"Arial" size:16];
	self.textView.backgroundColor = [UIColor whiteColor];
	
	if (self.googleQuery.detailedDescription == nil || [self.googleQuery.detailedDescription isEqualToString:@""]) {
		
		details = @"No details were found";
	}
	self.textView.text = details;
	self.textView.scrollEnabled = YES;
	self.textView.editable = NO;
	self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	
	[self.view addSubview: self.textView];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	self.textView = nil;
}

#pragma mark -
#pragma mark Memory Management

-(void)dealloc {
    
	[textView release];
	[googleQuery release];
	[super dealloc];
}

@end
