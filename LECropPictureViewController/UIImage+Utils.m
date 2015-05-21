//
//  UIImage+Utils.m
//
//  Created by Lucas Eduardo on 18/05/15.
//  Copyright (c) 2015 wemob. All rights reserved.
//

#import "UIImage+Utils.h"

@implementation UIImage (Utils)


-(UIImage*)cropImageInRect:(CGRect)cropRect forParentBound:(CGRect)parentBounds;
{
    CGRect rect = [self cropRectForFrame:cropRect inBounds:parentBounds];
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    
    // stick to methods on UIImage so that orientation etc. are automatically
    // dealt with for us
    [self drawAtPoint:CGPointMake(-rect.origin.x, -rect.origin.y)];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}


-(UIImage*)imageWithRoundedBounds
{
    CGSize size = self.size;
    CGFloat radius = MIN(size.width, size.height) / 2.0;
    return [self imageWithCornerRadius:radius];
}


-(UIImage*)imageWithCornerRadius:(CGFloat)cornerRadius
{
    return [self imageWithCornerInset:UICornerInsetMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}


#pragma mark - private methods

-(CGRect)cropRectForFrame:(CGRect)frame inBounds:(CGRect)parentBounds
{
    CGFloat widthScale = parentBounds.size.width / self.size.width;
    CGFloat heightScale = parentBounds.size.height / self.size.height;
    
    float x, y, w, h, offset;
    if (widthScale<heightScale) {
        offset = (parentBounds.size.height - (self.size.height*widthScale))/2;
        x = frame.origin.x / widthScale;
        y = (frame.origin.y-offset) / widthScale;
        w = frame.size.width / widthScale;
        h = frame.size.height / widthScale;
    } else {
        offset = (parentBounds.size.width - (self.size.width*heightScale))/2;
        x = (frame.origin.x-offset) / heightScale;
        y = frame.origin.y / heightScale;
        w = frame.size.width / heightScale;
        h = frame.size.height / heightScale;
    }
    return CGRectMake(x, y, w, h);
}


- (UIImage *)imageWithCornerInset:(UICornerInset)cornerInset
{
    if (![self isValidCornerInset:cornerInset])
        return nil;
    
    CGFloat scale = self.scale;
    
    CGRect rect = CGRectMake(0.0f, 0.0f, scale*self.size.width, scale*self.size.height);
    
    cornerInset.topRight *= scale;
    cornerInset.topLeft *= scale;
    cornerInset.bottomLeft *= scale;
    cornerInset.bottomRight *= scale;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, rect.size.width, rect.size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL)
        return nil;
    
    CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
    CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, cornerInset.bottomLeft);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, cornerInset.bottomRight);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, cornerInset.topRight);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, cornerInset.topLeft);
    CGContextClosePath(context);
    CGContextClip(context);
    
    CGContextDrawImage(context, rect, self.CGImage);
    
    CGImageRef bitmapImageRef = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    UIImage *newImage = [UIImage imageWithCGImage:bitmapImageRef scale:scale orientation:UIImageOrientationUp];
    
    CGImageRelease(bitmapImageRef);
    
    return newImage;
}

- (BOOL)isValidCornerInset:(UICornerInset)cornerInset
{
    CGSize size = self.size;
    
    BOOL isValid = YES;
    
    if (cornerInset.topLeft + cornerInset.topRight > size.width)
        isValid = NO;
    
    else if (cornerInset.topRight + cornerInset.bottomRight > size.height)
        isValid = NO;
    
    else if (cornerInset.bottomRight + cornerInset.bottomLeft > size.width)
        isValid = NO;
    
    else if (cornerInset.bottomLeft + cornerInset.topLeft > size.height)
        isValid = NO;
    
    return isValid;
}



@end
