//
//  KCView.m
//  CGBasicGraph
//
//  Created by Gguomingyue on 2017/11/17.
//  Copyright © 2017年 guomingyue. All rights reserved.
//

#import "KCView.h"

@implementation KCView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    //[self drawLine1];
    [self drawLine2];
    
    //[self drawRectWithContext];
    //[self drawRectByUIKit];
    
    //[self drawEllipse];
    //[self drawArc];
    
    //[self drawCurve];
    //[self drawText];
    
    //[self drawImage];
    
    //[self drawLinearGradient];
    //[self drawRedialGradient];
    //[self drawRectWithLinearGradientFill];
    
    //[self drawOverlay];
    //[self drawBackgroundWithColoredPattern];
    //[self drawBackgroundWithPattern];
    
    //[self drawImageTransform];
    //[self drawImage2];
    //[self drawImageTransform2];
}

// 绘制线段
-(void)drawLine1
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 20, 50);
    CGPathAddLineToPoint(path, nil, 20, 100);
    CGPathAddLineToPoint(path, nil, 300, 100);
    
    CGContextAddPath(context, path);
    
    CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1.0);
    CGContextSetRGBFillColor(context, 0, 1.0, 0, 1.0);
    CGContextSetLineWidth(context, 2.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    CGFloat lengths[2] = {18, 9};
    CGContextSetLineDash(context, 0, lengths, 2);
    
    CGColorRef color = [UIColor grayColor].CGColor;
    CGContextSetShadowWithColor(context, CGSizeMake(2, 2), 0.8, color);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGPathRelease(path);
}

-(void)drawLine2
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, 20, 50 + 200);
    CGContextAddLineToPoint(context, 20, 100 + 200);
    CGContextAddLineToPoint(context, 300, 100 + 200);
    
    CGContextClosePath(context);
    [[UIColor redColor] setStroke];
    [[UIColor greenColor] setFill];
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

// 绘制矩形
-(void)drawRectWithContext
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect=CGRectMake(20, 50, 280.0, 50.0);
    CGContextAddRect(context, rect);
    
    [[UIColor blueColor] set];
    //[[UIColor redColor] setStroke];
    //[[UIColor greenColor] setFill];
    UIRectFill(rect);
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

//
-(void)drawRectByUIKit
{
    CGRect rect= CGRectMake(20, 150, 280.0, 50.0);
    CGRect rect2=CGRectMake(20, 250, 280.0, 50.0);
    
    [[UIColor yellowColor] set];
    UIRectFill(rect);
    
    [[UIColor redColor] setStroke];
    UIRectFrame(rect2);
}

// 绘制椭圆
-(void)drawEllipse
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect=CGRectMake(50, 50, 220.0, 200.0);
    CGContextAddEllipseInRect(context, rect);
    
    [[UIColor purpleColor] set];
    CGContextDrawPath(context, kCGPathFillStroke);
}

// 绘制弧线
-(void)drawArc
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextAddArc(context, 160, 160, 100, 0, M_PI_2, 1);
    [[UIColor yellowColor] set];
    CGContextFillPath(context);
    
    CGContextRestoreGState(context);
    //CGContextSetRGBSColor(context, 1.0, 0, 0, 1.0);
    //CGContextMoveToPoint(context,150,350);
    //CGContextAddLineToPoint(context,100,380);
    //CGContextAddLineToPoint(context,130,450);
    CGContextMoveToPoint(context, 150, 350);
    CGContextAddArcToPoint(context, 100, 380, 130, 450, 50);
    [[UIColor redColor] set];
    //CGContextStrokePath(context);
    CGContextFillPath(context);
    
    //[[UIColor blueColor] set];
    CGContextDrawPath(context, kCGPathFillStroke);
}

// 绘制贝塞尔曲线
-(void)drawCurve
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 20, 100);
    
    CGContextAddQuadCurveToPoint(context, 120, 0, 300, 100);
    
    CGContextMoveToPoint(context, 20, 500);
    CGContextAddCurveToPoint(context, 60, 200, 400, 550, 300, 300);
    
    [[UIColor yellowColor] setFill];
    [[UIColor redColor] setStroke];
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

// 文字绘制
-(void)drawText
{
    //CGContextRef context = UIGraphicsGetCurrentContext();
    NSString *str=@"Star Walk is the most beautiful stargazing app you’ve ever seen on a mobile device. It will become your go-to interactive astro guide to the night sky, following your every movement in real-time and allowing you to explore over 200, 000 celestial bodies with extensive information about stars and constellations that you find.";
    CGRect rect= CGRectMake(20, 50, 280, 300);
    UIFont *font = [UIFont systemFontOfSize:18];
    UIColor *color = [UIColor redColor];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    NSTextAlignment align = NSTextAlignmentLeft;
    style.alignment = align;
    [str drawInRect:rect withAttributes:@{
                                          NSFontAttributeName:font,
                                          NSForegroundColorAttributeName:color,
                                          NSParagraphStyleAttributeName:style
                                          }];
}

