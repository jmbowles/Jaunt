//
//  NonEditableCell.h
//  Jaunt
//
//  Created by John Bowles on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NonEditableCell : UITableViewCell {

	IBOutlet UILabel* leftLabel;
}

@property (nonatomic, retain) UILabel* leftLabel;

@end
