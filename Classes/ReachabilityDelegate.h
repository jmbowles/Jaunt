//
//  ReachabilityDelegate.h
//  Jaunt
//
//  Created by John Bowles on 12/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ReachabilityDelegate <NSObject>

@optional

-(void) notReachable;
-(void) reachable;
-(void) reachableViaWiFi;
-(void) reachableViaCellular;

@end
 
