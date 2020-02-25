//
//  UIImage+Filter.h
//  vImageFilter
//
//  Created by Gguomingyue on 2018/3/20.
//  Copyright © 2018年 Gmingyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Filter)

-(UIImage *)imageByBlur:(CGFloat)blur Saturation:(CGFloat)saturation;
-(UIImage *)imageByBlur:(CGFloat)blur;
-(UIImage *)imageBySaturation:(CGFloat)saturation;

@end
