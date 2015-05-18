//
//  CameraRoundOverlay.m
//  Moodcrowd
//
//  Created by Lucas Eduardo on 02/09/14.
//  Copyright (c) 2014 wemob. All rights reserved.
//

#import "CameraRoundOverlay.h"


#define MIN_RESIZE_SIZE 150

@import QuartzCore;


@interface CameraRoundOverlay ()

@property(nonatomic, assign) CGPoint circleCenter;

@end

@implementation CameraRoundOverlay

- (id)initWithFrame:(CGRect)frame andBackgroundColor:(UIColor*)backgroundColor andHoleFrame:(CGRect)holeViewFrame
{
    self = [super initWithFrame:frame];
    if (self) {
        _holeView = [[UIView alloc] initWithFrame:holeViewFrame];
        _holeView.backgroundColor = [UIColor clearColor];
        _holeView.layer.borderColor = [UIColor whiteColor].CGColor;
        _holeView.layer.borderWidth = 2.0;
        [self addSubview:_holeView];
        
        UIPanGestureRecognizer *dragGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragCircleView:)];
        [_holeView addGestureRecognizer:dragGesture];
        
        UIPinchGestureRecognizer *scaleGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(resizeCircleView:)];
        [_holeView addGestureRecognizer:scaleGesture];
        
        
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
    CGRect holeRect = self.holeView.frame;
    CGRect holeRectIntersection = CGRectIntersection( holeRect, rect );
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    if( CGRectIntersectsRect( holeRectIntersection, rect ) )
    {
        CGContextAddEllipseInRect(context, holeRectIntersection);
        CGContextClip(context);
        CGContextClearRect(context, holeRectIntersection);
        CGContextSetFillColorWithColor( context, [UIColor clearColor].CGColor );
        CGContextFillRect( context, holeRectIntersection);
    }
}

-(void)redrawCircleWithFrame:(CGRect)holeFrame
{
    _holeView.frame = holeFrame;
    [self setNeedsDisplay];
}

#pragma mark - Gesture Methods

-(void)dragCircleView:(UIPanGestureRecognizer*)recognizer
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
    [self redrawCircleWithFrame:recognizer.view.frame];
}


-(void)resizeCircleView:(UIPinchGestureRecognizer*)recognizer
{
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.circleCenter = recognizer.view.center;
    }
    
    //get frame of view when applying the scale
    CGAffineTransform newTransform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    CGRect transformedFrame = CGRectApplyAffineTransform(recognizer.view.frame, newTransform);
    
    //Get size of the circle view (wid = hgt, because its a square)
    CGFloat sizeSquare = MIN(self.frame.size.width,  MAX(MIN_RESIZE_SIZE, transformedFrame.size.width));
    recognizer.view.frame = CGRectMake(0.0, 0.0, sizeSquare, sizeSquare);
    
    //Calculating correct center, to never exceed bounds of parent view
    CGFloat offsetWidth = MAX(0, (self.circleCenter.x + sizeSquare/2.0) - self.frame.size.width);
    CGFloat offsetHeight = MAX(0, (self.circleCenter.y + sizeSquare/2.0) - self.frame.size.height);
    CGPoint newCenter = CGPointMake(self.circleCenter.x - offsetWidth, self.circleCenter.y - offsetHeight);
    
    CGFloat offsetOriginX = MAX(0, self.frame.origin.x - (newCenter.x - sizeSquare/2.0));
    CGFloat offsetOriginY = MAX(0, self.frame.origin.y - (newCenter.y - sizeSquare/2.0));
    
    recognizer.view.center = CGPointMake(newCenter.x + offsetOriginX, newCenter.y + offsetOriginY);
    
    //final setup
    recognizer.scale = 1;
    
    //redraw view to update circle
    [self redrawCircleWithFrame:recognizer.view.frame];
}


@end
