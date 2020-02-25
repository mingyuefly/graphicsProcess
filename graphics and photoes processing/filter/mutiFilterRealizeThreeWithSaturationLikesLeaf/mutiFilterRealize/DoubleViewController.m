//
//  DoubleViewController.m
//  mutiFilterRealize
//
//  Created by Gguomingyue on 2018/1/17.
//  Copyright © 2018年 Gguomingyue. All rights reserved.
//

#import "DoubleViewController.h"
#import <OpenGLES/ES2/gl.h>
#import "MYShaderCompiler.h"
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, FilterType){
    DefaultType          = 0,
    BrightType           = 1,
    SaturationType       = 2
};

@interface DoubleViewController ()
{
    EAGLContext *_eaglContext;
    CAEAGLLayer *_eaglLayer;
    
    GLuint _renderBuffer;
    GLuint _renderPositionSlot;
    GLuint _renderTextureSlot;
    GLuint _renderTextureCoordSlot;
    
    GLuint _offscreenFramebuffer;
    GLuint offscreenTexture;
    
    GLuint _saturation;
    GLuint _saturationPositionSlot;
    GLuint _saturationTextureSlot;
    GLuint _saturationTextureCoordSlot;
    
    GLuint _brightness;
    GLuint _brightnessPositionSlot;
    GLuint _brightnessTextureSlot;
    GLuint _brightnessTextureCoordSlot;
    
    GLuint _frameBuffer;
    
    GLuint _brightnessFramebuffer;
    GLuint brightnessTexture;
    
    GLuint _saturationFramebuffer;
    GLuint saturationTexture;
    
    UIImage *processImage;
    GLint width;
    GLint height;
    GLuint originalTexture;
    
    MYShaderCompiler *renderShader;
    MYShaderCompiler *brightnessShader;
    MYShaderCompiler *saturationShader;
    
    FilterType filterType;
}

@property (weak, nonatomic) IBOutlet UIButton *getImageButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UILabel *saturationLabel;
@property (weak, nonatomic) IBOutlet UILabel *brightnessLabel;
@property (weak, nonatomic) IBOutlet UISlider *saturationSlider;
- (IBAction)saturationSliderAction:(UISlider *)sender;
@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;
- (IBAction)brightnessSliderAction:(UISlider *)sender;

@end

@implementation DoubleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupContext];
    processImage = [UIImage imageNamed:@"wuyanzu.jpg"];
    originalTexture = [self getTextureFromImage:processImage];
    
    [self setupCAEAGLayer:self.view.bounds];
    
    [self clearRenderBuffers];
    [self createOffscreenBuffer:processImage];
    [self createBrightnessFrameBuffer:processImage];
    [self createSaturationFrameBuffer:processImage];
    [self setupRenderBuffers];
    
    [self setupRenderScreenViewPort];
    
    [self setupBrightnessShader];
    [self setupSaturationShader];
    [self setupRenderShader];
    
    [self renderToScreenWithTexture:originalTexture];
    [self originalBrightnessTextureAndSaturationTexture];

    filterType = DefaultType;
}

#pragma mark - setup GLES
// step1
-(void)setupContext
{
    _eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:_eaglContext];
}

// step2
-(void)setupCAEAGLayer:(CGRect)rect
{
    _eaglLayer = [CAEAGLLayer layer];
    _eaglLayer.frame = rect;
    _eaglLayer.backgroundColor = [UIColor yellowColor].CGColor;
    _eaglLayer.opaque = YES;
    
    _eaglLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking:@(NO),kEAGLDrawablePropertyColorFormat:kEAGLColorFormatRGBA8};
    [self.view.layer addSublayer:_eaglLayer];
    [self.view bringSubviewToFront:self.brightnessSlider];
    [self.view bringSubviewToFront:self.getImageButton];
    [self.view bringSubviewToFront:self.resetButton];
    [self.view bringSubviewToFront:self.saturationSlider];
    [self.view bringSubviewToFront:self.saturationLabel];
    [self.view bringSubviewToFront:self.brightnessLabel];
}

