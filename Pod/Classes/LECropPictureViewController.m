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
@property (nonatomic, weak) UIToolbar *toolBar;

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

    CGFloat scaleFactor = self.image.size.width / self.imageView.frame.size.width;
    CGFloat rectSize = MIN(self.imageView.frame.size.width, floor(self.image.size.height / scaleFactor));
    _cropFrame = CGRectMake((self.imageView.frame.size.width - rectSize) / 2, (self.imageView.frame.size.height - rectSize) / 2, rectSize, rectSize);

    return _cropFrame;
}

-(void)loadComponents {
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    self.toolBar = toolBar;

    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(didTouchCancelButton)];

    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Accept" style:UIBarButtonItemStyleDone target:self action:@selector(didTouchAcceptButton)];

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

    if (@available(iOS 11, *))
    {
        UILayoutGuide *safeAreaLayoutGuide = self.view.safeAreaLayoutGuide;
        [NSLayoutConstraint activateConstraints:@[
                [imageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                [imageView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
                [imageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                [imageView.bottomAnchor constraintEqualToAnchor:toolBar.topAnchor],
                [toolBar.leadingAnchor constraintEqualToAnchor:safeAreaLayoutGuide.leadingAnchor],
                [toolBar.heightAnchor constraintEqualToConstant:toolbarHeight],
                [toolBar.trailingAnchor constraintEqualToAnchor:safeAreaLayoutGuide.trailingAnchor],
                [toolBar.bottomAnchor constraintEqualToAnchor:safeAreaLayoutGuide.bottomAnchor],
        ]];
    }
    else
    {
        [NSLayoutConstraint activateConstraints:@[
                [imageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                [imageView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
                [imageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                [imageView.bottomAnchor constraintEqualToAnchor:toolBar.topAnchor],
                [toolBar.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
                [toolBar.heightAnchor constraintEqualToConstant:toolbarHeight],
                [toolBar.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
                [toolBar.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor],
        ]];
    }
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    if (self.overlay)
    {
        return;
    }

    self.overlay = [[CameraCropOverlay alloc] initWithFrame:self.imageView.frame
                                            backgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7]
                                            cropPictureType:self.cropPictureType
                                            andOverlayFrame:self.cropFrame];
    self.overlay.cropView.layer.borderColor = self.borderColor.CGColor;
    self.overlay.cropView.layer.borderWidth = self.borderWidth;
    self.overlay.translatesAutoresizingMaskIntoConstraints = NO;
    [self.imageView addSubview:self.overlay];

    [NSLayoutConstraint activateConstraints:@[
            [self.overlay.leadingAnchor constraintEqualToAnchor:self.imageView.leadingAnchor],
            [self.overlay.topAnchor constraintEqualToAnchor:self.imageView.topAnchor],
            [self.overlay.trailingAnchor constraintEqualToAnchor:self.imageView.trailingAnchor],
            [self.overlay.bottomAnchor constraintEqualToAnchor:self.imageView.bottomAnchor],
    ]];
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

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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

- (void)setToolBarBarTintColor:(UIColor *)toolBarBarTintColor {
    self.toolBar.barTintColor = toolBarBarTintColor;
    _toolBarBarTintColor = toolBarBarTintColor;
}


- (void)setToolBarTintColor:(UIColor *)toolBarTintColor {
    self.toolBar.tintColor = toolBarTintColor;
    _toolBarTintColor = toolBarTintColor;
}

@end
