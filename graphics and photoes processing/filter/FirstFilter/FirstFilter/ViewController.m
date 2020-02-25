//
//  ViewController.m
//  FirstFilter
//
//  Created by Gguomingyue on 2017/11/16.
//  Copyright © 2017年 guomingyue. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) CIContext* context;
@property (nonatomic, strong) CIImage *inputImage;
@property (nonatomic, strong) CIImage *outputImage;
@property (nonatomic, strong) CIFilter *filter;
@property (weak, nonatomic) IBOutlet UISlider *saturationSlider;
@property (weak, nonatomic) IBOutlet UISlider *brightnessSlider;
@property (weak, nonatomic) IBOutlet UISlider *contrastSlider;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.image = [UIImage imageNamed:@"ice.jpg"];
    
    // CPU render
//    NSNumber *number = [NSNumber numberWithBool:YES];
//    NSDictionary *option = @{kCIContextUseSoftwareRenderer:number};
//    self.context = [[CIContext alloc] initWithOptions:option];
    // GPU render 推荐,但注意GPU的CIContext无法跨应用访问，例如直接在UIImagePickerController的完成方法中调用上下文处理就会自动降级为CPU渲染，所以推荐现在完成方法中保存图像，然后在主程序中调用
    self.context = [[CIContext alloc] initWithOptions:nil];
    //OpenGL优化过的图像上下文
//    EAGLContext *eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
//    self.context = [CIContext contextWithEAGLContext:eaglContext];
    
    self.inputImage = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    self.filter = [CIFilter filterWithName:@"CIColorControls"];
    [self.filter setValue:self.inputImage forKey:@"inputImage"];
    [self showFilters];
}

-(void)setImage
{
    self.outputImage = [self.filter outputImage];
    CGImageRef tempCGImage = [self.context createCGImage:self.outputImage fromRect:[self.outputImage extent]];
    self.imageView.image = [UIImage imageWithCGImage:tempCGImage];
    CGImageRelease(tempCGImage);
}

-(void)showFilters
{
    NSArray *filterNames=[CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    for (NSString *filterName in filterNames) {
        CIFilter *filter=[CIFilter filterWithName:filterName];
        NSLog(@"\rfilter:%@\rattributes:%@",filterName,[filter attributes]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resetAction:(id)sender {
    NSLog(@"resetAction");
    [self.saturationSlider setValue:1.0 animated:YES];
    [self.brightnessSlider setValue:0.0 animated:YES];
    [self.contrastSlider setValue:1.0 animated:YES];
    [self.filter setValue:@1.0f forKey:@"inputSaturation"];
    [self.filter setValue:@0.0f forKey:@"inputBrightness"];
    [self.filter setValue:@1.0f forKey:@"inputContrast"];
    [self setImage];
}
- (IBAction)saturationAction:(id)sender {
    NSLog(@"saturationAction");
    UISlider *slider = (UISlider *)sender;
    [self.filter setValue:@(slider.value) forKey:@"inputSaturation"];
    [self setImage];
}
- (IBAction)brightnessAction:(id)sender {
    NSLog(@"brightnessAction");
    UISlider *slider = (UISlider *)sender;
    [self.filter setValue:@(slider.value) forKey:@"inputBrightness"];
    [self setImage];
}
- (IBAction)contrastAction:(id)sender {
    NSLog(@"contrastAction");
    UISlider *slider = (UISlider *)sender;
    [self.filter setValue:@(slider.value) forKey:@"inputContrast"];
    [self setImage];
}


@end
