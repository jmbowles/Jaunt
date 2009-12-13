//
//  CameraController.h
//  Jaunt
//
//  Created by John Bowles on 12/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CameraControllerDelegate.h"


@interface CameraController : NSObject <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {

	UIImage *imageSelected;
	id<CameraControllerDelegate> delegate;
	
@private
	
	UIViewController *controller;
	UIView *view;
}

@property (nonatomic, assign) id<CameraControllerDelegate> delegate;
@property (nonatomic, retain) UIImage *imageSelected;
@property (nonatomic, assign) UIViewController *controller;
@property (nonatomic, assign) UIView *view;

-(id) initWithController:(UIViewController *) aModalParentController andActionView:(UIView *) aView;
-(void) selectImage;
-(UIImage *) imageSelectedUsingDefaultSize;
-(UIImage *) imageSelectedScaledToSize:(CGSize) newSize;

@end
