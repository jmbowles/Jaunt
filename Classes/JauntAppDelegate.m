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


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
