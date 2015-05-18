//
//  CameraRoundOverlay.h
//  Moodcrowd
//
//  Created by Lucas Eduardo on 02/09/14.
//  Copyright (c) 2014 wemob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraRoundOverlay : UIView

@property(nonatomic) UIView *holeView;

- (id)initWithFrame:(CGRect)frame andBackgroundColor:(UIColor*)backgroundColor andHoleFrame:(CGRect)holeViewFrame;
- (void)redrawCircleWithFrame:(CGRect)holeFrame;


@end
