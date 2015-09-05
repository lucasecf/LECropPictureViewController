//
//  LECropPictureViewController.h
//
//  Created by Lucas Eduardo on 18/05/15.
//  Copyright (c) 2015 wemob. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LECropPictureType) {
    LECropPictureTypeRounded,
    LECropPictureTypeRect,
};


@interface LECropPictureViewController : UIViewController

/**
 Image that will be cropped by the controller.
 */
@property (nonatomic) UIImage *image;

/**
 Button that appears in the bottom/left corner of the controller, inside the UIToolBar. Use this property to customize the button, for example changing it's text.
 By default, this button will dismiss the controller, but you can implement the photoRejectedBlock property to override this behaviour, for example performing some kind of validation.
 */
@property (weak, nonatomic) UIBarButtonItem *cancelButtonItem;

/**
 Button that appears in the bottom/right corner of the controller, inside the UIToolBar. Use this property to customize the button, for example changing it's text.
 By default, this button will always perform the photoAcceptedBlock property, passing the cropped image, and dismiss the controller by the end.
 */
@property (weak, nonatomic) UIBarButtonItem *acceptButtonItem;

/**
 ImageView that will hold the image to be cropped. you can use this property, for example, to change its contentMode according to your needs.
 */
@property (weak, nonatomic) UIImageView *imageView;

/**
 Readonly property, to tell if the controller will crop the image as a circle or a square.
 */
@property (nonatomic, readonly) LECropPictureType cropPictureType;


/**
 Controls the border width for the crop component. Default value is 2.0.
 */
@property(nonatomic) CGFloat borderWidth;

/**
 Controls the border color for the crop component. Default value is the [UIColor whiteColor].
 */
@property(nonatomic) UIColor *borderColor;

/**
 Controls the frame for the crop component. You can set this property to modify the initial size/position of the component. The default position is a centred square of max size - 50 margin points
 */
@property(nonatomic) CGRect cropFrame;

/**
 Called when the accept button is pressed.
 
 @param croppedPicture The cropped image (as circle or square) returned by the controller.
 */
@property(copy) void(^photoAcceptedBlock)(UIImage *croppedPicture);


/**
 Implement this block to modify the default behaviour of the cancelButtonItem property. Be aware that, if you implement this block, you should be responsible to dismiss the LECropPictureViewController when needed.
 */
@property(copy) void(^photoRejectedBlock)();


/**
 Default init for this component.
 
 @param image Image that will be cropped by the controller.
 
 @param cropPictureType Tells if the crop component will crop the image as a circle or a square. Check the LECropPictureType enum to see the possible values.
 
 */
- (instancetype)initWithImage:(UIImage*)image andCropPictureType:(LECropPictureType)cropPictureType;

@end
