//
//  UIImage+Utils.h
//
//  Created by Lucas Eduardo on 18/05/15.
//  Copyright (c) 2015 wemob. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
    CODE FOR ROUND RECT METHODS
 */

typedef struct __UICornerInset
{
    CGFloat topLeft;
    CGFloat topRight;
    CGFloat bottomLeft;
    CGFloat bottomRight;
} UICornerInset;

UIKIT_STATIC_INLINE UICornerInset UICornerInsetMake(CGFloat topLeft, CGFloat topRight, CGFloat bottomLeft, CGFloat bottomRight)
{
    UICornerInset cornerInset = {topLeft, topRight, bottomLeft, bottomRight};
    return cornerInset;
}

/*
    INTERFACE OF CATEGORY
 */

@interface UIImage (Utils)

- (UIImage*)cropImageInRect:(CGRect)cropRect forParentBound:(CGRect)parentBounds;
- (UIImage*)imageWithRoundedBounds;
- (UIImage*)imageWithCornerRadius:(CGFloat)cornerRadius;

@end
