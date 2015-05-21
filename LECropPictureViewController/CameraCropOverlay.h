//
//  CameraRoundOverlay.h
//  Moodcrowd
//
//  Created by Lucas Eduardo on 02/09/14.
//  Copyright (c) 2014 wemob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LECropPictureViewController.h"

@interface CameraCropOverlay : UIView

@property(nonatomic) UIView *cropView;
@property (nonatomic, readonly) LECropPictureType cropPictureType;

- (id)initWithFrame:(CGRect)frame backgroundColor:(UIColor*)backgroundColor cropPictureType:(LECropPictureType)cropPictureType andOverlayFrame:(CGRect)overlayViewFrame;
- (void)redrawCropViewWithFrame:(CGRect)cropFrame;


@end