// 图像绘制
-(void)drawImage
{
    UIImage *image = [UIImage imageNamed:@"ice1.jpeg"];
    //[image drawAtPoint:CGPointMake(10, 50)];
    
    //[image drawInRect:CGRectMake(10, 50, 200, 200)];
    
    // 平铺
    [image drawAsPatternInRect:CGRectMake(0, 0, 375, 667)];
}

// 绘制渐变填充
//线性渐变
-(void)drawLinearGradient
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat compoents[12]={
        248.0/255.0,86.0/255.0,86.0/255.0,1,
        249.0/255.0,127.0/255.0,127.0/255.0,1,
        1.0,1.0,1.0,1.0
    };
    CGFloat locations[3] = {0,0.3,1.0};
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, compoents, locations, 3);
    
    CGContextDrawLinearGradient(context, gradient, CGPointZero, CGPointMake(320, 300), kCGGradientDrawsAfterEndLocation);//kCGGradientDrawsBeforeStartLocation
    
    CGColorSpaceRelease(colorSpace);
}

//径向渐变
-(void)drawRedialGradient
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat compoents[12]={
        248.0/255.0,86.0/255.0,86.0/255.0,1,
        249.0/255.0,127.0/255.0,127.0/255.0,1,
        1.0,1.0,1.0,1.0
    };
    CGFloat locations[3] = {0,0.3,1.0};
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, compoents, locations, 3);
    
    CGContextDrawRadialGradient(context, gradient, CGPointMake(160, 284),0, CGPointMake(165, 289), 150, kCGGradientDrawsAfterEndLocation);
    CGColorSpaceRelease(colorSpace);
}

// 扩展渐变填充
-(void)drawRectWithLinearGradientFill
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //裁切处一块矩形用于显示，注意必须先裁切再调用渐变
    //CGContextClipToRect(context, CGRectMake(20, 50, 280, 300));
    //裁切还可以使用UIKit中对应的方法
    UIRectClip(CGRectMake(20, 50, 280, 300));
    
    CGFloat compoents[12]={
        248.0/255.0,86.0/255.0,86.0/255.0,1,
        249.0/255.0,127.0/255.0,127.0/255.0,1,
        1.0,1.0,1.0,1.0
    };
    CGFloat locations[3]={0,0.3,1.0};
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, compoents, locations, 3);
    
    CGContextDrawLinearGradient(context, gradient, CGPointMake(20, 50), CGPointMake(300, 300), kCGGradientDrawsAfterEndLocation);
    
    CGColorSpaceRelease(colorSpace);
}

