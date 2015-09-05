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

@synthesize cropFrame = _cropFrame;

static const CGFloat toolbarHeight = 44;

- (instancetype)initWithImage:(UIImage*)image andCropPictureType:(LECropPictureType)cropPictureType
{
    self = [super init];
    if (self) {
        _image = image;
        _cropPictureType = cropPictureType;
        
        //default values
        _cropFrame = CGRectNull;
        _borderWidth = 2.0;
        _borderColor = [UIColor whiteColor];
        
        //load subviews
        [self loadComponents];
    }
    return self;
}

- (CGRect)cropFrame {
    if (!CGRectIsNull(_cropFrame)) {
        return _cropFrame;
    }
    
    CGFloat rectSize = MIN(self.view.frame.size.width, self.view.frame.size.height - toolbarHeight) - toolbarHeight;
    return CGRectMake((self.view.frame.size.width - rectSize) / 2 , (self.view.frame.size.height - rectSize - toolbarHeight) / 2, rectSize, rectSize);
}

-(void)loadComponents {
    UIToolbar  *toolBar = [[UIToolbar alloc] init];

    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(didTouchCancelButton)];

    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Accept" style:UIBarButtonItemStylePlain target:self action:@selector(didTouchAcceptButton)];
    
    [toolBar setItems:@[leftButton, flexibleSpace, rightButton]];
    self.cancelButtonItem = leftButton;
    self.acceptButtonItem = rightButton;

    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;

    self.imageView = imageView;

    for (UIView *view in @[imageView, toolBar]) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }

    [self.view addSubview:imageView];
    [self.view addSubview:toolBar];

    NSDictionary *viewsDictionnary = NSDictionaryOfVariableBindings(toolBar, imageView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[imageView][toolBar(%f)]|", toolbarHeight] options:0 metrics:nil views:viewsDictionnary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:nil views:viewsDictionnary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toolBar]|" options:0 metrics:nil views:viewsDictionnary]];
}


- (void)viewDidLayoutSubviews {
    CGRect frame = self.imageView.frame;
    self.overlay = [[CameraCropOverlay alloc] initWithFrame:frame
                                            backgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7]
                                            cropPictureType:self.cropPictureType
                                            andOverlayFrame:self.cropFrame];

    self.overlay.cropView.layer.borderColor = _borderColor.CGColor;
    self.overlay.cropView.layer.borderWidth = _borderWidth;
    self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    if (self.imageView.subviews.firstObject) {
        [self.imageView.subviews.firstObject removeFromSuperview];
    }
    [self.imageView addSubview:self.overlay];
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

#pragma mark - Actions

- (void)didTouchCancelButton
{
    if (self.photoRejectedBlock) {
        self.photoRejectedBlock();
    } else {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
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

#pragma mark - Overrided setters

-(void)setCropFrame:(CGRect)cropFrame {
    [self.overlay redrawCropViewWithFrame:cropFrame];
    _cropFrame = cropFrame;
}

-(void)setBorderWidth:(CGFloat)borderWidth {
    self.overlay.cropView.layer.borderWidth = borderWidth;
    _borderWidth = borderWidth;
}

-(void)setBorderColor:(UIColor *)borderColor {
    self.overlay.cropView.layer.borderColor = borderColor.CGColor;
    _borderColor = borderColor;
}


@end