// step3
-(void)clearRenderBuffers
{
    if (_renderBuffer) {
        glDeleteRenderbuffers(1, &_renderBuffer);
        _renderBuffer = 0;
    }
    if (_frameBuffer) {
        glDeleteFramebuffers(1, &_frameBuffer);
        _frameBuffer = 0;
    }
}

// step4
-(void)setupRenderBuffers
{
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    glGenRenderbuffers(1, &_renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);
    [_eaglContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &width);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &height);
    
    // check success
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"Failed to make complete framebuffer object: %i", glCheckFramebufferStatus(GL_FRAMEBUFFER));
    }
}

-(void)createBrightnessFrameBuffer:(UIImage *)image
{
    glGenFramebuffers(1, &_brightnessFramebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _brightnessFramebuffer);
    
    // create the texture
    glGenTextures(1, &brightnessTexture);
    glBindTexture(GL_TEXTURE_2D, brightnessTexture);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, image.size.width, image.size.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    // Bind the texture to your FBO
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, brightnessTexture, 0);
    
    // Test if everything failed
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        printf("failed to make complete framebuffer object %x", status);
    }
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glBindTexture(GL_TEXTURE_2D, 0);
}

-(void)createSaturationFrameBuffer:(UIImage *)image
{
    glGenFramebuffers(1, &_saturationFramebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _saturationFramebuffer);
    
    // create the texture
    glGenTextures(1, &saturationTexture);
    glBindTexture(GL_TEXTURE_2D, saturationTexture);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, image.size.width, image.size.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    // Bind the texture to your FBO
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, saturationTexture, 0);
    
    // Test if everything failed
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        printf("failed to make complete framebuffer object %x", status);
    }
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glBindTexture(GL_TEXTURE_2D, 0);
}

-(void)createOffscreenBuffer:(UIImage *)image
{
    glGenFramebuffers(1, &_offscreenFramebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _offscreenFramebuffer);

    // Create the texture
    glGenTextures(1, &offscreenTexture);
    glBindTexture(GL_TEXTURE_2D, offscreenTexture);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, image.size.width, image.size.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

    // Bind the texture to your FBO
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, offscreenTexture, 0);

    // Test if everything failed
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        printf("failed to make complete framebuffer object %x", status);
    }
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glBindTexture(GL_TEXTURE_2D, 0);
}

