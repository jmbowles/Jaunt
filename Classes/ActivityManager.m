//
//  ActivityManager.m
//  Jaunt
//
//  Created by John Bowles on 12/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ActivityManager.h"


@implementation ActivityManager

@synthesize view;
@synthesize queue;
@synthesize activityIndicator;

#pragma mark -
#pragma mark Construction

-(id) initWithView:(UIView *) aView {
	
	if (self = [super init]) {
		
		self.view = aView;
		
		NSOperationQueue *aQueue = [[NSOperationQueue alloc] init];
		[aQueue setMaxConcurrentOperationCount:1];
		self.queue = aQueue;
		[aQueue release];
		
		UIActivityIndicatorView *activity= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		activity.hidesWhenStopped = YES;
		self.activityIndicator = activity;
		[activity release];
	}
	return self;
}

#pragma mark -
#pragma mark Background Operations

-(id) startTaskWithTarget:(id) aTarget selector:(SEL) aSelector object:(id) anArgument {
	
	[self showActivity];
	
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:aTarget selector:aSelector object:anArgument];
	[self.queue addOperation:operation];
	[operation release];
	
	return nil;
}

-(void) stopTask {
	
	[self hideActivity];
}

#pragma mark -
#pragma mark Activity Indication

-(void) showActivity {
    
	UIApplication *anApplication = [UIApplication sharedApplication];
	anApplication.networkActivityIndicatorVisible = YES;
	
	[self.activityIndicator startAnimating];
	
	// Center the indicator in the middle of the view
	CGRect aFrame = self.activityIndicator.frame;
	aFrame.origin.x = (self.view.bounds.size.width - aFrame.size.width) / 2.0;
	aFrame.origin.y = (self.view.bounds.size.height - aFrame.size.height) / 2.0;
	self.activityIndicator.frame = aFrame;
	
	[self.view addSubview:self.activityIndicator];
}

-(void) hideActivity {
    
	UIApplication *anApplication = [UIApplication sharedApplication];
	anApplication.networkActivityIndicatorVisible = NO;
	
	[self.activityIndicator stopAnimating];
	[self.activityIndicator removeFromSuperview];
}

#pragma mark -
#pragma mark Memory Management

- (void) dealloc {
	
	[queue release];
	[activityIndicator release];
	[super dealloc];
}

@end
