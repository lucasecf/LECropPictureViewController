//
//  ViewController.m
//  LEEditPictureControllerDemo
//
//  Created by Lucas Eduardo on 17/05/15.
//  Copyright (c) 2015 Lucas Eduardo. All rights reserved.
//

#import "ViewController.h"
#import "LEEditPictureViewController.h"


@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showImagePucker:(id)sender {
    
    
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
    
    LEEditPictureViewController *editPictureController = [[LEEditPictureViewController alloc] initWithImage:image];
    editPictureController.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    editPictureController.photoAcceptedBlock = ^(UIImage *croppedPicture){
        self.imageView.image = croppedPicture;
    };

    
    [self presentViewController:editPictureController animated:NO completion:nil];
}

@end
