//
//  QueryDetailWebViewController.m
//  Jaunt
//
//  Created by John Bowles on 6/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "QueryDetailWebViewController.h"
#import "Logger.h"

@interface QueryDetailWebViewController (PrivateMethods) 

-(void) configureToolBar;
-(void) goBack;
-(void) goForward;
-(void) openWithSafari;

@end


@implementation QueryDetailWebViewController

@synthesize queryDetailUrl;
@synthesize toolBar;
@synthesize webView;


#pragma mark -
#pragma mark View Management

- (void) viewDidLoad {
    
	[super viewDidLoad];
	
	CGRect aFrame = [[UIScreen mainScreen] applicationFrame];
	aFrame.origin.y -= 20;
	UIWebView *aWebView = [[UIWebView alloc] initWithFrame:aFrame];
	aWebView.backgroundColor = [UIColor whiteColor];
	aWebView.scalesPageToFit = YES;
	aWebView.dataDetectorTypes = UIDataDetectorTypeAll;
	aWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.webView = aWebView;
	[aWebView release];
	[self.view addSubview: self.webView];
	[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.queryDetailUrl]]];
	
	[self configureToolBar];
}

- (void) viewDidUnLoad {
    
	[super viewDidUnload];
	[self.webView removeFromSuperview];
	[self.toolBar removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
	self.webView.delegate = self;	
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.webView stopLoading];
	self.webView.delegate = nil;	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark -
#pragma mark Method Implementations

-(void) configureToolBar {
	
	UIBarButtonItem *goBackButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack)];
	UIBarButtonItem *goForwardButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Forward" style:UIBarButtonItemStyleBordered target:self action:@selector(goForward)];
	UIBarButtonItem *safariButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Safari" style:UIBarButtonItemStyleBordered target:self action:@selector(openWithSafari)];
	
	UIToolbar *aToolbar = [[UIToolbar alloc] init];
	aToolbar.barStyle = UIBarStyleDefault;
	[aToolbar sizeToFit];
	
	CGFloat toolbarHeight = [aToolbar frame].size.height;
	CGRect aRectangle = self.view.bounds;
	[aToolbar setFrame:CGRectMake(CGRectGetMinX(aRectangle),
								  CGRectGetMinY(aRectangle) + CGRectGetHeight(aRectangle) - (toolbarHeight * .60),
								  CGRectGetWidth(aRectangle),
								  48.0)];
	
	NSArray *items = [NSArray arrayWithObjects: goBackButtonItem, goForwardButtonItem, safariButtonItem, nil];
	[aToolbar setItems:items animated:NO];
	
	[self.navigationController.view addSubview:aToolbar];
	self.toolBar = aToolbar;
	
	[aToolbar release];
	[goBackButtonItem release];
	[goForwardButtonItem release];
	[safariButtonItem release];
}

-(void) goBack {

	[self.webView goBack];
}

-(void) goForward {
	
	[self.webView goForward];
}

-(void) openWithSafari {
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.queryDetailUrl]];
}

#pragma mark -
#pragma mark UIWebViewDelegate Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	UIAlertView *anAlert = [[UIAlertView alloc] initWithTitle:@"Website" message:@"Unable to load website"
													 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[anAlert show];	
	[anAlert release];
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	
	[queryDetailUrl release];
	[toolBar release];
	[webView release];
    [super dealloc];
}

@end
