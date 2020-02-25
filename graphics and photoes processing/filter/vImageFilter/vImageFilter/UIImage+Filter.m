//
//  UIImage+Filter.m
//  vImageFilter
//
//  Created by Gguomingyue on 2018/3/20.
//  Copyright © 2018年 Gmingyue. All rights reserved.
//

#import "UIImage+Filter.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (Filter)

#define SWAP(_a_, _b_)  do { __typeof__(_a_) _tmp_ = (_a_); (_a_) = (_b_); (_b_) = _tmp_; } while (0)

-(UIImage *)imageByBlur:(CGFloat)blur Saturation:(CGFloat)saturation
{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef imageRef = self.CGImage;
    vImage_Buffer input_buffer, output_buffer;
    vImage_Error error;
    
    void *pixelBuffer;
    CGDataProviderRef inProvider = CGImageGetDataProvider(imageRef);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    input_buffer.width = CGImageGetWidth(imageRef);
    input_buffer.height = CGImageGetHeight(imageRef);
    input_buffer.rowBytes = CGImageGetBytesPerRow(imageRef);
    input_buffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(imageRef) *
                         CGImageGetHeight(imageRef));
    
    if (pixelBuffer == NULL) {
        NSLog(@"No pixelbuffer");
    }
    
    output_buffer.data = pixelBuffer;
    output_buffer.width = CGImageGetWidth(imageRef);
    output_buffer.height = CGImageGetHeight(imageRef);
    output_buffer.rowBytes = CGImageGetBytesPerRow(imageRef);
    
    error = vImageBoxConvolve_ARGB8888(&input_buffer, &output_buffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    SWAP(input_buffer, output_buffer);
    if (saturation < 0.f || saturation > 2.f) {
        saturation = 1.0f;
    }
    
    CGFloat s = saturation;
    CGFloat matrixFloat[] = {
        0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
        0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
        0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
        0,                    0,                    0,                    1,
    };
    const int32_t divisor = 256;
    NSUInteger matrixSize = sizeof(matrixFloat) / sizeof(matrixFloat[0]);
    int16_t matrix[matrixSize];
    for (NSUInteger i = 0; i < matrixSize; ++i) {
        matrix[i] = (int16_t)roundf(matrixFloat[i] * divisor);
    }
    
    error = vImageMatrixMultiply_ARGB8888(&input_buffer, &output_buffer, matrix, divisor, NULL, NULL, kvImageNoFlags);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             output_buffer.data,
                                             output_buffer.width,
                                             output_buffer.height,
                                             8,
                                             output_buffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef returnImageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:returnImageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(returnImageRef);
    
    
    return returnImage;
}

-(UIImage *)imageByBlur:(CGFloat)blur
{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef imageRef = self.CGImage;
    vImage_Buffer input_buffer, output_buffer;
    vImage_Error error;
    
    void *pixelBuffer;
    CGDataProviderRef inProvider = CGImageGetDataProvider(imageRef);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    input_buffer.width = CGImageGetWidth(imageRef);
    input_buffer.height = CGImageGetHeight(imageRef);
    input_buffer.rowBytes = CGImageGetBytesPerRow(imageRef);
    input_buffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(imageRef) *
                         CGImageGetHeight(imageRef));
    
    if (pixelBuffer == NULL) {
        NSLog(@"No pixelbuffer");
    }
    
    output_buffer.data = pixelBuffer;
    output_buffer.width = CGImageGetWidth(imageRef);
    output_buffer.height = CGImageGetHeight(imageRef);
    output_buffer.rowBytes = CGImageGetBytesPerRow(imageRef);
    
    error = vImageBoxConvolve_ARGB8888(&input_buffer, &output_buffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             output_buffer.data,
                                             output_buffer.width,
                                             output_buffer.height,
                                             8,
                                             output_buffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef returnImageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:returnImageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(returnImageRef);
    
    
    return returnImage;
}

-(UIImage *)imageBySaturation:(CGFloat)saturation
{
    if (saturation < 0.f || saturation > 2.f) {
        saturation = 1.0f;
    }
    
    CGImageRef imageRef = self.CGImage;
    vImage_Buffer input_buffer, output_buffer;
    vImage_Error error;
    
    void *pixelBuffer;
    CGDataProviderRef inProvider = CGImageGetDataProvider(imageRef);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    input_buffer.width = CGImageGetWidth(imageRef);
    input_buffer.height = CGImageGetHeight(imageRef);
    input_buffer.rowBytes = CGImageGetBytesPerRow(imageRef);
    input_buffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(imageRef) *
                         CGImageGetHeight(imageRef));
    
    if (pixelBuffer == NULL) {
        NSLog(@"No pixelbuffer");
    }
    
    output_buffer.data = pixelBuffer;
    output_buffer.width = CGImageGetWidth(imageRef);
    output_buffer.height = CGImageGetHeight(imageRef);
    output_buffer.rowBytes = CGImageGetBytesPerRow(imageRef);
    
    CGFloat s = saturation;
    CGFloat matrixFloat[] = {
        0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
        0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
        0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
        0,                    0,                    0,                    1,
    };
    const int32_t divisor = 256;
    NSUInteger matrixSize = sizeof(matrixFloat) / sizeof(matrixFloat[0]);
    int16_t matrix[matrixSize];
    for (NSUInteger i = 0; i < matrixSize; ++i) {
        matrix[i] = (int16_t)roundf(matrixFloat[i] * divisor);
    }
    
    error = vImageMatrixMultiply_ARGB8888(&input_buffer, &output_buffer, matrix, divisor, NULL, NULL, kvImageNoFlags);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             output_buffer.data,
                                             output_buffer.width,
                                             output_buffer.height,
                                             8,
                                             output_buffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef returnImageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:returnImageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(returnImageRef);
    
    
    return returnImage;
}


@end
