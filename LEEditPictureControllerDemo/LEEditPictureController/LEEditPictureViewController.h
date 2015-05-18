//
//  EditPictureViewController.h
//  Moodcrowd
//
//  Created by Lucas Eduardo on 02/09/14.
//  Copyright (c) 2014 wemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEEditPictureViewController : UIViewController

@property (weak, nonatomic) UIBarButtonItem *cancelButtonItem;
@property (weak, nonatomic) UIBarButtonItem *acceptButtonItem;
@property (weak, nonatomic) UIImageView *imageView;

@property (nonatomic) UIImage *image;
@property(copy) void(^photoAcceptedBlock)(UIImage *croppedPicture);

- (instancetype)initWithImage:(UIImage*)image;

@end
