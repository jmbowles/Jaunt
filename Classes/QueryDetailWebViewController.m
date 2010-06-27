//
//  QueryDetailWebViewController.m
//  Jaunt
//
//  Created by John Bowles on 6/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "QueryDetailWebViewController.h"
#import "Logger.h"


@implementation QueryDetailWebViewController

@synthesize queryDetailUrl;
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
	aWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.webView = aWebView;
	[aWebView release];
	[self.view addSubview: self.webView];
	[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.queryDetailUrl]]];
}

- (void) viewDidUnLoad {
    
	[super viewDidUnload];
	[self.view removeFromSuperview];
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
	[webView release];
    [super dealloc];
}

@end
