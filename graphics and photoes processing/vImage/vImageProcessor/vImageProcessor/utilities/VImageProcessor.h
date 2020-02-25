//
//  VImageProcessor.h
//  vImageProcessor
//
//  Created by Gguomingyue on 2018/3/13.
//  Copyright © 2018年 Gmingyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface VImageProcessor : NSObject

// apply alpha blending for color
+ (CGImageRef _Nullable)alphaBlendingImageWithImage:(CGImageRef)aImage color:(CGColorRef)color;
// apply alpha blending for image
+ (CGImageRef _Nullable)alphaBlendingImageWithImage:(CGImageRef)aImage image:(CGImageRef)bImage point:(CGPoint)point;
// apply scale for size
+ (CGImageRef _Nullable)scaledImageWithImage:(CGImageRef)aImage size:(CGSize)size;
// apply cropping for rect
+ (CGImageRef _Nullable)croppedImageWithImage:(CGImageRef)aImage rect:(CGRect)rect;
// apply vertical or horizontal flipping
+ (CGImageRef _Nullable)flippedImageWithImage:(CGImageRef)aImage horizontal:(BOOL)horizontal;
// apply rotation for radians
+ (CGImageRef _Nullable)rotatedImageWithImage:(CGImageRef)aImage radians:(CGFloat)radians;
// apply vertical or horizontal shearing
+ (CGImageRef _Nullable)shearedImageWithImage:(CGImageRef)aImage horizontal:(BOOL)horizontal offset:(CGVector)offset translation:(CGFloat)translation slope:(CGFloat)slope scale:(CGFloat)scale;
// apply affine transform
+ (CGImageRef _Nullable)affineTransformedImageWithImage:(CGImageRef)aImage transform:(CGAffineTransform)transform;


@end

NS_ASSUME_NONNULL_END
