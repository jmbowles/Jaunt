//
//  ReachabilityManager.m
//  Jaunt
//
//  Created by John Bowles on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ReachabilityManager.h"
#import "Reachability.h"

@interface ReachabilityManager (PrivateMethods) 

-(void) configureReachability:(Reachability *) aReachable;
-(void) reachabilityChanged:(NSNotification* )aNotification;
-(void) notifyDelegate:(NetworkStatus) aStatus;

@end


@implementation ReachabilityManager

@synthesize delegate;
@synthesize reachable;


#pragma mark -
#pragma mark Construction

-(id) initWithHost:(NSString *) aHostName {
	
	if (self = [super init]) {
		
		[self configureReachability: [Reachability reachabilityWithHostName: aHostName]];
	}
	return self;
}

-(id) initWithIPAddress:(const struct sockaddr_in*) anAddress {
	
	if (self = [super init]) {
		
		[self configureReachability: [Reachability reachabilityWithAddress: anAddress]];
	}
	return self;
}

-(id) initWithInternet {
	
	if (self = [super init]) {
		
		[self configureReachability: [Reachability reachabilityForInternetConnection]];
	}
	return self;
}

-(id) initWithWiFi {
	
	if (self = [super init]) {
		
		[self configureReachability: [Reachability reachabilityForLocalWiFi]];		
	}
	return self;
}

#pragma mark -
#pragma mark Public Implementation

-(void) startListener {
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
	[self.reachable startNotifier];
}

-(void) stopListener {
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self.reachable stopNotifier];
}

#pragma mark -
#pragma mark Memory Management

- (void) dealloc {
	
	[reachable release];
	[super dealloc];
}

#pragma mark -
#pragma mark Private Implementation

-(void) configureReachability:(Reachability *) aReachable {
	
	self.reachable = aReachable;
}

- (void) reachabilityChanged: (NSNotification* )aNotification {
	
	Reachability *target = [aNotification object];
	NSParameterAssert([target isKindOfClass: [Reachability class]]);
	[self notifyDelegate: [target currentReachabilityStatus]];
}

- (void) notifyDelegate:(NetworkStatus) aStatus {
	
    switch (aStatus)
    {
        case NotReachable:
        {
			if ([self.delegate respondsToSelector:@selector(notReachable)] == YES) {
				
				[self.delegate notReachable];
			}
			break;
        }
		case ReachableViaWWAN:
        {
			if ([self.delegate respondsToSelector:@selector(reachableViaCellular)] == YES) {
				
				[self.delegate reachableViaCellular];
			}
			if ([self.delegate respondsToSelector:@selector(reachable)] == YES) {
				
				[self.delegate reachable];
			}
			
            break;
        }
        case ReachableViaWiFi:
        {
			if ([self.delegate respondsToSelector:@selector(reachableViaWiFi)] == YES) {
				
				[self.delegate reachableViaWiFi];
			}
			if ([self.delegate respondsToSelector:@selector(reachable)] == YES) {
				
				[self.delegate reachable];
			}
            break;
		}
    }
}

@end
