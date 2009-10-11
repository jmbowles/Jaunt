//
//  JauntAppDelegate.m
//  Jaunt
//
//  Created by John Bowles on 10/11/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "JauntAppDelegate.h"

@implementation JauntAppDelegate

@synthesize window;
@synthesize rootController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

	[window addSubview: rootController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
	[rootController release];
    [window release];
    [super dealloc];
}

@end
