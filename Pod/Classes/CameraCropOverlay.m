//
//  CameraCropOverlay.m
//
//  Created by Lucas Eduardo on 18/05/15.
//  Copyright (c) 2015 wemob. All rights reserved.
//

#import "CameraCropOverlay.h"


#define MIN_RESIZE_SIZE 150

@import QuartzCore;


@interface CameraCropOverlay ()

@property(nonatomic, assign) CGPoint cropCenter;

@end

@implementation CameraCropOverlay

- (id)initWithFrame:(CGRect)frame backgroundColor:(UIColor*)backgroundColor cropPictureType:(LECropPictureType)cropPictureType andOverlayFrame:(CGRect)overlayViewFrame
{
    self = [super initWithFrame:frame];
    if (self) {
        _cropPictureType = cropPictureType;
        
        _cropView = [[UIView alloc] initWithFrame:overlayViewFrame];
        _cropView.backgroundColor = [UIColor clearColor];
        [self addSubview:_cropView];
        
        UIPanGestureRecognizer *dragGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragCropView:)];
        [_cropView addGestureRecognizer:dragGesture];
        
        UIPinchGestureRecognizer *scaleGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(resizeCropView:)];
        [_cropView addGestureRecognizer:scaleGesture];
        
        self.opaque = NO;
        self.backgroundColor = backgroundColor;
    }
    return self;
}

#pragma mark - Draw methods

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self.backgroundColor setFill];
    UIRectFill(rect);
    
    // clear the background in the given rectangles
    CGRect cropRect = self.cropView.frame;
    CGRect cropRectIntersection = CGRectIntersection(cropRect, rect);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if( CGRectIntersectsRect( cropRectIntersection, rect ) )
    {
        if(self.cropPictureType == LECropPictureTypeRounded) {
            CGContextAddEllipseInRect(context, cropRectIntersection);
            CGContextClip(context);
        }

        CGContextClearRect(context, cropRectIntersection);
        CGContextSetFillColorWithColor( context, [UIColor clearColor].CGColor );
        CGContextFillRect( context, cropRectIntersection);
    }
}

-(void)redrawCropViewWithFrame:(CGRect)cropFrame
{
    _cropView.frame = cropFrame;
    [self setNeedsDisplay];
}

#pragma mark - Gesture Methods

-(void)dragCropView:(UIPanGestureRecognizer*)recognizer
{
    //getting translated center point
    CGPoint translation = [recognizer translationInView:self];
    CGPoint viewPosition = recognizer.view.center;
    viewPosition.x += translation.x;
    viewPosition.y += translation.y;
    
    //validating position of translated point, to not exceed the parents bounds
    CGFloat upperBound = recognizer.view.bounds.size.height/2.0;
    CGFloat leftBound = recognizer.view.bounds.size.width/2.0;
    CGFloat rightBound = self.bounds.size.width - recognizer.view.bounds.size.width/2.0;
    CGFloat bottomBound = self.bounds.size.height - recognizer.view.bounds.size.height/2.0;
    
    viewPosition.x = MIN(MAX(viewPosition.x, leftBound), rightBound);
    viewPosition.y = MIN(MAX(viewPosition.y, upperBound), bottomBound);
    
    //new center
    recognizer.view.center = viewPosition;
    [recognizer setTranslation:CGPointZero inView:self];
    
    //redraw view to update circle
    [self redrawCropViewWithFrame:recognizer.view.frame];
}


-(void)resizeCropView:(UIPinchGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.cropCenter = recognizer.view.center;
    }
    
    //get frame of view when applying the scale
    CGAffineTransform newTransform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    CGRect transformedFrame = CGRectApplyAffineTransform(recognizer.view.frame, newTransform);
    if (self.cropPictureType == LECropPictureTypeRounded) { // preserve aspect ratio of 1:1
        CGFloat maxSize = MIN(self.superview.frame.size.height, self.superview.frame.size.width);
        CGFloat transformedMaxSize = MIN(transformedFrame.size.width, transformedFrame.size.height);
        CGFloat transformedMinedSize = MIN(transformedMaxSize, maxSize);
        transformedFrame = CGRectMake(transformedFrame.origin.x, transformedFrame.origin.y, transformedMinedSize, transformedMinedSize);
    }
    
    //Get size of the circle view (wid = hgt, because its a square)
    CGFloat sizeSquare = MIN(self.frame.size.width,  MAX(MIN_RESIZE_SIZE, transformedFrame.size.width));
    recognizer.view.frame = CGRectMake(0.0, 0.0, sizeSquare, sizeSquare);
    
    //Calculating correct center, to never exceed bounds of parent view
    CGFloat offsetWidth = MAX(0, (self.cropCenter.x + sizeSquare/2.0) - self.frame.size.width);
    CGFloat offsetHeight = MAX(0, (self.cropCenter.y + sizeSquare/2.0) - self.frame.size.height);
    CGPoint newCenter = CGPointMake(self.cropCenter.x - offsetWidth, self.cropCenter.y - offsetHeight);
    
    CGFloat offsetOriginX = MAX(0, self.frame.origin.x - (newCenter.x - sizeSquare/2.0));
    CGFloat offsetOriginY = MAX(0, self.frame.origin.y - (newCenter.y - sizeSquare/2.0));
    
    recognizer.view.center = CGPointMake(newCenter.x + offsetOriginX, newCenter.y + offsetOriginY);
    
    //final setup
    recognizer.scale = 1;
    
    //redraw view to update circle
    [self redrawCropViewWithFrame:recognizer.view.frame];
}


@end
