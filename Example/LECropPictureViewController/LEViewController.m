//
//  LEViewController.m
//  LECropPictureViewController
//
//  Created by Lucas Eduardo on 05/20/2015.
//  Copyright (c) 2014 Lucas Eduardo. All rights reserved.
//

#import "LEViewController.h"
#import <LECropPictureViewController/LECropPictureViewController.h>

@interface LEViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation LEViewController

- (IBAction)showImagePicker:(id)sender {
    
    
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.delegate = self;
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    LECropPictureViewController *cropPictureController = [[LECropPictureViewController alloc] initWithImage:image andCropPictureType:LECropPictureTypeRounded];
    cropPictureController.cropFrame = CGRectMake(50, 50, 250, 250);
    cropPictureController.borderColor = [UIColor grayColor];
    cropPictureController.borderWidth = 1.0;
    
    cropPictureController.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    cropPictureController.photoAcceptedBlock = ^(UIImage *croppedPicture){
        self.imageView.image = croppedPicture;
    };
    
    [self presentViewController:cropPictureController animated:NO completion:nil];
}


@end
