//
//  QueryDetailWebViewController.h
//  Jaunt
//
//  Created by John Bowles on 6/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QueryDetailWebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate> {

	NSString *queryDetailUrl;

@private
	
	UIToolbar *toolBar;
	UIWebView *webView;
}

@property (nonatomic, retain) NSString *queryDetailUrl;
@property (nonatomic, retain) UIToolbar *toolBar;
@property (nonatomic, retain) UIWebView *webView;

@end
