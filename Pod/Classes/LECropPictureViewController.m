//
//  LECropPictureViewController.m
//
//  Created by Lucas Eduardo on 18/05/15.
//  Copyright (c) 2015 wemob. All rights reserved.
//

#import "LECropPictureViewController.h"
#import "CameraCropOverlay.h"

#import "UIImage+Utils.h"

@interface LECropPictureViewController ()

@property(nonatomic) CameraCropOverlay *overlay;

@end

@implementation LECropPictureViewController


- (instancetype)initWithImage:(UIImage*)image andCropPictureType:(LECropPictureType)cropPictureType
{
    self = [super init];
    if (self) {
        _image = image;
        _cropPictureType = cropPictureType;
        [self loadComponents];
    }
    return self;
}

-(void)loadComponents {
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - 44.0, self.view.frame.size.width, 44.0)];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(didTouchCancelButton)];

    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Accept" style:UIBarButtonItemStylePlain target:self action:@selector(didTouchAcceptButton)];
    
    [toolBar setItems:@[leftButton, flexibleSpace, rightButton]];
    self.cancelButtonItem = leftButton;
    self.acceptButtonItem = rightButton;

    [self.view addSubview:toolBar];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height - 44.0)];
    imageView.image = self.image;
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    
    CGRect frame = imageView.frame;
    self.overlay = [[CameraCropOverlay alloc] initWithFrame:frame
                                          backgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7]
                                            cropPictureType:self.cropPictureType
                                            andOverlayFrame:CGRectMake(20, 40, frame.size.width - 40, frame.size.width - 40)];
    
    self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [imageView addSubview:self.overlay];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - Actions

- (void)didTouchCancelButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didTouchAcceptButton
{
    if (self.photoAcceptedBlock) {
        UIImage *croppedImage = [self.image cropImageInRect:self.overlay.cropView.frame forParentBound:self.overlay.bounds];
        
        if(self.cropPictureType == LECropPictureTypeRounded) {
            croppedImage = [croppedImage imageWithRoundedBounds];
        }
        
        self.photoAcceptedBlock(croppedImage);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
