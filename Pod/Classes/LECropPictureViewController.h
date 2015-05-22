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

//Image to Crop
@property (nonatomic) UIImage *image;

//Subviews
@property (weak, nonatomic) UIBarButtonItem *cancelButtonItem;
@property (weak, nonatomic) UIBarButtonItem *acceptButtonItem;
@property (weak, nonatomic) UIImageView *imageView;


//Type
@property (nonatomic, readonly) LECropPictureType cropPictureType;

//Configuration Properties
@property(nonatomic) CGRect cropFrame; //default is CGRectMake(20, 40, self.view.frame.size.width - 40, self.view.frame.size.width - 40)
@property(nonatomic) CGFloat borderWidth; //default is 2.0
@property(nonatomic) UIColor *borderColor; //default is whiteColor

//Callback Block
@property(copy) void(^photoAcceptedBlock)(UIImage *croppedPicture);


- (instancetype)initWithImage:(UIImage*)image andCropPictureType:(LECropPictureType)cropPictureType;

@end