// 叠加设置
-(void)drawOverlay{
    CGRect rect= CGRectMake(0, 130.0, 320.0, 50.0);
    CGRect rect1= CGRectMake(0, 390.0, 320.0, 50.0);
    
    
    CGRect rect2=CGRectMake(20, 50.0, 10.0, 250.0);
    CGRect rect3=CGRectMake(40.0, 50.0, 10.0, 250.0);
    CGRect rect4=CGRectMake(60.0, 50.0, 10.0, 250.0);
    CGRect rect5=CGRectMake(80.0, 50.0, 10.0, 250.0);
    CGRect rect6=CGRectMake(100.0, 50.0, 10.0, 250.0);
    CGRect rect7=CGRectMake(120.0, 50.0, 10.0, 250.0);
    CGRect rect8=CGRectMake(140.0, 50.0, 10.0, 250.0);
    CGRect rect9=CGRectMake(160.0, 50.0, 10.0, 250.0);
    CGRect rect10=CGRectMake(180.0, 50.0, 10.0, 250.0);
    CGRect rect11=CGRectMake(200.0, 50.0, 10.0, 250.0);
    CGRect rect12=CGRectMake(220.0, 50.0, 10.0, 250.0);
    CGRect rect13=CGRectMake(240.0, 50.0, 10.0, 250.0);
    CGRect rect14=CGRectMake(260.0, 50.0, 10.0, 250.0);
    CGRect rect15=CGRectMake(280.0, 50.0, 10.0, 250.0);
    
    CGRect rect16=CGRectMake(30.0, 310.0, 10.0, 250.0);
    CGRect rect17=CGRectMake(50.0, 310.0, 10.0, 250.0);
    CGRect rect18=CGRectMake(70.0, 310.0, 10.0, 250.0);
    CGRect rect19=CGRectMake(90.0, 310.0, 10.0, 250.0);
    CGRect rect20=CGRectMake(110.0, 310.0, 10.0, 250.0);
    CGRect rect21=CGRectMake(130.0, 310.0, 10.0, 250.0);
    CGRect rect22=CGRectMake(150.0, 310.0, 10.0, 250.0);
    CGRect rect23=CGRectMake(170.0, 310.0, 10.0, 250.0);
    CGRect rect24=CGRectMake(190.0, 310.0, 10.0, 250.0);
    CGRect rect25=CGRectMake(210.0, 310.0, 10.0, 250.0);
    CGRect rect26=CGRectMake(230.0, 310.0, 10.0, 250.0);
    CGRect rect27=CGRectMake(250.0, 310.0, 10.0, 250.0);
    CGRect rect28=CGRectMake(270.0, 310.0, 10.0, 250.0);
    CGRect rect29=CGRectMake(290.0, 310.0, 10.0, 250.0);
    
    
    [[UIColor yellowColor]set];
    UIRectFill(rect);
    
    [[UIColor greenColor]setFill];
    UIRectFill(rect1);
    
    [[UIColor redColor]setFill];
    UIRectFillUsingBlendMode(rect2, kCGBlendModeClear);
    UIRectFillUsingBlendMode(rect3, kCGBlendModeColor);
    UIRectFillUsingBlendMode(rect4, kCGBlendModeColorBurn);
    UIRectFillUsingBlendMode(rect5, kCGBlendModeColorDodge);
    UIRectFillUsingBlendMode(rect6, kCGBlendModeCopy);
    UIRectFillUsingBlendMode(rect7, kCGBlendModeDarken);
    UIRectFillUsingBlendMode(rect8, kCGBlendModeDestinationAtop);
    UIRectFillUsingBlendMode(rect9, kCGBlendModeDestinationIn);
    UIRectFillUsingBlendMode(rect10, kCGBlendModeDestinationOut);
    UIRectFillUsingBlendMode(rect11, kCGBlendModeDestinationOver);
    UIRectFillUsingBlendMode(rect12, kCGBlendModeDifference);
    UIRectFillUsingBlendMode(rect13, kCGBlendModeExclusion);
    UIRectFillUsingBlendMode(rect14, kCGBlendModeHardLight);
    UIRectFillUsingBlendMode(rect15, kCGBlendModeHue);
    UIRectFillUsingBlendMode(rect16, kCGBlendModeLighten);
    
    UIRectFillUsingBlendMode(rect17, kCGBlendModeLuminosity);
    UIRectFillUsingBlendMode(rect18, kCGBlendModeMultiply);
    UIRectFillUsingBlendMode(rect19, kCGBlendModeNormal);
    UIRectFillUsingBlendMode(rect20, kCGBlendModeOverlay);
    UIRectFillUsingBlendMode(rect21, kCGBlendModePlusDarker);
    UIRectFillUsingBlendMode(rect22, kCGBlendModePlusLighter);
    UIRectFillUsingBlendMode(rect23, kCGBlendModeSaturation);
    UIRectFillUsingBlendMode(rect24, kCGBlendModeScreen);
    UIRectFillUsingBlendMode(rect25, kCGBlendModeSoftLight);
    UIRectFillUsingBlendMode(rect26, kCGBlendModeSourceAtop);
    UIRectFillUsingBlendMode(rect27, kCGBlendModeSourceIn);
    UIRectFillUsingBlendMode(rect28, kCGBlendModeSourceOut);
    UIRectFillUsingBlendMode(rect29, kCGBlendModeXOR);
}

// 颜色填充模式
// 有颜色填充模式
#define TILE_SIZE 20

