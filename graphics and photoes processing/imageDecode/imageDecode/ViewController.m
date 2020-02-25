//
//  ViewController.m
//  imageDecode
//
//  Created by Gguomingyue on 2018/3/19.
//  Copyright © 2018年 Gmingyue. All rights reserved.
//

#import "ViewController.h"
#import "UIView+YYAdd.h"
#import "UIControl+YYAdd.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UISegmentedControl *seg0;
@property (nonatomic, strong) UISegmentedControl *seg1;
@property (nonatomic, strong) UISlider *slider0;
@property (nonatomic, strong) UISwitch *swich;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView = [UIImageView new];
    self.imageView.size = CGSizeMake(300, 300);
    self.imageView.backgroundColor = [UIColor colorWithWhite:0.790 alpha:1.000];
    self.imageView.centerX = self.view.width / 2;
    
    self.seg0 = [[UISegmentedControl alloc] initWithItems:@[@"baseline",@"progressive/interlaced"]];
    self.seg0.selectedSegmentIndex = 0;
    self.seg0.size = CGSizeMake(_imageView.width, 30);
    self.seg0.centerX = self.view.width / 2;
    
    self.seg1 = [[UISegmentedControl alloc] initWithItems:@[@"PNG"]];
    self.seg1.frame = _seg0.frame;
    self.seg1.selectedSegmentIndex = 0;
    
    self.slider0 = [UISlider new];
    self.slider0.width = _seg0.width;
    [self.slider0 sizeToFit];
    self.slider0.minimumValue = 0;
    self.slider0.maximumValue = 1.05;
    self.slider0.value = 0;
    self.slider0.centerX = self.view.width / 2;
    
    self.swich = [[UISwitch alloc] init];
    self.swich.size = CGSizeMake(60, 30);
    self.swich.centerX = self.view.width / 2;
    
    _imageView.top = 64 + 10;
    _seg0.top = _imageView.bottom + 10;
    _seg1.top = _seg0.bottom + 10;
    _slider0.top = _seg1.bottom + 10;
    _swich.top = _slider0.bottom + 10;
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.seg0];
    [self.view addSubview:self.seg1];
    [self.view addSubview:self.slider0];
    [self.view addSubview:self.swich];
    
    __weak typeof(self) _self = self;
    [_seg0 addBlockForControlEvents:UIControlEventValueChanged block:^(id sender) {
        [_self changed];
    }];
    [_seg1 addBlockForControlEvents:UIControlEventValueChanged block:^(id sender) {
        [_self changed];
    }];
    [_slider0 addBlockForControlEvents:UIControlEventValueChanged block:^(id sender) {
        [_self changed];
    }];
    [_swich addBlockForControlEvents:UIControlEventValueChanged block:^(id  _Nonnull sender) {
        [_self changed];
    }];
}

- (void)changed {
    NSString *name = nil;
    if (_seg0.selectedSegmentIndex == 0) {
        name = @"mew_baseline.png";
    } else {
        name = @"mew_interlaced.png";
    }
    
    NSData *data = [self dataNamed:name];
    float progress = _slider0.value;
    
    if (progress == 0) {
        progress = 0.1;
    }
    if (progress > 1) progress = 1;
    NSData *subData = [data subdataWithRange:NSMakeRange(0, data.length * progress)];
    //NSData *subData = [data subdataWithRange:NSMakeRange(0, data.length * 0.5)];
    if (self.swich.on) {
        [self sdMethodAction:subData];
    } else {
        [self yyMethodAction:subData];
    }
    
    
}

-(void)sdMethodAction:(NSData *)subData
{
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)subData, NULL);
    //    NSInteger frames = CGImageSourceGetCount(source);
    //    NSLog(@"frames = %d",frames);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, (CFDictionaryRef)@{(id)kCGImageSourceShouldCache:@(YES)});
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, CGColorSpaceGetDeviceRGB(), kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef imageRefExtended = CGBitmapContextCreateImage(context);
    CFRelease(context);
    CFRelease(imageRef);
    imageRef = imageRefExtended;
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    self.imageView.image = image;
}

-(void)yyMethodAction:(NSData *)subData
{
    CGImageSourceRef source = CGImageSourceCreateIncremental(NULL);
    if (source) CGImageSourceUpdateData(source, (__bridge CFDataRef)subData, false);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, (CFDictionaryRef)@{(id)kCGImageSourceShouldCache:@(YES)});
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(source, 0, NULL);
    NSInteger _width = 0, _height = 0;
    if (properties) {
        
        CFTypeRef value = NULL;
        
        value = CFDictionaryGetValue(properties, kCGImagePropertyPixelWidth);
        if (value) CFNumberGetValue(value, kCFNumberNSIntegerType, &_width);
        value = CFDictionaryGetValue(properties, kCGImagePropertyPixelHeight);
        if (value) CFNumberGetValue(value, kCFNumberNSIntegerType, &_height);
    }
    
    if (_width == width && _height == height) {
        CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, CGColorSpaceGetDeviceRGB(), kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedFirst);
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
        CGImageRef imageRefExtended = CGBitmapContextCreateImage(context);
        CFRelease(context);
        CFRelease(imageRef);
        imageRef = imageRefExtended;
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        self.imageView.image = image;
    } else {
        CGContextRef context = CGBitmapContextCreate(NULL, _width, _height, 8, 0, CGColorSpaceGetDeviceRGB(), kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedFirst);
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
        CGImageRef imageRefExtended = CGBitmapContextCreateImage(context);
        CFRelease(context);
        CFRelease(imageRef);
        imageRef = imageRefExtended;
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        self.imageView.image = image;
    }
    
}

- (NSData *)dataNamed:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@""];
    if (!path) return nil;
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}

CGColorSpaceRef CGColorSpaceGetDeviceRGB() {
    static CGColorSpaceRef space;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        space = CGColorSpaceCreateDeviceRGB();
    });
    return space;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
