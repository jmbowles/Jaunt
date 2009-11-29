//
//  TextFieldCell.h
//  Jaunt
//
//  Created by John Bowles on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IndexedTextField;


@interface TextFieldCell : UITableViewCell {

	IBOutlet UILabel *leftLabel;
	IBOutlet IndexedTextField *textField;
}

@property (nonatomic, retain) UILabel *leftLabel;
@property (nonatomic, retain) IndexedTextField *textField;

-(IBAction) textFieldDoneEditing;

@end