void drawColoredTile(void *info,CGContextRef context){
    //有颜色填充，这里设置填充色
    CGContextSetRGBFillColor(context, 254.0/255.0, 52.0/255.0, 90.0/255.0, 1);
    CGContextFillRect(context, CGRectMake(0, 0, TILE_SIZE, TILE_SIZE));
    CGContextFillRect(context, CGRectMake(TILE_SIZE, TILE_SIZE, TILE_SIZE, TILE_SIZE));
}
-(void)drawBackgroundWithColoredPattern
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设备无关的颜色空间
    //    CGColorSpaceRef rgbSpace= CGColorSpaceCreateDeviceRGB();
    //模式填充颜色空间,注意对于有颜色填充模式，这里传NULL
    CGColorSpaceRef colorSpace=CGColorSpaceCreatePattern(NULL);
    //将填充色颜色空间设置为模式填充的颜色空间
    CGContextSetFillColorSpace(context, colorSpace);
    
    //填充模式回调函数结构体
    CGPatternCallbacks callback={0,&drawColoredTile,NULL};
    /*填充模式
     info://传递给callback的参数
     bounds:瓷砖大小
     matrix:形变
     xStep:瓷砖横向间距
     yStep:瓷砖纵向间距
     tiling:贴砖的方法
     isClored:绘制的瓷砖是否已经指定了颜色(对于有颜色瓷砖此处指定位true)
     callbacks:回调函数
     */
    CGPatternRef pattern=CGPatternCreate(NULL, CGRectMake(0, 0, 2*TILE_SIZE, 2*TILE_SIZE), CGAffineTransformIdentity,2*TILE_SIZE+ 5,2*TILE_SIZE+ 5, kCGPatternTilingNoDistortion, true, &callback);
    
    CGFloat alpha=1;
    //注意最后一个参数对于有颜色瓷砖指定为透明度的参数地址，对于无颜色瓷砖则指定当前颜色空间对应的颜色数组
    CGContextSetFillPattern(context, pattern, &alpha);
    
    UIRectFill(CGRectMake(0, 0, 320, 568));
    
    //    CGColorSpaceRelease(rgbSpace);
    CGColorSpaceRelease(colorSpace);
    CGPatternRelease(pattern);
}

// 无颜色填充模式
void drawTile(void *info,CGContextRef context){
    CGContextFillRect(context, CGRectMake(0, 0, TILE_SIZE, TILE_SIZE));
    CGContextFillRect(context, CGRectMake(TILE_SIZE, TILE_SIZE, TILE_SIZE, TILE_SIZE));
}
-(void)drawBackgroundWithPattern{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设备无关的颜色空间
    CGColorSpaceRef rgbSpace= CGColorSpaceCreateDeviceRGB();
    //模式填充颜色空间
    CGColorSpaceRef colorSpace=CGColorSpaceCreatePattern(rgbSpace);
    //将填充色颜色空间设置为模式填充的颜色空间
    CGContextSetFillColorSpace(context, colorSpace);
    
    //填充模式回调函数结构体
    CGPatternCallbacks callback={0,&drawTile,NULL};
    /*填充模式
     info://传递给callback的参数
     bounds:瓷砖大小
     matrix:形变
     xStep:瓷砖横向间距
     yStep:瓷砖纵向间距
     tiling:贴砖的方法（瓷砖摆放的方式）
     isClored:绘制的瓷砖是否已经指定了颜色（对于无颜色瓷砖此处指定位false）
     callbacks:回调函数
     */
    CGPatternRef pattern=CGPatternCreate(NULL, CGRectMake(0, 0, 2*TILE_SIZE, 2*TILE_SIZE), CGAffineTransformIdentity,2*TILE_SIZE+ 5,2*TILE_SIZE+ 5, kCGPatternTilingNoDistortion, false, &callback);
    
    CGFloat components[]={254.0/255.0,52.0/255.0,90.0/255.0,1.0};
    //注意最后一个参数对于无颜色填充模式指定为当前颜色空间颜色数据
    CGContextSetFillPattern(context, pattern, components);
    //    CGContextSetStrokePattern(context, pattern, components);
    UIRectFill(CGRectMake(0, 0, 320, 568));
    
    CGColorSpaceRelease(rgbSpace);
    CGColorSpaceRelease(colorSpace);
    CGPatternRelease(pattern);
}

// 上下文变换
-(void)drawImageTransform
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, 100, 0);
    CGContextScaleCTM(context, 0.8, 0.8);
    CGContextRotateCTM(context, M_PI_4/4);
    
    UIImage *image = [UIImage imageNamed:@"ice1.jpeg"];
    [image drawInRect:CGRectMake(0, 50, 240, 300)];
    
    CGContextRestoreGState(context);
}

-(void)drawImage2
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *image = [UIImage imageNamed:@"ice1.jpeg"];
    
    CGRect rect= CGRectMake(10, 50, 300, 450);
    CGContextDrawImage(context, rect, image.CGImage);
}

-(void)drawImageTransform2
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *image = [UIImage imageNamed:@"ice1.jpeg"];
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGContextSaveGState(context);
    CGFloat height = 450, y = 50;
    
    // 上下文变形
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0, -(size.height-(size.height-2*y-height)));
    
    // 图形绘制
    CGRect rect= CGRectMake(10, y, 300, height);
    CGContextDrawImage(context, rect, image.CGImage);
    
    CGContextRestoreGState(context);
}

// 绘制图像到位图











@end
