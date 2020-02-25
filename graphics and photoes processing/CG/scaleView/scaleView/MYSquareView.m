//
//  MYSquareView.m
//  scaleView
//
//  Created by Gguomingyue on 2018/1/24.
//  Copyright © 2018年 Gguomingyue. All rights reserved.
//

#import "MYSquareView.h"

@implementation MYSquareView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat intervalLength = self.frame.size.width/3;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    for (int i = 0; i < 4; i++) {
        // four horizonal lines
        if (i == 3) {
            CGContextMoveToPoint(context, 0 + 3.0f, 0 + i * intervalLength - 1.0f - 3.0f);
            CGContextAddLineToPoint(context, width - 2 * 3.0f, 0 + i * intervalLength - 1.0f - 3.0f);
        } else if (i == 0) {
            CGContextMoveToPoint(context, 0 + 3.0f, 0 + i * intervalLength + 1.0f + 3.0f);
            CGContextAddLineToPoint(context, width - 6.0f, 0 + i * intervalLength + 1.0f + 3.0f);
        } else {
            CGContextMoveToPoint(context, 0 + 3.0f, 0 + i * intervalLength);
            CGContextAddLineToPoint(context, width - 6.0f, 0 + i * intervalLength);
        }
        
        // four vertical lines
        if (i == 3) {
            CGContextMoveToPoint(context, 0 + i * intervalLength - 1.0f - 3.0f, 0 + 3.0f);
            CGContextAddLineToPoint(context, 0 + i * intervalLength - 1.0f - 3.0f, height - 6.0f);
        } else if (i == 0) {
            CGContextMoveToPoint(context, 0 + i * intervalLength + 1.0f + 3.0f, 0 + 3.0f);
            CGContextAddLineToPoint(context, 0 + i * intervalLength + 1.0f + 3.0f, height - 6.0f);
        } else {
            CGContextMoveToPoint(context, 0 + i * intervalLength, 0 + 3.0f);
            CGContextAddLineToPoint(context, 0 + i * intervalLength, height - 6.0f);
        }
        
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 2.0f);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextDrawPath(context, kCGPathStroke);
        
        // four curves
        switch (i) {
            case 0:
            {
                
            }
                break;
            case 1:
            {
                
            }
                break;
            case 2:
            {
                
            }
                break;
            case 3:
            {
                
            }
                break;
            default:
                break;
        }
        
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(context, 2.0f);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextDrawPath(context, kCGPathStroke);
        
    }
    
    
}


@end
