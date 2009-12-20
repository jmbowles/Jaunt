//
//  CameraController.m
//  Jaunt
//
//  Created by John Bowles on 12/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CameraController.h"
#import "UIImage+Extension.h"


@implementation CameraController

@synthesize delegate;
@synthesize imageSelected;
@synthesize controller;
@synthesize view;


#pragma mark -
#pragma mark Construction

-(id) initWithController:(UIViewController *) aModalParentController andActionView:(UIView *) aView {
	
	if (self = [super init]) {
		
		self.controller = aModalParentController;
		self.view = aView;
	}
	return self;
}

#pragma mark -
#pragma mark Methods

-(void) selectImage {
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
														otherButtonTitles:@"Take Photo", @"Choose Existing Photo", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	actionSheet.cancelButtonIndex = 2;
	[actionSheet showInView: self.view];
	[actionSheet release];
}

-(UIImage *) imageSelectedUsingDefaultSize {

	return [self imageSelectedScaledToSize:CGSizeMake(88.0, 66.0)];
}

-(UIImage *) imageSelectedScaledToSize:(CGSize) newSize {
	
	return [UIImage imageWithImage:self.imageSelected scaledToSize:newSize];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *) aPicker didFinishPickingMediaWithInfo:(NSDictionary *) aDictionary {
	
	UIImage *anImage = [aDictionary valueForKey:UIImagePickerControllerOriginalImage];
	self.imageSelected = anImage;
	
	if (aPicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
		
		UIImageWriteToSavedPhotosAlbum (anImage,nil,nil,nil);
	}
	
	[aPicker dismissModalViewControllerAnimated:YES];
	
	[self.delegate didFinishSelectingImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *) aPicker {
	
	[aPicker dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - UIActionSheetDelegate

- (void) actionSheet:(UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex
{
	UIImagePickerController *aPicker = [[UIImagePickerController alloc] init];
	aPicker.delegate = self;
	
	if (buttonIndex == 0)
	{
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
			
			aPicker.sourceType = UIImagePickerControllerSourceTypeCamera;		
			[self.controller presentModalViewController:aPicker animated:YES];
			[aPicker release];
		}
	}
	if (buttonIndex == 1)
	{
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
			
			aPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			[self.controller presentModalViewController:aPicker animated:YES];
			[aPicker release];
		}
	}
}

#pragma mark -
#pragma mark Memory Management

- (void) dealloc {
	
	[imageSelected release];
	[super dealloc];
}

@end
