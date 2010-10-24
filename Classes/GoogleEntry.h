//
//  GoogleEntryFormatter.h
//  Jaunt
//
//  Created by John Bowles on 3/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class GDataEntryGoogleBase;

@protocol GoogleEntry <NSObject>

-(NSString *) getTitle;
-(NSString *) getItemType;
-(NSString *) getQuery;
-(NSString *) formatTitleWithEntry:(GDataEntryGoogleBase *) anEntry;
-(NSString *) formatSubTitleWithEntry:(GDataEntryGoogleBase *) anEntry andAddress:(NSString *) anAddress;
-(NSString *) formatDetailsWithEntry:(GDataEntryGoogleBase *) anEntry;

@optional
-(CLLocation *) getCurrentPosition;
-(NSString *) getOrderBy;

@end