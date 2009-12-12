//
//  ActivityManager.h
//  Jaunt
//
//  Created by John Bowles on 12/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ActivityManager : NSObject {

@private
	UIView *view;
	NSOperationQueue *queue;
	UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, assign) UIView *view;
@property (nonatomic, retain) NSOperationQueue *queue;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

-(id) initWithView:(UIView *) aView;
-(id) startTaskWithTarget:(id) aTarget selector:(SEL) aSelector object:(id) anArgument;
-(void) stopTask;
-(void) showActivity;
-(void) hideActivity;

@end

