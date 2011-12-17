//
//  PlaceTableViewCell.h
//  Jaunt
//
//  Created by  on 12/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceTableViewCell : UITableViewCell {
    
    NSString *phoneNumber;
	NSString *directions;
	NSString *website;
}

@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, retain) NSString *directions;
@property (nonatomic, retain) NSString *website;

-(IBAction)makePhoneCall:(id)sender;
-(IBAction)invokeWithDirections:(id)sender;
-(IBAction)invokeWithWebsite:(id)sender;

@end