// step6
-(void)setupRenderScreenViewPort
{
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

// step7
-(void)setupBrightnessShader
{
    brightnessShader = [[MYShaderCompiler alloc] initWithVertexShader:@"vertexShader.vsh" fragmentShader:@"Brightness_GL.fsh"];
    [brightnessShader prepareToDraw];
    _brightnessPositionSlot = [brightnessShader attributeIndex:@"a_Position"];
    _brightnessTextureSlot = [brightnessShader uniformIndex:@"u_Texture"];
    _brightnessTextureCoordSlot = [brightnessShader attributeIndex:@"a_TexCoordIn"];
    _brightness = [brightnessShader uniformIndex:@"brightness"];
}

-(void)setupSaturationShader
{
    saturationShader = [[MYShaderCompiler alloc] initWithVertexShader:@"vertexShader.vsh" fragmentShader:@"saturation_GL.fsh"];
    [saturationShader prepareToDraw];
    _saturationPositionSlot = [saturationShader attributeIndex:@"a_Position"];
    _saturationTextureSlot = [saturationShader uniformIndex:@"u_Texture"];
    _saturationTextureCoordSlot = [saturationShader attributeIndex:@"a_TexCoordIn"];
    _saturation = [saturationShader uniformIndex:@"saturation"];
}

// step8
-(void)setupRenderShader
{
    renderShader = [[MYShaderCompiler alloc] initWithVertexShader:@"vertexShader.vsh" fragmentShader:@"fragmentShader.fsh"];
    [renderShader prepareToDraw];
    _renderPositionSlot = [renderShader attributeIndex:@"a_Position"];
    _renderTextureSlot = [renderShader uniformIndex:@"u_Texture"];
    _renderTextureCoordSlot = [renderShader attributeIndex:@"a_TexCoordIn"];
}

// step9
-(void)renderToScreenWithTexture:(GLuint)texture
{
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    [self setupRenderScreenViewPort];
    [renderShader prepareToDraw];
    
    // 传递顶点坐标
    UIImage *image = processImage;
    CGRect realRect = AVMakeRectWithAspectRatioInsideRect(image.size, self.view.bounds);
    CGFloat widthRatio = realRect.size.width/self.view.bounds.size.width;
    CGFloat heightRatio = realRect.size.height/self.view.bounds.size.height;
    
    const GLfloat vertices[] = {
        -widthRatio, -heightRatio, 0,
        widthRatio, -heightRatio, 0,
        -widthRatio, heightRatio, 0,
        widthRatio, heightRatio, 0
    };
    glEnableVertexAttribArray(_renderPositionSlot);
    glVertexAttribPointer(_renderPositionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    
    // 传递纹理坐标
    // normal
    static const GLfloat coords[] = {
        0, 0,
        1, 0,
        0, 1,
        1, 1
    };
    glEnableVertexAttribArray(_renderTextureCoordSlot);
    glVertexAttribPointer(_renderTextureCoordSlot, 2, GL_FLOAT, GL_FALSE, 0, coords);
    
    glActiveTexture(GL_TEXTURE5);
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(_renderTextureSlot, 5);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    [_eaglContext presentRenderbuffer:GL_RENDERBUFFER];
}

-(void)drawSaturationRawImage
{
    // 传递顶点数据
    const GLfloat vertices[] = {
        -1, -1, 0,   //左下
        1,  -1, 0,   //右下
        -1, 1,  0,   //左上
        1,  1,  0 }; //右上
    glEnableVertexAttribArray(_saturationPositionSlot);
    glVertexAttribPointer(_saturationPositionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    
    // 传递纹理数据
    // normal
    static const GLfloat coords[] = {
        0, 0,
        1, 0,
        0, 1,
        1, 1
    };
    glEnableVertexAttribArray(_saturationTextureCoordSlot);
    glVertexAttribPointer(_saturationTextureCoordSlot, 2, GL_FLOAT, GL_FALSE, 0, coords);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

- (void)drawBrightnessRawImage {
    // 传递顶点数据
    const GLfloat vertices[] = {
        -1, -1, 0,   //左下
        1,  -1, 0,   //右下
        -1, 1,  0,   //左上
        1,  1,  0 }; //右上
    glEnableVertexAttribArray(_brightnessPositionSlot);
    glVertexAttribPointer(_brightnessPositionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    
    // 传递纹理数据
    // normal
    static const GLfloat coords[] = {
        0, 0,
        1, 0,
        0, 1,
        1, 1
    };
    
    glEnableVertexAttribArray(_brightnessTextureCoordSlot);
    glVertexAttribPointer(_brightnessTextureCoordSlot, 2, GL_FLOAT, GL_FALSE, 0, coords);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

-(void)originalBrightnessTextureAndSaturationTexture
{
    // 生成对比度原始缓存
    // 让OpenGL绑定saturation的frameBuffer
    glBindFramebuffer(GL_FRAMEBUFFER, _saturationFramebuffer);
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, (GLsizei)processImage.size.width, (GLsizei)processImage.size.height);
    
    // 使用对比度shader
    [saturationShader prepareToDraw];
    // 传递调节对比度的值区间 (0 - 2)
    glUniform1f(_saturation, 1.0);
    // 传递原始纹理数据
    glActiveTexture(GL_TEXTURE5);
    glBindTexture(GL_TEXTURE_2D, originalTexture);
    glUniform1i(_saturationTextureSlot, 5);
    
    // 开始绘制
    [self drawSaturationRawImage];
    
    // 生成亮度原始缓存
    // 让OpenGL绑定brightness的frameBuffer
    glBindFramebuffer(GL_FRAMEBUFFER, _brightnessFramebuffer);
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, (GLsizei)processImage.size.width, (GLsizei)processImage.size.height);
    
    // 使用亮度shader
    [brightnessShader prepareToDraw];
    // 传递亮度的值区间 (-1 - 1)
    glUniform1f(_brightness, 0.0);
    // 传递原始纹理数据
    glActiveTexture(GL_TEXTURE5);
    glBindTexture(GL_TEXTURE_2D, originalTexture);
    glUniform1i(_brightnessTextureSlot, 5);
    
    // 开始绘制
    [self drawBrightnessRawImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Texture
-(GLuint)getTextureFromImage:(UIImage *)image
{
    // CG
    CGImageRef imageRef = [image CGImage];
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    GLubyte *textureData = (GLubyte *)malloc(width * height * 4);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(textureData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    // 纹理
    glEnable(GL_TEXTURE_2D);
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, textureData);
    glBindTexture(GL_TEXTURE_2D, 0);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(textureData);
    return texName;
}

#pragma mark - 调节滤镜
- (IBAction)saturationSliderAction:(UISlider *)sender {
    // 让OpenGL绑定saturation的frameBuffer
    glBindFramebuffer(GL_FRAMEBUFFER, _saturationFramebuffer);
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, (GLsizei)processImage.size.width, (GLsizei)processImage.size.height);
    
    // 使用对比度shader
    [saturationShader prepareToDraw];
    // 传递调节对比度的值区间 (0 - 2)
    glUniform1f(_saturation, sender.value);
    // 传递纹理数据
    glActiveTexture(GL_TEXTURE5);
    glBindTexture(GL_TEXTURE_2D, brightnessTexture);
    glUniform1i(_saturationTextureSlot, 5);
    
    // 开始绘制
    [self drawSaturationRawImage];
    // 绘制纹理完毕，开始绘制到屏幕上
    [self renderToScreenWithTexture:saturationTexture];
    filterType = SaturationType;
}

- (IBAction)brightnessSliderAction:(UISlider *)sender {
    // 让OpenGL绑定brightness的frameBuffer
    glBindFramebuffer(GL_FRAMEBUFFER, _brightnessFramebuffer);
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, (GLsizei)processImage.size.width, (GLsizei)processImage.size.height);
    
    // 使用亮度shader
    [brightnessShader prepareToDraw];
    // 传递亮度的值区间 (-1 - 1)
    glUniform1f(_brightness, sender.value);
    // 传递纹理数据
    glActiveTexture(GL_TEXTURE5);
    glBindTexture(GL_TEXTURE_2D, saturationTexture);
    glUniform1i(_brightnessTextureSlot, 5);
    
    // 开始绘制
    [self drawBrightnessRawImage];
    // 绘制纹理完毕，开始绘制到屏幕上
    [self renderToScreenWithTexture:brightnessTexture];
    filterType = BrightType;
}

#pragma mark - 重置
- (IBAction)reset:(UIButton *)sender {
    filterType = DefaultType;
    [self originalBrightnessTextureAndSaturationTexture];
    self.saturationSlider.value = 1.0;
    self.brightnessSlider.value = 0.0;
    [self renderToScreenWithTexture:originalTexture];
}

#pragma mark - 保存图片
- (IBAction)getImage:(UIButton *)sender
{
    switch (filterType) {
        case DefaultType:
        {
            glBindFramebuffer(GL_FRAMEBUFFER, _offscreenFramebuffer);
            glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
            glClear(GL_COLOR_BUFFER_BIT);
            glViewport(0, 0, (GLsizei)processImage.size.width, (GLsizei)processImage.size.height);
            [renderShader prepareToDraw];
            
            // 传递顶点数据
            const GLfloat vertices[] = {
                -1, -1, 0,   //左下
                1,  -1, 0,   //右下
                -1, 1,  0,   //左上
                1,  1,  0 }; //右上
            glEnableVertexAttribArray(_renderPositionSlot);
            glVertexAttribPointer(_renderPositionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
            
            // 传递原始纹理数据
            glActiveTexture(GL_TEXTURE5);
            glBindTexture(GL_TEXTURE_2D, originalTexture);
            glUniform1i(_saturationTextureSlot, 5);
            // normal
            static const GLfloat coords[] = {
                0, 0,
                1, 0,
                0, 1,
                1, 1
            };
            glEnableVertexAttribArray(_renderTextureCoordSlot);
            glVertexAttribPointer(_renderTextureCoordSlot, 2, GL_FLOAT, GL_FALSE, 0, coords);
            
            glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        }
            break;
        case SaturationType:
        {
            // 让OpenGL绑定saturation的frameBuffer
            glBindFramebuffer(GL_FRAMEBUFFER, _offscreenFramebuffer);
            glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
            glClear(GL_COLOR_BUFFER_BIT);
            glViewport(0, 0, (GLsizei)processImage.size.width, (GLsizei)processImage.size.height);
            
            // 使用对比度shader
            [saturationShader prepareToDraw];
            // 传递调节对比度的值区间 (0 - 2)
            glUniform1f(_saturation, self.saturationSlider.value);
            // 传递纹理数据
            glActiveTexture(GL_TEXTURE5);
            glBindTexture(GL_TEXTURE_2D, brightnessTexture);
            glUniform1i(_saturationTextureSlot, 5);
            
            // 开始绘制
            [self drawSaturationRawImage];
        }
            break;
        case BrightType:
        {
            // 让OpenGL绑定brightness的frameBuffer
            glBindFramebuffer(GL_FRAMEBUFFER, _offscreenFramebuffer);
            glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
            glClear(GL_COLOR_BUFFER_BIT);
            glViewport(0, 0, (GLsizei)processImage.size.width, (GLsizei)processImage.size.height);
            
            // 使用亮度shader
            [brightnessShader prepareToDraw];
            // 传递亮度的值区间 (-1 - 1)
            glUniform1f(_brightness, self.brightnessSlider.value);
            // 传递纹理数据
            glActiveTexture(GL_TEXTURE5);
            glBindTexture(GL_TEXTURE_2D, saturationTexture);
            glUniform1i(_brightnessTextureSlot, 5);
            
            // 开始绘制
            [self drawBrightnessRawImage];
        }
            break;
        default:
            break;
    }
    
    [self getImageFromBuffe:processImage.size.width withHeight:processImage.size.height];
}

-(UIImage *)getImageFromBuffe:(int)width withHeight:(int)height
{
    GLint x = 0, y = 0;
    NSInteger dataLength = width * height * 4;
    GLubyte *data = (GLubyte *)malloc(dataLength * sizeof(GLubyte));
    
    glPixelStorei(GL_PACK_ALIGNMENT, 4);
    glReadPixels(x, y, width, height, GL_RGBA, GL_UNSIGNED_BYTE, data);//GPU渲染完数据在显存，回传内存的唯一方式glReadPixels函数。
    
    CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, data, dataLength, NULL);//为图片绘制提供数据
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();//提供色彩空间
    CGImageRef iref = CGImageCreate(width, height, 8, 32, width * 4, colorSpaceRef, kCGBitmapByteOrder32Big|kCGImageAlphaPremultipliedLast, ref, NULL, true, kCGRenderingIntentDefault);// 创建CG图像
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef cgcontext = UIGraphicsGetCurrentContext();
    CGContextSetBlendMode(cgcontext, kCGBlendModeCopy);
    CGContextDrawImage(cgcontext, CGRectMake(0.0, 0.0, width, height), iref);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    free(data);
    CFRelease(ref);
    CFRelease(colorSpaceRef);
    CGImageRelease(iref);
    return image;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString*message =@"呵呵";
    if(!error) {
        message =@"成功保存到相册";
        
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertControl addAction:action];
        [self presentViewController:alertControl animated:YES completion:nil];
        
    } else {
        message = [error description];
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertControl addAction:action];
        [self presentViewController:alertControl animated:YES completion:nil];
    }
}

@end
