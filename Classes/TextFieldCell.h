//
//  TextFieldCell.h
//  Jaunt
//
//  Created by John Bowles on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@interface TextFieldCell : UITableViewCell {

	IBOutlet UILabel* leftTitleLabel;
	IBOutlet UITextField* textField;
}

@property (nonatomic, retain) UILabel* leftTitleLabel;
@property (nonatomic, retain) UITextField* textField;

-(IBAction) textFieldDoneEditing;

@end
