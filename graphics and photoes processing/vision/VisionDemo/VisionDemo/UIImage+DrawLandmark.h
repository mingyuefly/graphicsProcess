//
//  UIImage+DrawLandmark.h
//  VisionDemo
//
//  Created by Gguomingyue on 2018/3/20.
//  Copyright © 2018年 Gmingyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSDetectData.h"

@interface UIImage (DrawLandmark)

- (UIView *)getRectViewWithFrame:(CGRect)frame;
- (UIImage *)drawWithObservation:(VNFaceObservation *)observation pointArray:(NSArray *)pointArray;

@end
