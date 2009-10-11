//
//  JauntAppDelegate.h
//  Jaunt
//
//  Created by John Bowles on 10/11/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JauntAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	IBOutlet UITabBarController *rootController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *rootController;

@end

