//
//  QueryDetailWebViewController.h
//  Jaunt
//
//  Created by John Bowles on 6/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReachabilityDelegate.h"

@class ReachabilityManager;

@interface QueryDetailWebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate, ReachabilityDelegate> {

	NSString *queryDetailUrl;

@private
	
	UIToolbar *toolBar;
	UIWebView *webView;
	ReachabilityManager *reachability;
}

@property (nonatomic, retain) NSString *queryDetailUrl;
@property (nonatomic, retain) UIToolbar *toolBar;
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) ReachabilityManager *reachability;

@end
