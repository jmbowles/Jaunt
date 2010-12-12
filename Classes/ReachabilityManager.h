//
//  ReachabilityManager.h
//  Jaunt
//
//  Created by John Bowles on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import	"ReachabilityDelegate.h"

@class Reachability;

@interface ReachabilityManager : NSObject {

	id<ReachabilityDelegate> delegate;
	
@private
	
	Reachability *reachable;
}

@property (nonatomic, assign) id<ReachabilityDelegate> delegate;
@property (nonatomic, retain) Reachability *reachable;

-(id) initWithHost:(NSString *) aHostName;
-(id) initWithIPAddress:(const struct sockaddr_in*) anAddress;
-(id) initWithInternet;
-(id) initWithWiFi;
-(void) startListener;
-(void) stopListener;

@end
